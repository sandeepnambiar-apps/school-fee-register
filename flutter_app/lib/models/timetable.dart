class TimetableEntry {
  final String id;
  final String subject;
  final String teacherId;
  final String teacherName;
  final String className;
  final String dayOfWeek;
  final String startTime;
  final String endTime;
  final String room;
  final String schoolId;
  final DateTime createdAt;
  final DateTime? updatedAt;

  TimetableEntry({
    required this.id,
    required this.subject,
    required this.teacherId,
    required this.teacherName,
    required this.className,
    required this.dayOfWeek,
    required this.startTime,
    required this.endTime,
    required this.room,
    required this.schoolId,
    required this.createdAt,
    this.updatedAt,
  });

  factory TimetableEntry.fromJson(Map<String, dynamic> json) {
    return TimetableEntry(
      id: json['id']?.toString() ?? '',
      subject: json['subject'] ?? '',
      teacherId: json['teacherId']?.toString() ?? '',
      teacherName: json['teacherName'] ?? '',
      className: json['className'] ?? json['class'] ?? '',
      dayOfWeek: json['dayOfWeek'] ?? '',
      startTime: json['startTime'] ?? '',
      endTime: json['endTime'] ?? '',
      room: json['room'] ?? '',
      schoolId: json['schoolId'] ?? '',
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      updatedAt: json['updatedAt'] != null ? DateTime.tryParse(json['updatedAt']!) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'subject': subject,
      'teacherId': teacherId,
      'teacherName': teacherName,
      'className': className,
      'dayOfWeek': dayOfWeek,
      'startTime': startTime,
      'endTime': endTime,
      'room': room,
      'schoolId': schoolId,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  TimetableEntry copyWith({
    String? id,
    String? subject,
    String? teacherId,
    String? teacherName,
    String? className,
    String? dayOfWeek,
    String? startTime,
    String? endTime,
    String? room,
    String? schoolId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return TimetableEntry(
      id: id ?? this.id,
      subject: subject ?? this.subject,
      teacherId: teacherId ?? this.teacherId,
      teacherName: teacherName ?? this.teacherName,
      className: className ?? this.className,
      dayOfWeek: dayOfWeek ?? this.dayOfWeek,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      room: room ?? this.room,
      schoolId: schoolId ?? this.schoolId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TimetableEntry && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'TimetableEntry(id: $id, subject: $subject, className: $className, dayOfWeek: $dayOfWeek, schoolId: $schoolId)';
  }
}


