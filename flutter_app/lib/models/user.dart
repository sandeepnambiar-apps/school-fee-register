class User {
  final String id;
  final String mobileNumber;
  final String fullName;
  final String username;
  final String email;
  final String role;
  final String? schoolId;
  final String? classAssigned;
  final String? subjectTaught;
  final String status;
  final bool isActive;
  final bool isFirstTime;
  final DateTime createdAt;
  final DateTime? updatedAt;

  User({
    required this.id,
    required this.mobileNumber,
    required this.fullName,
    required this.username,
    required this.email,
    required this.role,
    this.schoolId,
    this.classAssigned,
    this.subjectTaught,
    required this.status,
    required this.isActive,
    required this.isFirstTime,
    required this.createdAt,
    this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id']?.toString() ?? '',
      mobileNumber: json['mobileNumber'] ?? '',
      fullName: json['name'] ?? json['fullName'] ?? '',
      username: json['username'] ?? json['mobileNumber'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? '',
      schoolId: json['schoolId']?.toString(),
      classAssigned: json['classAssigned'],
      subjectTaught: json['subjectTaught'],
      status: json['status'] ?? 'ACTIVE',
      isActive: json['isActive'] ?? true,
      isFirstTime: json['isFirstTime'] ?? false,
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      updatedAt: json['updatedAt'] != null ? DateTime.tryParse(json['updatedAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'mobileNumber': mobileNumber,
      'fullName': fullName,
      'username': username,
      'email': email,
      'role': role,
      'schoolId': schoolId,
      'classAssigned': classAssigned,
      'subjectTaught': subjectTaught,
      'status': status,
      'isActive': isActive,
      'isFirstTime': isFirstTime,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  User copyWith({
    String? id,
    String? mobileNumber,
    String? fullName,
    String? username,
    String? email,
    String? role,
    String? schoolId,
    String? classAssigned,
    String? subjectTaught,
    String? status,
    bool? isActive,
    bool? isFirstTime,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return User(
      id: id ?? this.id,
      mobileNumber: mobileNumber ?? this.mobileNumber,
      fullName: fullName ?? this.fullName,
      username: username ?? this.username,
      email: email ?? this.email,
      role: role ?? this.role,
      schoolId: schoolId ?? this.schoolId,
      classAssigned: classAssigned ?? this.classAssigned,
      subjectTaught: subjectTaught ?? this.subjectTaught,
      status: status ?? this.status,
      isActive: isActive ?? this.isActive,
      isFirstTime: isFirstTime ?? this.isFirstTime,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}