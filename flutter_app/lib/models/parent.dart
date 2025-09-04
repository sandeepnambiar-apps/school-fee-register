class Parent {
  final int? id;
  final String mobileNumber;
  final String name;
  final String email;
  final bool isActive;
  final DateTime? createdAt;
  final int schoolId;
  final String schoolName;

  Parent({
    this.id,
    required this.mobileNumber,
    required this.name,
    required this.email,
    required this.isActive,
    this.createdAt,
    required this.schoolId,
    required this.schoolName,
  });

  factory Parent.fromJson(Map<String, dynamic> json) {
    return Parent(
      id: json['id'],
      mobileNumber: json['mobileNumber'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      isActive: json['isActive'] ?? true,
      createdAt: json['createdAt'] != null 
          ? DateTime.parse(json['createdAt']) 
          : null,
      schoolId: json['schoolId'] ?? 0,
      schoolName: json['schoolName'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'mobileNumber': mobileNumber,
      'name': name,
      'email': email,
      'isActive': isActive,
      'createdAt': createdAt?.toIso8601String(),
      'schoolId': schoolId,
      'schoolName': schoolName,
    };
  }

  Parent copyWith({
    int? id,
    String? mobileNumber,
    String? name,
    String? email,
    bool? isActive,
    DateTime? createdAt,
    int? schoolId,
    String? schoolName,
  }) {
    return Parent(
      id: id ?? this.id,
      mobileNumber: mobileNumber ?? this.mobileNumber,
      name: name ?? this.name,
      email: email ?? this.email,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      schoolId: schoolId ?? this.schoolId,
      schoolName: schoolName ?? this.schoolName,
    );
  }

  @override
  String toString() {
    return 'Parent(id: $id, mobileNumber: $mobileNumber, name: $name, email: $email, isActive: $isActive, schoolId: $schoolId, schoolName: $schoolName)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Parent &&
        other.id == id &&
        other.mobileNumber == mobileNumber &&
        other.name == name &&
        other.email == email &&
        other.isActive == isActive &&
        other.schoolId == schoolId &&
        other.schoolName == schoolName;
  }

  @override
  int get hashCode {
    return Object.hash(id, mobileNumber, name, email, isActive, schoolId, schoolName);
  }
}

