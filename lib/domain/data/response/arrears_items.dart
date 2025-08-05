class ArrearItem {
  final int id;
  final int estateId;
  final int userId;
  final double amount;
  final double totalAmount;
  final String duration;
  final DateTime nextDueDate;
  final String type;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int status;

  ArrearItem({
    required this.id,
    required this.estateId,
    required this.userId,
    required this.amount,
    required this.totalAmount,
    required this.duration,
    required this.nextDueDate,
    required this.type,
    required this.createdAt,
    required this.updatedAt,
    required this.status,
  });

  factory ArrearItem.fromJson(Map<String, dynamic> json) {
    return ArrearItem(
      id: json['id'],
      estateId: json['estate_id'],
      userId: json['user_id'],
      amount: (json['amount'] as num).toDouble(),
      totalAmount: (json['total_amount'] as num).toDouble(),
      duration: json['duration'],
      nextDueDate: DateTime.parse(json['next_due_date']),
      type: json['type'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      status: json['status'],
    );
  }
}
