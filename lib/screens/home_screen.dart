import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:haircut/models/customer.dart';
import 'package:haircut/models/haircut_visit.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Customer> _sampleCustomers = [
    Customer(
      id: '1',
      name: 'Nguyễn Minh',
      phone: '0901234567',
      isFollowed: true,
      createdAt: DateTime.now().subtract(const Duration(days: 15)),
      visits: [
        HaircutVisit(
          id: 'v1',
          cutAt: DateTime.now().subtract(const Duration(days: 5)),
          service: 'Cắt tóc nam',
          price: 120000,
          createdBy: 'Admin',
        ),
        HaircutVisit(
          id: 'v2',
          cutAt: DateTime.now().subtract(const Duration(days: 20)),
          service: 'Cắt + tạo kiểu',
          price: 180000,
          createdBy: 'Admin',
        ),
      ],
    ),
    Customer(
      id: '2',
      name: 'Trần Huy',
      phone: '0987654321',
      isFollowed: false,
      createdAt: DateTime.now().subtract(const Duration(days: 40)),
      visits: [
        HaircutVisit(
          id: 'v3',
          cutAt: DateTime.now().subtract(const Duration(days: 10)),
          service: 'Cắt tóc',
          price: 110000,
          createdBy: 'Admin',
        ),
      ],
    ),
    Customer(
      id: '3',
      name: 'Võ An',
      phone: '0912345678',
      isFollowed: true,
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
      visits: [
        HaircutVisit(
          id: 'v4',
          cutAt: DateTime.now().subtract(const Duration(days: 2)),
          service: 'Cắt + gội',
          price: 150000,
          createdBy: 'Admin',
        ),
      ],
    ),
  ];

  final TextEditingController _searchController = TextEditingController();
  List<Customer> _customers = [];

  @override
  void initState() {
    super.initState();
    _customers = _sampleCustomers;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Customer> get _filteredCustomers {
    final query = _searchController.text.trim().toLowerCase();
    if (query.isEmpty) return _customers;

    return _customers.where((customer) {
      final matchesName = customer.name.toLowerCase().contains(query);
      final matchesPhone = customer.phone.toLowerCase().contains(query);
      return matchesName || matchesPhone;
    }).toList();
  }

  double get _totalRevenue {
    return _customers.fold(0.0, (sum, customer) => sum + customer.totalRevenue);
  }

  int get _followedCount => _customers.where((c) => c.isFollowed).length;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Haircut Manager'),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddCustomerDialog,
        icon: const Icon(Icons.add),
        label: const Text('Thêm khách'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              TextField(
                controller: _searchController,
                onChanged: (_) => setState(() {}),
                decoration: const InputDecoration(
                  hintText: 'Tìm khách hàng...',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  _StatCard(
                    title: 'Doanh thu',
                    value: NumberFormat.currency(locale: 'vi_VN', symbol: 'đ', decimalDigits: 0).format(_totalRevenue),
                    color: Colors.indigo,
                  ),
                  const SizedBox(width: 12),
                  _StatCard(
                    title: 'Follow',
                    value: '$_followedCount',
                    color: Colors.red,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Khách hàng (${_filteredCustomers.length})',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: ListView.builder(
                  itemCount: _filteredCustomers.length,
                  itemBuilder: (context, index) {
                    final customer = _filteredCustomers[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        leading: CircleAvatar(
                          radius: 26,
                          backgroundColor: Colors.grey.shade200,
                          child: Text(
                            customer.name.isNotEmpty ? customer.name[0].toUpperCase() : '?',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        title: Text(customer.name),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(customer.phone),
                            const SizedBox(height: 4),
                            Text(
                              'Lần gần nhất: ${DateFormat('dd/MM/yyyy').format(customer.lastVisit)}',
                              style: const TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              customer.isFollowed ? Icons.favorite : Icons.favorite_border,
                              color: customer.isFollowed ? Colors.red : Colors.grey,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              NumberFormat.currency(locale: 'vi_VN', symbol: 'đ', decimalDigits: 0).format(customer.totalRevenue),
                              style: const TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                        onTap: () {
                          _showCustomerDetail(customer);
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showCustomerDetail(Customer customer) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text(customer.name),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('SĐT: ${customer.phone}'),
                const SizedBox(height: 8),
                Text('Follow: ${customer.isFollowed ? 'Có' : 'Không'}'),
                const SizedBox(height: 8),
                Text('Tổng doanh thu: ${NumberFormat.currency(locale: 'vi_VN', symbol: 'đ', decimalDigits: 0).format(customer.totalRevenue)}'),
                const SizedBox(height: 16),
                const Text('Lịch sử cắt:'),
                ...customer.visits.map((visit) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(
                      '- ${DateFormat('dd/MM/yyyy').format(visit.cutAt)} • ${visit.service} • ${NumberFormat.currency(locale: 'vi_VN', symbol: 'đ', decimalDigits: 0).format(visit.price)}',
                    ),
                  );
                }),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Đóng'),
            ),
          ],
        );
      },
    );
  }

  void _showAddCustomerDialog() {
    final nameController = TextEditingController();
    final phoneController = TextEditingController();
    final serviceController = TextEditingController(text: 'Cắt tóc');
    final priceController = TextEditingController(text: '120000');

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Thêm khách mới'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Tên khách'),
                ),
                TextField(
                  controller: phoneController,
                  decoration: const InputDecoration(labelText: 'Số điện thoại'),
                  keyboardType: TextInputType.phone,
                ),
                TextField(
                  controller: serviceController,
                  decoration: const InputDecoration(labelText: 'Dịch vụ'),
                ),
                TextField(
                  controller: priceController,
                  decoration: const InputDecoration(labelText: 'Giá'),
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Huỷ'),
            ),
            FilledButton(
              onPressed: () {
                final name = nameController.text.trim();
                final phone = phoneController.text.trim();
                if (name.isEmpty || phone.isEmpty) return;

                final newCustomer = Customer(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  name: name,
                  phone: phone,
                  createdAt: DateTime.now(),
                  isFollowed: true,
                  visits: [
                    HaircutVisit(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      cutAt: DateTime.now(),
                      service: serviceController.text.trim().isEmpty ? 'Cắt tóc' : serviceController.text.trim(),
                      price: double.tryParse(priceController.text) ?? 120000,
                      createdBy: 'Staff',
                    ),
                  ],
                );

                setState(() {
                  _customers.insert(0, newCustomer);
                });
                Navigator.pop(context);
              },
              child: const Text('Lưu'),
            ),
          ],
        );
      },
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final Color color;

  const _StatCard({
    super.key,
    required this.title,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
