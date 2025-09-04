class FeeStructure {
  final String id;
  final String schoolId; // NEW: Link to school
  final String className;
  final String feeType;
  final double amount;
  final String frequency; // monthly, quarterly, yearly
  final DateTime dueDate;
  final String description;
  final bool isActive;
  final DateTime createdAt;

  FeeStructure({
    required this.id,
    required this.schoolId,
    required this.className,
    required this.feeType,
    required this.amount,
    required this.frequency,
    required this.dueDate,
    required this.description,
    required this.isActive,
    required this.createdAt,
  });

  factory FeeStructure.fromJson(Map<String, dynamic> json) {
    return FeeStructure(
      id: json['id'] ?? '',
      schoolId: json['schoolId'] ?? '',
      className: json['className'] ?? '',
      feeType: json['feeType'] ?? '',
      amount: (json['amount'] ?? 0.0).toDouble(),
      frequency: json['frequency'] ?? 'monthly',
      dueDate: json['dueDate'] != null 
          ? DateTime.parse(json['dueDate']) 
          : DateTime.now(),
      description: json['description'] ?? '',
      isActive: json['isActive'] ?? true,
      createdAt: json['createdAt'] != null 
          ? DateTime.parse(json['createdAt']) 
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'schoolId': schoolId,
      'className': className,
      'feeType': feeType,
      'amount': amount,
      'frequency': frequency,
      'dueDate': dueDate.toIso8601String(),
      'description': description,
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  FeeStructure copyWith({
    String? id,
    String? schoolId,
    String? className,
    String? feeType,
    double? amount,
    String? frequency,
    DateTime? dueDate,
    String? description,
    bool? isActive,
    DateTime? createdAt,
  }) {
    return FeeStructure(
      id: id ?? this.id,
      schoolId: schoolId ?? this.schoolId,
      className: className ?? this.className,
      feeType: feeType ?? this.feeType,
      amount: amount ?? this.amount,
      frequency: frequency ?? this.frequency,
      dueDate: dueDate ?? this.dueDate,
      description: description ?? this.description,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() {
    return 'FeeStructure(id: $id, schoolId: $schoolId, className: $className, feeType: $feeType, amount: $amount, frequency: $frequency, dueDate: $dueDate, description: $description, isActive: $isActive, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FeeStructure &&
        other.id == id &&
        other.schoolId == schoolId &&
        other.className == className &&
        other.feeType == feeType &&
        other.amount == amount &&
        other.frequency == frequency &&
        other.dueDate == dueDate &&
        other.description == description &&
        other.isActive == isActive &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        schoolId.hashCode ^
        className.hashCode ^
        feeType.hashCode ^
        amount.hashCode ^
        frequency.hashCode ^
        dueDate.hashCode ^
        description.hashCode ^
        isActive.hashCode ^
        createdAt.hashCode;
  }
}


