import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import '../models/notification.dart';
import 'multi_school_provider.dart';
import '../services/api_service.dart';
import '../services/notification_api_service.dart';
class NotificationProvider extends ChangeNotifier {
  List<NotificationModel> _notifications = [];
  bool _isLoading = false;
  String? _error;
  
  static const String _storageKey = 'notifications_data';
  
  late final ApiService _apiService;
  late final NotificationApiService _notificationApiService;

  // Get current school ID - simplified approach
  String get _getCurrentSchoolId {
    return '1'; // Default school ID
  }

  // Getters
  List<NotificationModel> get notifications => _notifications;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Initialize with persistent storage
  NotificationProvider() {
    _initializeServices();
    _loadData();
  }

  void _initializeServices() {
    _apiService = ApiService();
    _apiService.initialize();
    _notificationApiService = NotificationApiService(_apiService.dio);
  }

  // Load data from API or persistent storage
  Future<void> _loadData() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      // Try to load from API first (when school context is available)
      try {
        // TODO: Get school ID from context when available
        final schoolId = 1; // Default school ID
        final notifications = await _notificationApiService.getAllNotifications(schoolId);
        _notifications = notifications;
        await _saveData(); // Save to local storage for offline access
      } catch (e) {
        // If API fails, load from local storage
        final prefs = await SharedPreferences.getInstance();
        final notificationsJson = prefs.getString(_storageKey);
        
        if (notificationsJson != null) {
          final List<dynamic> decoded = json.decode(notificationsJson);
          _notifications = decoded.map((json) => NotificationModel.fromJson(json)).toList();
          
          // Validate and fix any corrupted data
          _notifications = _notifications.where((notification) {
            // Ensure all required fields exist
            return notification.id.isNotEmpty && 
                   notification.title.isNotEmpty && 
                   notification.message.isNotEmpty;
          }).toList();
          
          // If we lost data due to validation, reload mock data
          if (_notifications.isEmpty) {
            _loadMockData();
            await _saveData();
          }
        } else {
          _loadMockData();
          await _saveData();
        }
      }
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      // If there's any error loading data, fall back to mock data
      _loadMockData();
      await _saveData();
      _isLoading = false;
      notifyListeners();
    }
  }

  // Save data to persistent storage
  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    final notificationsJson = json.encode(_notifications.map((n) => n.toJson()).toList());
    await prefs.setString(_storageKey, notificationsJson);
  }

  // Refresh notifications from API
  Future<void> refreshNotifications() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      // TODO: Get school ID from context when available
      final currentSchoolId = _getCurrentSchoolId;
      final notifications = await _notificationApiService.getAllNotifications(int.parse(currentSchoolId));
      _notifications = notifications;
      
      await _saveData(); // Save to local storage for offline access
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to refresh notifications: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  void _loadMockData() {
    _notifications = [
      NotificationModel(
        id: '1',
        title: 'School Holiday Notice',
        message: 'School will be closed on Republic Day, January 26th, 2024.',
        type: 'Announcement',
        recipientId: 'all',
        recipientType: 'All',
        senderId: 'principal',
        senderName: 'Principal',
        isRead: false,
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
        schoolId: '1',
      ),
      NotificationModel(
        id: '2',
        title: 'Parent-Teacher Meeting',
        message: 'Parent-Teacher meeting scheduled for February 5th, 2024 at 3:00 PM.',
        type: 'Meeting',
        recipientId: 'parents',
        recipientType: 'Parents',
        senderId: 'admin',
        senderName: 'Administration',
        isRead: false,
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        schoolId: '1',
      ),
             NotificationModel(
         id: '3',
         title: 'Sports Day Event',
         message: 'Annual Sports Day will be held on February 15th, 2024.',
         type: 'Event',
         recipientId: 'all',
         recipientType: 'All',
         senderId: 'admin',
         senderName: 'Administration',
                 isRead: false,
        createdAt: DateTime.now().subtract(const Duration(hours: 12)),
        schoolId: '1',
       ),
       NotificationModel(
         id: '4',
         title: 'Exam Schedule Update',
         message: 'Mid-term examinations will begin from February 20th, 2024.',
         type: 'Academic',
         recipientId: 'kids',
         recipientType: 'Kids',
         senderId: 'academic',
         senderName: 'Academic Department',
                 isRead: false,
        createdAt: DateTime.now().subtract(const Duration(hours: 6)),
        schoolId: '1',
       ),
    ];
  }

  // Load notifications from API
  Future<void> loadNotifications() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // TODO: Replace with actual API call
      await Future.delayed(const Duration(milliseconds: 500));
      // Data is already loaded from persistent storage
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Add new notification
  Future<void> addNotification(Map<String, dynamic> notificationData, BuildContext context) async {
    _isLoading = true;
    notifyListeners();

    try {
      // TODO: Replace with actual API call
      await Future.delayed(const Duration(milliseconds: 500));
      
      // Get current school context
      final multiSchoolProvider = context.read<MultiSchoolProvider>();
      final currentSchoolId = multiSchoolProvider.currentSchoolId;
      
      if (currentSchoolId == null) {
        throw Exception('No school context available');
      }
      
      final newNotification = NotificationModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: notificationData['title'] ?? '',
        message: notificationData['message'] ?? '',
        type: notificationData['type'] ?? 'General',
        recipientId: notificationData['recipientId'] ?? 'all',
        recipientType: notificationData['recipientType'] ?? 'All',
        senderId: notificationData['senderId'] ?? 'system',
        senderName: notificationData['senderName'] ?? 'System',
        isRead: false,
        createdAt: DateTime.now(),
        schoolId: currentSchoolId,
      );
      
      _notifications.add(newNotification);
      await _saveData(); // Save to persistent storage
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Update notification
  Future<void> updateNotification(Map<String, dynamic> notificationData) async {
    _isLoading = true;
    notifyListeners();

    try {
      // TODO: Replace with actual API call
      await Future.delayed(const Duration(milliseconds: 500));
      
      final id = notificationData['id'];
      final index = _notifications.indexWhere((notification) => notification.id == id);
      if (index != -1) {
        final existingNotification = _notifications[index];
        final updatedNotification = existingNotification.copyWith(
          title: notificationData['title'] ?? existingNotification.title,
          message: notificationData['message'] ?? existingNotification.message,
          type: notificationData['type'] ?? existingNotification.type,
          recipientId: notificationData['recipientId'] ?? existingNotification.recipientId,
          recipientType: notificationData['recipientType'] ?? existingNotification.recipientType,
          senderId: notificationData['senderId'] ?? existingNotification.senderId,
          senderName: notificationData['senderName'] ?? existingNotification.senderName,
        );
        
        _notifications[index] = updatedNotification;
        await _saveData(); // Save to persistent storage
        notifyListeners();
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Delete notification
  Future<void> deleteNotification(String id) async {
    _isLoading = true;
    notifyListeners();

    try {
      // TODO: Replace with actual API call
      await Future.delayed(const Duration(milliseconds: 500));
      
      _notifications.removeWhere((notification) => notification.id == id);
      await _saveData(); // Save to persistent storage
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Mark notification as read
  Future<void> markAsRead(String id) async {
    final index = _notifications.indexWhere((notification) => notification.id == id);
    if (index != -1) {
      final existingNotification = _notifications[index];
      final updatedNotification = existingNotification.copyWith(
        isRead: true,
        readAt: DateTime.now(),
      );
      _notifications[index] = updatedNotification;
      await _saveData(); // Save to persistent storage
      notifyListeners();
    }
  }

  // Mark all notifications as read
  Future<void> markAllAsRead() async {
    for (int i = 0; i < _notifications.length; i++) {
      final existingNotification = _notifications[i];
      final updatedNotification = existingNotification.copyWith(
        isRead: true,
        readAt: DateTime.now(),
      );
      _notifications[i] = updatedNotification;
    }
    await _saveData(); // Save to persistent storage
    notifyListeners();
  }

  // Get unread notifications count
  int get unreadCount {
    return _notifications.where((notification) => notification.isRead == false).length;
  }

  // Get notifications by type
  List<NotificationModel> getNotificationsByType(String type) {
    return _notifications.where((notification) => notification.type == type).toList();
  }

  // Get notifications by recipient type
  List<NotificationModel> getNotificationsByRecipientType(String recipientType) {
    return _notifications.where((notification) => 
      notification.recipientType == recipientType || 
      notification.recipientType == 'All'
    ).toList();
  }

  // Get recent notifications (last 7 days)
  List<NotificationModel> get recentNotifications {
    final sevenDaysAgo = DateTime.now().subtract(const Duration(days: 7));
    return _notifications.where((notification) {
      return notification.createdAt.isAfter(sevenDaysAgo);
    }).toList();
  }

  // Clear all data (for testing)
  Future<void> clearAllData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_storageKey);
    _notifications.clear();
    notifyListeners();
  }

  // Reset to mock data
  Future<void> resetToMockData() async {
    _loadMockData();
    await _saveData();
    notifyListeners();
  }

  // Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }

  // Filter by school context
  void filterBySchoolContext(String? schoolId) {
    if (schoolId == null) {
      // Show all data if no school context
      notifyListeners();
      return;
    }
    
    // Filter notifications by school
    final filteredNotifications = _notifications.where((n) => n.schoolId == schoolId).toList();
    
    // Update the filtered lists (you might want to add separate filtered lists)
    notifyListeners();
  }

  // Get notifications for current school
  List<NotificationModel> getNotificationsForCurrentSchool(String? schoolId) {
    if (schoolId == null) return [];
    return _notifications.where((n) => n.schoolId == schoolId).toList();
  }
}
