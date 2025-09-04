class Student {
  final String id;
  final String schoolId; // NEW: Link to school
  final String name;
  final String className;
  final String section;
  final String rollNumber;
  final String fatherName; // Father name
  final String fatherPhone; // Father phone
  final String parentEmail;
  final String motherName; // NEW: Mother name
  final String motherPhone; // NEW: Mother phone
  final String address;
  final String email; // NEW: Student email
  final DateTime dateOfBirth;
  final String gender;
  final DateTime admissionDate;
  final bool isActive;
  // NEW: Additional fields
  final String kidAadhaar;
  final String pen;
  final String fatherAadhaar;
  final String motherAadhaar;
  final String caste;
  final String category;
  // NEW: Parent login code fields
  final String parentLoginCode;
  final bool parentLoginCodeUsed;

  Student({
    required this.id,
    required this.schoolId,
    required this.name,
    required this.className,
    required this.section,
    required this.rollNumber,
    required this.fatherName,
    required this.fatherPhone,
    required this.parentEmail,
    required this.motherName,
    required this.motherPhone,
    required this.address,
    required this.email,
    required this.dateOfBirth,
    required this.gender,
    required this.admissionDate,
    required this.isActive,
    required this.kidAadhaar,
    required this.pen,
    required this.fatherAadhaar,
    required this.motherAadhaar,
    required this.caste,
    required this.category,
    required this.parentLoginCode,
    required this.parentLoginCodeUsed,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['id']?.toString() ?? '',
      schoolId: json['schoolId']?.toString() ?? '',
      name: json['name'] ?? '',
      className: json['className']?.toString() ?? '',
      section: json['section'] ?? '',
      rollNumber: json['rollNumber']?.toString() ?? '',
      fatherName: json['fatherName'] ?? '',
      fatherPhone: json['fatherPhone']?.toString() ?? '',
      parentEmail: json['parentEmail'] ?? '',
      motherName: json['motherName'] ?? '',
      motherPhone: json['motherPhone']?.toString() ?? '',
      address: json['address'] ?? '',
      email: json['email'] ?? '',
      dateOfBirth: json['dateOfBirth'] != null 
          ? DateTime.parse(json['dateOfBirth']) 
          : DateTime.now(),
      gender: json['gender'] ?? '',
      admissionDate: json['admissionDate'] != null 
          ? DateTime.parse(json['admissionDate']) 
          : DateTime.now(),
      isActive: json['isActive'] ?? true,
      kidAadhaar: json['kidAadhaar'] ?? '',
      pen: json['pen'] ?? '',
      fatherAadhaar: json['fatherAadhaar'] ?? '',
      motherAadhaar: json['motherAadhaar'] ?? '',
      caste: json['caste'] ?? '',
      category: json['category'] ?? '',
      parentLoginCode: json['parentLoginCode'] ?? '',
      parentLoginCodeUsed: json['parentLoginCodeUsed'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'schoolId': schoolId,
      'name': name,
      'className': className,
      'section': section,
      'rollNumber': rollNumber,
      'fatherName': fatherName,
      'fatherPhone': fatherPhone,
      'parentEmail': parentEmail,
      'motherName': motherName,
      'motherPhone': motherPhone,
      'address': address,
      'email': email,
      'dateOfBirth': dateOfBirth.toIso8601String(),
      'gender': gender,
      'admissionDate': admissionDate.toIso8601String(),
      'isActive': isActive,
      'kidAadhaar': kidAadhaar,
      'pen': pen,
      'fatherAadhaar': fatherAadhaar,
      'motherAadhaar': motherAadhaar,
      'caste': caste,
      'category': category,
      'parentLoginCode': parentLoginCode,
      'parentLoginCodeUsed': parentLoginCodeUsed,
    };
  }

  Student copyWith({
    String? id,
    String? schoolId,
    String? name,
    String? className,
    String? section,
    String? rollNumber,
    String? fatherName,
    String? fatherPhone,
    String? parentEmail,
    String? motherName,
    String? motherPhone,
    String? address,
    String? email,
    DateTime? dateOfBirth,
    String? gender,
    DateTime? admissionDate,
    bool? isActive,
    String? kidAadhaar,
    String? pen,
    String? fatherAadhaar,
    String? motherAadhaar,
    String? caste,
    String? category,
    String? parentLoginCode,
    bool? parentLoginCodeUsed,
  }) {
    return Student(
      id: id ?? this.id,
      schoolId: schoolId ?? this.schoolId,
      name: name ?? this.name,
      className: className ?? this.className,
      section: section ?? this.section,
      rollNumber: rollNumber ?? this.rollNumber,
      fatherName: fatherName ?? this.fatherName,
      fatherPhone: fatherPhone ?? this.fatherPhone,
      parentEmail: parentEmail ?? this.parentEmail,
      motherName: motherName ?? this.motherName,
      motherPhone: motherPhone ?? this.motherPhone,
      address: address ?? this.address,
      email: email ?? this.email,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      gender: gender ?? this.gender,
      admissionDate: admissionDate ?? this.admissionDate,
      isActive: isActive ?? this.isActive,
      kidAadhaar: kidAadhaar ?? this.kidAadhaar,
      pen: pen ?? this.pen,
      fatherAadhaar: fatherAadhaar ?? this.fatherAadhaar,
      motherAadhaar: motherAadhaar ?? this.motherAadhaar,
      caste: caste ?? this.caste,
      category: category ?? this.category,
      parentLoginCode: parentLoginCode ?? this.parentLoginCode,
      parentLoginCodeUsed: parentLoginCodeUsed ?? this.parentLoginCodeUsed,
    );
  }

  @override
  String toString() {
    return 'Student(id: $id, schoolId: $schoolId, name: $name, className: $className, section: $section, rollNumber: $rollNumber, fatherName: $fatherName, fatherPhone: $fatherPhone, parentEmail: $parentEmail, motherName: $motherName, motherPhone: $motherPhone, address: $address, email: $email, dateOfBirth: $dateOfBirth, gender: $gender, admissionDate: $admissionDate, isActive: $isActive, kidAadhaar: $kidAadhaar, pen: $pen, fatherAadhaar: $fatherAadhaar, motherAadhaar: $motherAadhaar, caste: $caste, category: $category, parentLoginCode: $parentLoginCode, parentLoginCodeUsed: $parentLoginCodeUsed)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Student &&
        other.id == id &&
        other.schoolId == schoolId &&
        other.name == name &&
        other.className == className &&
        other.section == section &&
        other.rollNumber == rollNumber &&
        other.fatherName == fatherName &&
        other.fatherPhone == fatherPhone &&
        other.parentEmail == parentEmail &&
        other.motherName == motherName &&
        other.motherPhone == motherPhone &&
        other.address == address &&
        other.email == email &&
        other.dateOfBirth == dateOfBirth &&
        other.gender == gender &&
        other.admissionDate == admissionDate &&
        other.isActive == isActive &&
        other.kidAadhaar == kidAadhaar &&
        other.pen == pen &&
        other.fatherAadhaar == fatherAadhaar &&
        other.motherAadhaar == motherAadhaar &&
        other.caste == caste &&
        other.category == category &&
        other.parentLoginCode == parentLoginCode &&
        other.parentLoginCodeUsed == parentLoginCodeUsed;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        schoolId.hashCode ^
        name.hashCode ^
        className.hashCode ^
        section.hashCode ^
        rollNumber.hashCode ^
        fatherName.hashCode ^
        fatherPhone.hashCode ^
        parentEmail.hashCode ^
        motherName.hashCode ^
        motherPhone.hashCode ^
        address.hashCode ^
        email.hashCode ^
        dateOfBirth.hashCode ^
        gender.hashCode ^
        admissionDate.hashCode ^
        isActive.hashCode ^
        kidAadhaar.hashCode ^
        pen.hashCode ^
        fatherAadhaar.hashCode ^
        motherAadhaar.hashCode ^
        caste.hashCode ^
        category.hashCode ^
        parentLoginCode.hashCode ^
        parentLoginCodeUsed.hashCode;
  }
}
