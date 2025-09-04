class Bus {
  final String id;
  final String busNumber;
  final String driverName;
  final String driverPhone;
  final String routeName;
  final String schoolId;
  final double latitude;
  final double longitude;
  final DateTime lastUpdated;
  final bool isActive;
  final List<String> studentIds;
  final String currentStatus; // 'at_school', 'on_route', 'returning'

  Bus({
    required this.id,
    required this.busNumber,
    required this.driverName,
    required this.driverPhone,
    required this.routeName,
    required this.schoolId,
    required this.latitude,
    required this.longitude,
    required this.lastUpdated,
    required this.isActive,
    required this.studentIds,
    required this.currentStatus,
  });

  factory Bus.fromJson(Map<String, dynamic> json) {
    return Bus(
      id: json['id']?.toString() ?? '',
      busNumber: json['busNumber'] ?? '',
      driverName: json['driverName'] ?? '',
      driverPhone: json['driverPhone'] ?? '',
      routeName: json['routeName'] ?? '',
      schoolId: json['schoolId'] ?? '',
      latitude: (json['latitude'] ?? 0.0).toDouble(),
      longitude: (json['longitude'] ?? 0.0).toDouble(),
      lastUpdated: DateTime.parse(json['lastUpdated'] ?? DateTime.now().toIso8601String()),
      isActive: json['isActive'] ?? false,
      studentIds: List<String>.from(json['studentIds'] ?? []),
      currentStatus: json['currentStatus'] ?? 'at_school',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'busNumber': busNumber,
      'driverName': driverName,
      'driverPhone': driverPhone,
      'routeName': routeName,
      'schoolId': schoolId,
      'latitude': latitude,
      'longitude': longitude,
      'lastUpdated': lastUpdated.toIso8601String(),
      'isActive': isActive,
      'studentIds': studentIds,
      'currentStatus': currentStatus,
    };
  }

  Bus copyWith({
    String? id,
    String? busNumber,
    String? driverName,
    String? driverPhone,
    String? routeName,
    String? schoolId,
    double? latitude,
    double? longitude,
    DateTime? lastUpdated,
    bool? isActive,
    List<String>? studentIds,
    String? currentStatus,
  }) {
    return Bus(
      id: id ?? this.id,
      busNumber: busNumber ?? this.busNumber,
      driverName: driverName ?? this.driverName,
      driverPhone: driverPhone ?? this.driverPhone,
      routeName: routeName ?? this.routeName,
      schoolId: schoolId ?? this.schoolId,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      isActive: isActive ?? this.isActive,
      studentIds: studentIds ?? this.studentIds,
      currentStatus: currentStatus ?? this.currentStatus,
    );
  }
}
