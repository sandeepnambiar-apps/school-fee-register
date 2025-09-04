class Mark {
  final String id;
  final String studentId;
  final String studentName;
  final String subject;
  final String className;
  final String examType;
  final double score;
  final double maxScore;
  final String grade;
  final String teacherId;
  final String teacherName;
  final DateTime examDate;
  final String schoolId;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final String? remarks;

  Mark({
    required this.id,
    required this.studentId,
    required this.studentName,
    required this.subject,
    required this.className,
    required this.examType,
    required this.score,
    required this.maxScore,
    required this.grade,
    required this.teacherId,
    required this.teacherName,
    required this.examDate,
    required this.schoolId,
    required this.createdAt,
    this.updatedAt,
    this.remarks,
  });

  factory Mark.fromJson(Map<String, dynamic> json) {
    return Mark(
      id: json['id']?.toString() ?? '',
      studentId: json['studentId']?.toString() ?? '',
      studentName: json['studentName'] ?? '',
      subject: json['subject'] ?? '',
      className: json['className'] ?? json['class'] ?? '',
      examType: json['examType'] ?? '',
      score: (json['score'] ?? 0.0).toDouble(),
      maxScore: (json['maxScore'] ?? 100.0).toDouble(),
      grade: json['grade'] ?? '',
      teacherId: json['teacherId']?.toString() ?? '',
      teacherName: json['teacherName'] ?? '',
      examDate: DateTime.tryParse(json['examDate'] ?? '') ?? DateTime.now(),
      schoolId: json['schoolId'] ?? '',
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      updatedAt: json['updatedAt'] != null ? DateTime.tryParse(json['updatedAt']!) : null,
      remarks: json['remarks'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'studentId': studentId,
      'studentName': studentName,
      'subject': subject,
      'className': className,
      'examType': examType,
      'score': score,
      'maxScore': maxScore,
      'grade': grade,
      'teacherId': teacherId,
      'teacherName': teacherName,
      'examDate': examDate.toIso8601String(),
      'schoolId': schoolId,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'remarks': remarks,
    };
  }

  Mark copyWith({
    String? id,
    String? studentId,
    String? studentName,
    String? subject,
    String? className,
    String? examType,
    double? score,
    double? maxScore,
    String? grade,
    String? teacherId,
    String? teacherName,
    DateTime? examDate,
    String? schoolId,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? remarks,
  }) {
    return Mark(
      id: id ?? this.id,
      studentId: studentId ?? this.studentId,
      studentName: studentName ?? this.studentName,
      subject: subject ?? this.subject,
      className: className ?? this.className,
      examType: examType ?? this.examType,
      score: score ?? this.score,
      maxScore: maxScore ?? this.maxScore,
      grade: grade ?? this.grade,
      teacherId: teacherId ?? this.teacherId,
      teacherName: teacherName ?? this.teacherName,
      examDate: examDate ?? this.examDate,
      schoolId: schoolId ?? this.schoolId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      remarks: remarks ?? this.remarks,
    );
  }

  double get percentage => (score / maxScore) * 100;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Mark && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Mark(id: $id, studentName: $studentName, subject: $subject, score: $score/$maxScore, schoolId: $schoolId)';
  }
}


