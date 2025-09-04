class School {
  final String id;
  final String name;
  final String schoolCode;
  final String address;
  final String city;
  final String state;
  final String country;
  final String postalCode;
  final String phone;
  final String email;
  final String website;
  final String principalName;
  final String principalPhone;
  final String principalEmail;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;

  School({
    required this.id,
    required this.name,
    required this.schoolCode,
    required this.address,
    required this.city,
    required this.state,
    required this.country,
    required this.postalCode,
    required this.phone,
    required this.email,
    required this.website,
    required this.principalName,
    required this.principalPhone,
    required this.principalEmail,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory School.fromJson(Map<String, dynamic> json) {
    return School(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      schoolCode: json['schoolCode'] ?? '',
      address: json['address'] ?? '',
      city: json['city'] ?? '',
      state: json['state'] ?? '',
      country: json['country'] ?? '',
      postalCode: json['postalCode'] ?? '',
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
      website: json['website'] ?? '',
      principalName: json['principalName'] ?? '',
      principalPhone: json['principalPhone'] ?? '',
      principalEmail: json['principalEmail'] ?? '',
      status: json['status'] ?? '',
      createdAt: json['createdAt'] != null 
          ? DateTime.parse(json['createdAt']) 
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null 
          ? DateTime.parse(json['updatedAt']) 
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'schoolCode': schoolCode,
      'address': address,
      'city': city,
      'state': state,
      'country': country,
      'postalCode': postalCode,
      'phone': phone,
      'email': email,
      'website': website,
      'principalName': principalName,
      'principalPhone': principalPhone,
      'principalEmail': principalEmail,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  School copyWith({
    String? id,
    String? name,
    String? schoolCode,
    String? address,
    String? city,
    String? state,
    String? country,
    String? postalCode,
    String? phone,
    String? email,
    String? website,
    String? principalName,
    String? principalPhone,
    String? principalEmail,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return School(
      id: id ?? this.id,
      name: name ?? this.name,
      schoolCode: schoolCode ?? this.schoolCode,
      address: address ?? this.address,
      city: city ?? this.city,
      state: state ?? this.state,
      country: country ?? this.country,
      postalCode: postalCode ?? this.postalCode,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      website: website ?? this.website,
      principalName: principalName ?? this.principalName,
      principalPhone: principalPhone ?? this.principalPhone,
      principalEmail: principalEmail ?? this.principalEmail,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'School(id: $id, name: $name, schoolCode: $schoolCode, address: $address, city: $city, state: $state, country: $country, postalCode: $postalCode, phone: $phone, email: $email, website: $website, principalName: $principalName, principalPhone: $principalPhone, principalEmail: $principalEmail, status: $status, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is School &&
        other.id == id &&
        other.name == name &&
        other.schoolCode == schoolCode &&
        other.address == address &&
        other.city == city &&
        other.state == state &&
        other.country == country &&
        other.postalCode == postalCode &&
        other.phone == phone &&
        other.email == email &&
        other.website == website &&
        other.principalName == principalName &&
        other.principalPhone == principalPhone &&
        other.principalEmail == principalEmail &&
        other.status == status &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        schoolCode.hashCode ^
        address.hashCode ^
        city.hashCode ^
        state.hashCode ^
        country.hashCode ^
        postalCode.hashCode ^
        phone.hashCode ^
        email.hashCode ^
        website.hashCode ^
        principalName.hashCode ^
        principalPhone.hashCode ^
        principalEmail.hashCode ^
        status.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode;
  }
}
