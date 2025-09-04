class Homework {
  final String id;
  final String title;
  final String description;
  final String subject;
  final String className;
  final String section;
  final DateTime dueDate;
  final DateTime assignedDate;
  final String teacherId;
  final String teacherName;
  final String status;
  final String schoolId;
  final DateTime createdAt;
  final DateTime? updatedAt;

  Homework({
    required this.id,
    required this.title,
    required this.description,
    required this.subject,
    required this.className,
    required this.section,
    required this.dueDate,
    required this.assignedDate,
    required this.teacherId,
    required this.teacherName,
    required this.status,
    required this.schoolId,
    required this.createdAt,
    this.updatedAt,
  });

  factory Homework.fromJson(Map<String, dynamic> json) {
    return Homework(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      subject: json['subject'] ?? '',
      className: json['className'] ?? json['class'] ?? '',
      section: json['section'] ?? 'A',
      dueDate: DateTime.tryParse(json['dueDate'] ?? '') ?? DateTime.now(),
      assignedDate: DateTime.tryParse(json['assignedDate'] ?? '') ?? DateTime.now(),
      teacherId: json['teacherId']?.toString() ?? '',
      teacherName: json['teacherName'] ?? '',
      status: json['status'] ?? 'Active',
      schoolId: json['schoolId'] ?? '',
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      updatedAt: json['updatedAt'] != null ? DateTime.tryParse(json['updatedAt']!) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'subject': subject,
      'className': className,
      'section': section,
      'dueDate': dueDate.toIso8601String(),
      'assignedDate': assignedDate.toIso8601String(),
      'teacherId': teacherId,
      'teacherName': teacherName,
      'status': status,
      'schoolId': schoolId,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  Homework copyWith({
    String? id,
    String? title,
    String? description,
    String? subject,
    String? className,
    String? section,
    DateTime? dueDate,
    DateTime? assignedDate,
    String? teacherId,
    String? teacherName,
    String? status,
    String? schoolId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Homework(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      subject: subject ?? this.subject,
      className: className ?? this.className,
      section: section ?? this.section,
      dueDate: dueDate ?? this.dueDate,
      assignedDate: assignedDate ?? this.assignedDate,
      teacherId: teacherId ?? this.teacherId,
      teacherName: teacherName ?? this.teacherName,
      status: status ?? this.status,
      schoolId: schoolId ?? this.schoolId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Homework && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Homework(id: $id, title: $title, subject: $subject, className: $className, section: $section, schoolId: $schoolId)';
  }
}

