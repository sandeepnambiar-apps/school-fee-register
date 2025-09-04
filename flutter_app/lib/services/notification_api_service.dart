import 'package:dio/dio.dart';
import '../models/notification.dart';

class NotificationApiService {
  final Dio _dio;

  NotificationApiService(this._dio);

  // Get all notifications for a specific school
  Future<List<NotificationModel>> getAllNotifications(int schoolId) async {
    try {
      final response = await _dio.get('/api/notifications', queryParameters: {'schoolId': schoolId});
      if (response.statusCode == 200) {
        final List<dynamic> notificationsData = response.data;
        return notificationsData.map((json) => NotificationModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load notifications: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load notifications: $e');
    }
  }

  // Get notification by ID within school context
  Future<NotificationModel> getNotificationById(int id, int schoolId) async {
    try {
      final response = await _dio.get('/api/notifications/$id', queryParameters: {'schoolId': schoolId});
      if (response.statusCode == 200) {
        return NotificationModel.fromJson(response.data);
      } else {
        throw Exception('Failed to load notification: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load notification: $e');
    }
  }

  // Create new notification
  Future<NotificationModel> createNotification(Map<String, dynamic> notificationData) async {
    try {
      final response = await _dio.post('/api/notifications', data: notificationData);
      if (response.statusCode == 200) {
        return NotificationModel.fromJson(response.data);
      } else {
        throw Exception('Failed to create notification: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to create notification: $e');
    }
  }

  // Update notification
  Future<NotificationModel> updateNotification(int id, Map<String, dynamic> notificationData) async {
    try {
      final response = await _dio.put('/api/notifications/$id', data: notificationData);
      if (response.statusCode == 200) {
        return NotificationModel.fromJson(response.data);
      } else {
        throw Exception('Failed to update notification: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to update notification: $e');
    }
  }

  // Delete notification
  Future<void> deleteNotification(int id) async {
    try {
      final response = await _dio.delete('/api/notifications/$id');
      if (response.statusCode != 204) {
        throw Exception('Failed to delete notification: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to delete notification: $e');
    }
  }

  // Get notifications by recipient
  Future<List<NotificationModel>> getNotificationsByRecipient(String recipientId, int schoolId) async {
    try {
      final response = await _dio.get('/api/notifications/recipient/$recipientId', queryParameters: {'schoolId': schoolId});
      if (response.statusCode == 200) {
        final List<dynamic> notificationsData = response.data;
        return notificationsData.map((json) => NotificationModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load notifications by recipient: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load notifications by recipient: $e');
    }
  }

  // Get notifications by type
  Future<List<NotificationModel>> getNotificationsByType(String type, int schoolId) async {
    try {
      final response = await _dio.get('/api/notifications/type/$type', queryParameters: {'schoolId': schoolId});
      if (response.statusCode == 200) {
        final List<dynamic> notificationsData = response.data;
        return notificationsData.map((json) => NotificationModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load notifications by type: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load notifications by type: $e');
    }
  }

  // Mark notification as read
  Future<NotificationModel> markAsRead(int id, int schoolId) async {
    try {
      final response = await _dio.patch('/api/notifications/$id/read', queryParameters: {'schoolId': schoolId});
      if (response.statusCode == 200) {
        return NotificationModel.fromJson(response.data);
      } else {
        throw Exception('Failed to mark notification as read: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to mark notification as read: $e');
    }
  }

  // Get unread notifications count
  Future<int> getUnreadCount(int schoolId) async {
    try {
      final response = await _dio.get('/api/notifications/unread/count', queryParameters: {'schoolId': schoolId});
      if (response.statusCode == 200) {
        return response.data as int;
      } else {
        throw Exception('Failed to get unread count: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to get unread count: $e');
    }
  }

  // Get notifications by sender
  Future<List<NotificationModel>> getNotificationsBySender(String senderId, int schoolId) async {
    try {
      final response = await _dio.get('/api/notifications/sender/$senderId', queryParameters: {'schoolId': schoolId});
      if (response.statusCode == 200) {
        final List<dynamic> notificationsData = response.data;
        return notificationsData.map((json) => NotificationModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load notifications by sender: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load notifications by sender: $e');
    }
  }

  // Search notifications
  Future<List<NotificationModel>> searchNotifications(String query, int schoolId) async {
    try {
      final response = await _dio.get('/api/notifications/search', queryParameters: {'query': query, 'schoolId': schoolId});
      if (response.statusCode == 200) {
        final List<dynamic> notificationsData = response.data;
        return notificationsData.map((json) => NotificationModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to search notifications: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to search notifications: $e');
    }
  }
}


