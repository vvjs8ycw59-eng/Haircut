import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:haircut/models/customer.dart';
import 'package:haircut/models/haircut_visit.dart';

class FirebaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  CollectionReference<Map<String, dynamic>> get customersCollection =>
      _db.collection('customers');

  Future<List<Customer>> fetchCustomers() async {
    final snapshot = await customersCollection.orderBy('createdAt', descending: true).get();
    return snapshot.docs.map((doc) => Customer.fromMap(doc.data())).toList();
  }

  Future<void> addCustomer(Customer customer) async {
    await customersCollection.doc(customer.id).set(customer.toMap());
  }

  Future<void> addVisit(String customerId, HaircutVisit visit) async {
    final docRef = customersCollection.doc(customerId);
    final doc = await docRef.get();
    if (!doc.exists) return;

    final customer = Customer.fromMap(doc.data() ?? {});
    final updated = [...customer.visits, visit];

    await docRef.update({
      'visits': updated.map((e) => e.toMap()).toList(),
    });
  }

  Future<String?> uploadImage(String localPath, String fileName) async {
    try {
      final ref = _storage.ref().child('customer_images/$fileName');
      final task = await ref.putString(localPath);
      return await task.ref.getDownloadURL();
    } catch (_) {
      return null;
    }
  }

  Future<double> getMonthlyRevenue(DateTime month) async {
    final snapshot = await customersCollection.get();
    double total = 0;

    for (final doc in snapshot.docs) {
      final customer = Customer.fromMap(doc.data());
      for (final visit in customer.visits) {
        final sameMonth = visit.cutAt.year == month.year && visit.cutAt.month == month.month;
        if (sameMonth) {
          total += visit.price;
        }
      }
    }

    return total;
  }
}
