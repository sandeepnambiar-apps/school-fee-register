import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../widgets/common/app_branding.dart';
import '../../providers/auth_provider.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  List<Map<String, dynamic>> _notifications = [];
  String _selectedFilter = 'All';

  final List<String> _filters = ['All', 'Unread', 'Important', 'Academic', 'Fee', 'General'];

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  void _loadNotifications() {
    _notifications = [
      {
        'id': 1,
        'title': 'Fee Payment Reminder',
        'message': 'Your monthly fee payment is due on 31st January. Please ensure timely payment.',
        'type': 'Fee',
        'priority': 'Important',
        'timestamp': DateTime.now().subtract(const Duration(hours: 2)),
        'isRead': false,
        'sender': 'Finance Department',
      },
      {
        'id': 2,
        'title': 'Parent-Teacher Meeting',
        'message': 'Quarterly parent-teacher meeting scheduled for 25th January at 3:00 PM.',
        'type': 'Academic',
        'priority': 'Important',
        'timestamp': DateTime.now().subtract(const Duration(hours: 4)),
        'isRead': false,
        'sender': 'School Administration',
      },
      {
        'id': 3,
        'title': 'Homework Assignment',
        'message': 'New mathematics homework assigned. Due date: 28th January.',
        'type': 'Academic',
        'priority': 'Normal',
        'timestamp': DateTime.now().subtract(const Duration(hours: 6)),
        'isRead': true,
        'sender': 'Mr. Johnson',
      },
      {
        'id': 4,
        'title': 'Sports Day Event',
        'message': 'Annual Sports Day will be held on 15th February. All students must participate.',
        'type': 'General',
        'priority': 'Normal',
        'timestamp': DateTime.now().subtract(const Duration(days: 1)),
        'isRead': true,
        'sender': 'Physical Education Department',
      },
      {
        'id': 5,
        'title': 'Library Book Return',
        'message': 'Please return the borrowed library books by the end of this week.',
        'type': 'Academic',
        'priority': 'Normal',
        'timestamp': DateTime.now().subtract(const Duration(days: 2)),
        'isRead': true,
        'sender': 'Library Staff',
      },
      {
        'id': 6,
        'title': 'Exam Schedule Update',
        'message': 'Mid-term examination schedule has been updated. Check the notice board.',
        'type': 'Academic',
        'priority': 'Important',
        'timestamp': DateTime.now().subtract(const Duration(days: 3)),
        'isRead': false,
        'sender': 'Examination Department',
      },
    ];
  }

  List<Map<String, dynamic>> get _filteredNotifications {
    if (_selectedFilter == 'All') {
      return _notifications;
    } else if (_selectedFilter == 'Unread') {
      return _notifications.where((n) => !n['isRead']).toList();
    } else {
      return _notifications.where((n) => n['type'] == _selectedFilter).toList();
    }
  }

  void _markAsRead(int id) {
    setState(() {
      final index = _notifications.indexWhere((n) => n['id'] == id);
      if (index != -1) {
        _notifications[index]['isRead'] = true;
      }
    });
  }

  void _markAllAsRead() {
    setState(() {
      for (var notification in _notifications) {
        notification['isRead'] = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/dashboard'),
        ),
        actions: [
          Consumer<AuthProvider>(
            builder: (context, auth, _) {
              final role = auth.user?['role'] ?? 'Super Admin';
              return Row(
                children: [
                  if (role != 'Parent')
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () => _showAddNotificationDialog(context),
                      tooltip: 'Add Notification',
                    ),
                  IconButton(
                    icon: const Icon(Icons.done_all),
                    onPressed: _markAllAsRead,
                    tooltip: 'Mark all as read',
                  ),
                ],
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // App Branding for Mobile
          const AppBranding(),
          // Filter Bar
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.grey[50],
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _filters.map((filter) {
                  final isSelected = _selectedFilter == filter;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text(filter),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() {
                          _selectedFilter = filter;
                        });
                      },
                      backgroundColor: Colors.white,
                      selectedColor: Colors.blue[100],
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.blue[700] : Colors.black87,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          
          // Notifications List
          Expanded(
            child: _filteredNotifications.isEmpty
                ? const Center(
                    child: Text(
                      'No notifications found',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _filteredNotifications.length,
                    itemBuilder: (context, index) {
                      final notification = _filteredNotifications[index];
                      return _buildNotificationCard(notification);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationCard(Map<String, dynamic> notification) {
    final isRead = notification['isRead'];
    final priority = notification['priority'];
    final type = notification['type'];
    
    MaterialColor priorityColor;
    IconData priorityIcon;
    
    switch (priority) {
      case 'Important':
        priorityColor = Colors.red;
        priorityIcon = Icons.priority_high;
        break;
      case 'Normal':
        priorityColor = Colors.blue;
        priorityIcon = Icons.info;
        break;
      default:
        priorityColor = Colors.grey;
        priorityIcon = Icons.notifications;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: isRead ? 1 : 3,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: priorityColor[100],
          child: Icon(priorityIcon, color: priorityColor[700], size: 20),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                notification['title'],
                style: TextStyle(
                  fontWeight: isRead ? FontWeight.normal : FontWeight.bold,
                  color: isRead ? Colors.grey[600] : Colors.black87,
                ),
              ),
            ),
            if (!isRead)
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(notification['message']),
            const SizedBox(height: 8),
            Row(
              children: [
                Chip(
                  label: Text(type),
                  backgroundColor: Colors.grey[100],
                  labelStyle: const TextStyle(fontSize: 12),
                ),
                const SizedBox(width: 8),
                Text(
                  _formatTimestamp(notification['timestamp']),
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              'From: ${notification['sender']}',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
        trailing: Consumer<AuthProvider>(
          builder: (context, auth, _) {
            final role = auth.user?['role'] ?? 'Super Admin';
            if (role == 'Parent') {
              return const SizedBox.shrink();
            }
            return PopupMenuButton(
              itemBuilder: (context) => [
                if (!isRead)
                  const PopupMenuItem(
                    value: 'mark_read',
                    child: Row(
                      children: [
                        Icon(Icons.done, color: Colors.green),
                        SizedBox(width: 8),
                        Text('Mark as read'),
                      ],
                    ),
                  ),
                const PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete, color: Colors.red),
                      SizedBox(width: 8),
                      Text('Delete'),
                    ],
                  ),
                ),
              ],
              onSelected: (value) {
                switch (value) {
                  case 'mark_read':
                    _markAsRead(notification['id']);
                    break;
                  case 'delete':
                    setState(() {
                      _notifications.removeWhere((n) => n['id'] == notification['id']);
                    });
                    break;
                }
              },
            );
          },
        ),
        onTap: () {
          if (!isRead) {
            _markAsRead(notification['id']);
          }
        },
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);
    
    if (difference.inMinutes < 60) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hours ago';
    } else {
      return '${difference.inDays} days ago';
    }
  }

  void _showAddNotificationDialog(BuildContext context) {
    final titleController = TextEditingController();
    final messageController = TextEditingController();
    String selectedType = 'General';
    String selectedPriority = 'Normal';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Notification'),
        contentPadding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
        actionsPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: messageController,
                decoration: const InputDecoration(
                  labelText: 'Message',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: selectedType,
                decoration: const InputDecoration(
                  labelText: 'Type',
                  border: OutlineInputBorder(),
                ),
                items: ['General', 'Academic', 'Fee', 'Important'].map((type) {
                  return DropdownMenuItem(value: type, child: Text(type));
                }).toList(),
                onChanged: (value) {
                  selectedType = value ?? 'General';
                },
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: selectedPriority,
                decoration: const InputDecoration(
                  labelText: 'Priority',
                  border: OutlineInputBorder(),
                ),
                items: ['Low', 'Normal', 'Important'].map((priority) {
                  return DropdownMenuItem(value: priority, child: Text(priority));
                }).toList(),
                onChanged: (value) {
                  selectedPriority = value ?? 'Normal';
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (titleController.text.isNotEmpty && messageController.text.isNotEmpty) {
                final newNotification = {
                  'id': _notifications.length + 1,
                  'title': titleController.text,
                  'message': messageController.text,
                  'type': selectedType,
                  'priority': selectedPriority,
                  'timestamp': DateTime.now(),
                  'isRead': false,
                  'sender': 'You',
                };
                
                setState(() {
                  _notifications.insert(0, newNotification);
                });
                
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Notification added successfully!'),
                    backgroundColor: Colors.green,
                  ),
                );
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}

