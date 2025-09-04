class NotificationModel {
  final String id;
  final String title;
  final String message;
  final String type;
  final String recipientId;
  final String recipientType;
  final String senderId;
  final String senderName;
  final bool isRead;
  final DateTime createdAt;
  final DateTime? readAt;
  final String schoolId;
  final Map<String, dynamic>? metadata;

  NotificationModel({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.recipientId,
    required this.recipientType,
    required this.senderId,
    required this.senderName,
    this.isRead = false,
    required this.createdAt,
    this.readAt,
    required this.schoolId,
    this.metadata,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? '',
      message: json['message'] ?? '',
      type: json['type'] ?? 'General',
      recipientId: json['recipientId']?.toString() ?? '',
      recipientType: json['recipientType'] ?? 'All',
      senderId: json['senderId']?.toString() ?? '',
      senderName: json['senderName'] ?? '',
      isRead: json['isRead'] ?? false,
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      readAt: json['readAt'] != null ? DateTime.tryParse(json['readAt']!) : null,
      schoolId: json['schoolId'] ?? '',
      metadata: json['metadata'] != null ? Map<String, dynamic>.from(json['metadata']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'message': message,
      'type': type,
      'recipientId': recipientId,
      'recipientType': recipientType,
      'senderId': senderId,
      'senderName': senderName,
      'isRead': isRead,
      'createdAt': createdAt.toIso8601String(),
      'readAt': readAt?.toIso8601String(),
      'schoolId': schoolId,
      'metadata': metadata,
    };
  }

  NotificationModel copyWith({
    String? id,
    String? title,
    String? message,
    String? type,
    String? recipientId,
    String? recipientType,
    String? senderId,
    String? senderName,
    bool? isRead,
    DateTime? createdAt,
    DateTime? readAt,
    String? schoolId,
    Map<String, dynamic>? metadata,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      type: type ?? this.type,
      recipientId: recipientId ?? this.recipientId,
      recipientType: recipientType ?? this.recipientType,
      senderId: senderId ?? this.senderId,
      senderName: senderName ?? this.senderName,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt ?? this.createdAt,
      readAt: readAt ?? this.readAt,
      schoolId: schoolId ?? this.schoolId,
      metadata: metadata ?? this.metadata,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is NotificationModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'NotificationModel(id: $id, title: $title, type: $type, schoolId: $schoolId)';
  }
}


