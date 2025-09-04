class User {
  final String id;
  final String username;
  final String fullName;
  final String email;
  final String phone;
  final String role;
  final String? schoolId; // NULL for Super Admin
  final String status; // ACTIVE, INACTIVE, SUSPENDED
  final DateTime createdAt;
  final DateTime? lastLoginAt;
  final List<String> permissions;
  final String? profileImage;
  final String? department; // For teachers
  final String? subject; // For teachers
  final String? kidId; // For parents

  User({
    required this.id,
    required this.username,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.role,
    this.schoolId,
    this.status = 'ACTIVE',
    required this.createdAt,
    this.lastLoginAt,
    this.permissions = const [],
    this.profileImage,
    this.department,
    this.subject,
    this.kidId,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id']?.toString() ?? '',
      username: json['username'] ?? '',
      fullName: json['fullName'] ?? json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      role: json['role'] ?? '',
      schoolId: json['schoolId']?.toString(),
      status: json['status'] ?? 'ACTIVE',
      createdAt: json['createdAt'] != null 
          ? DateTime.parse(json['createdAt']) 
          : DateTime.now(),
      lastLoginAt: json['lastLoginAt'] != null 
          ? DateTime.parse(json['lastLoginAt']) 
          : null,
      permissions: json['permissions'] != null 
          ? List<String>.from(json['permissions'])
          : [],
      profileImage: json['profileImage'],
      department: json['department'],
      subject: json['subject'],
      kidId: json['kidId']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'fullName': fullName,
      'email': email,
      'phone': phone,
      'role': role,
      'schoolId': schoolId,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'lastLoginAt': lastLoginAt?.toIso8601String(),
      'permissions': permissions,
      'profileImage': profileImage,
      'department': department,
      'subject': subject,
      'kidId': kidId,
    };
  }

  User copyWith({
    String? id,
    String? username,
    String? fullName,
    String? email,
    String? phone,
    String? role,
    String? schoolId,
    String? status,
    DateTime? createdAt,
    DateTime? lastLoginAt,
    List<String>? permissions,
    String? profileImage,
    String? department,
    String? subject,
    String? kidId,
  }) {
    return User(
      id: id ?? this.id,
      username: username ?? this.username,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      role: role ?? this.role,
      schoolId: schoolId ?? this.schoolId,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
      permissions: permissions ?? this.permissions,
      profileImage: profileImage ?? this.profileImage,
      department: department ?? this.department,
      subject: subject ?? this.subject,
      kidId: kidId ?? this.kidId,
    );
  }

  @override
  String toString() {
    return 'User(id: $id, username: $username, fullName: $fullName, role: $role, schoolId: $schoolId, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is User && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  // Helper methods
  bool get isSuperAdmin => role == 'Super Admin';
  bool get isSchoolAdmin => role == 'School Admin';
  bool get isTeacher => role == 'Teacher';
  bool get isParent => role == 'Parent';
  bool get isStudent => role == 'Student';
  bool get isActive => status == 'ACTIVE';
  bool get isInactive => status == 'INACTIVE';
  bool get isSuspended => status == 'SUSPENDED';
}


