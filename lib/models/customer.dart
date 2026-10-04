import 'package:haircut/models/haircut_visit.dart';

class Customer {
  final String id;
  final String name;
  final String phone;
  final String? avatarUrl;
  final bool isFollowed;
  final DateTime createdAt;
  final List<HaircutVisit> visits;

  Customer({
    required this.id,
    required this.name,
    required this.phone,
    this.avatarUrl,
    this.isFollowed = false,
    required this.createdAt,
    this.visits = const [],
  });

  double get totalRevenue => visits.fold(0.0, (sum, item) => sum + item.price);

  DateTime get lastVisit {
    if (visits.isEmpty) return createdAt;
    return visits.map((v) => v.cutAt).reduce((a, b) => a.isAfter(b) ? a : b);
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'phone': phone,
        'avatarUrl': avatarUrl,
        'isFollowed': isFollowed,
        'createdAt': createdAt.toIso8601String(),
        'visits': visits.map((v) => v.toMap()).toList(),
      };

  factory Customer.fromMap(Map<String, dynamic> map) {
    final visits = (map['visits'] as List? ?? [])
        .map((e) => HaircutVisit.fromMap(Map<String, dynamic>.from(e)))
        .toList();

    return Customer(
      id: map['id'] ?? '',
      name: map['name'] ?? 'Khách hàng',
      phone: map['phone'] ?? '',
      avatarUrl: map['avatarUrl'],
      isFollowed: map['isFollowed'] ?? false,
      createdAt: DateTime.tryParse(map['createdAt'] ?? '') ?? DateTime.now(),
      visits: visits,
    );
  }
}
