class HaircutVisit {
  final String id;
  final DateTime cutAt;
  final String service;
  final double price;
  final String? note;
  final String createdBy;

  HaircutVisit({
    required this.id,
    required this.cutAt,
    required this.service,
    required this.price,
    this.note,
    required this.createdBy,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'cutAt': cutAt.toIso8601String(),
        'service': service,
        'price': price,
        'note': note,
        'createdBy': createdBy,
      };

  factory HaircutVisit.fromMap(Map<String, dynamic> map) {
    return HaircutVisit(
      id: map['id'] ?? '',
      cutAt: DateTime.tryParse(map['cutAt'] ?? '') ?? DateTime.now(),
      service: map['service'] ?? 'Cắt tóc',
      price: (map['price'] as num?)?.toDouble() ?? 0,
      note: map['note'],
      createdBy: map['createdBy'] ?? 'System',
    );
  }
}
