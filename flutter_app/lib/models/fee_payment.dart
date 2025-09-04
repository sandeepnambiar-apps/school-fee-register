class FeePayment {
  final String id;
  final String studentId;
  final String studentName;
  final String feeStructureId;
  final String feeType;
  final double amount;
  final double paidAmount;
  final DateTime dueDate;
  final DateTime? paidDate;
  final String status;
  final String paymentMethod;
  final String? transactionId;
  final String? receiptNumber;
  final String? notes;
  final String schoolId;
  final DateTime createdAt;
  final DateTime? updatedAt;

  FeePayment({
    required this.id,
    required this.studentId,
    required this.studentName,
    required this.feeStructureId,
    required this.feeType,
    required this.amount,
    required this.paidAmount,
    required this.dueDate,
    this.paidDate,
    required this.status,
    required this.paymentMethod,
    this.transactionId,
    this.receiptNumber,
    this.notes,
    required this.schoolId,
    required this.createdAt,
    this.updatedAt,
  });

  factory FeePayment.fromJson(Map<String, dynamic> json) {
    return FeePayment(
      id: json['id']?.toString() ?? '',
      studentId: json['studentId']?.toString() ?? '',
      studentName: json['studentName'] ?? '',
      feeStructureId: json['feeStructureId']?.toString() ?? '',
      feeType: json['feeType'] ?? '',
      amount: (json['amount'] ?? 0.0).toDouble(),
      paidAmount: (json['paidAmount'] ?? 0.0).toDouble(),
      dueDate: DateTime.tryParse(json['dueDate'] ?? '') ?? DateTime.now(),
      paidDate: json['paidDate'] != null ? DateTime.tryParse(json['paidDate']!) : null,
      status: json['status'] ?? 'Pending',
      paymentMethod: json['paymentMethod'] ?? 'Cash',
      transactionId: json['transactionId'],
      receiptNumber: json['receiptNumber'],
      notes: json['notes'],
      schoolId: json['schoolId'] ?? '',
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      updatedAt: json['updatedAt'] != null ? DateTime.tryParse(json['updatedAt']!) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'studentId': studentId,
      'studentName': studentName,
      'feeStructureId': feeStructureId,
      'feeType': feeType,
      'amount': amount,
      'paidAmount': paidAmount,
      'dueDate': dueDate.toIso8601String(),
      'paidDate': paidDate?.toIso8601String(),
      'status': status,
      'paymentMethod': paymentMethod,
      'transactionId': transactionId,
      'receiptNumber': receiptNumber,
      'notes': notes,
      'schoolId': schoolId,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  FeePayment copyWith({
    String? id,
    String? studentId,
    String? studentName,
    String? feeStructureId,
    String? feeType,
    double? amount,
    double? paidAmount,
    DateTime? dueDate,
    DateTime? paidDate,
    String? status,
    String? paymentMethod,
    String? transactionId,
    String? receiptNumber,
    String? notes,
    String? schoolId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return FeePayment(
      id: id ?? this.id,
      studentId: studentId ?? this.studentId,
      studentName: studentName ?? this.studentName,
      feeStructureId: feeStructureId ?? this.feeStructureId,
      feeType: feeType ?? this.feeType,
      amount: amount ?? this.amount,
      paidAmount: paidAmount ?? this.paidAmount,
      dueDate: dueDate ?? this.dueDate,
      paidDate: paidDate ?? this.paidDate,
      status: status ?? this.status,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      transactionId: transactionId ?? this.transactionId,
      receiptNumber: receiptNumber ?? this.receiptNumber,
      notes: notes ?? this.notes,
      schoolId: schoolId ?? this.schoolId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  double get remainingAmount => amount - paidAmount;
  bool get isFullyPaid => paidAmount >= amount;
  bool get isOverdue => DateTime.now().isAfter(dueDate) && !isFullyPaid;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FeePayment && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'FeePayment(id: $id, studentName: $studentName, feeType: $feeType, amount: $amount, status: $status, schoolId: $schoolId)';
  }
}


