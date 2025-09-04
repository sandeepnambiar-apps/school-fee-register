import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/notification_provider.dart';
import '../../models/notification.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  String _selectedFilter = 'All';
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _messageController = TextEditingController();
  final _typeController = TextEditingController();
  final _priorityController = TextEditingController();
  final _targetAudienceController = TextEditingController();

  final List<String> _filters = ['All', 'Unread', 'Important', 'Academic', 'Fee', 'General'];
  final List<String> _types = ['Announcement', 'Meeting', 'Event', 'Academic', 'Fee', 'General'];
  final List<String> _priorities = ['Low', 'Normal', 'Medium', 'High', 'Urgent'];
  final List<String> _audiences = ['All', 'Kids', 'Parents', 'Teachers', 'Administration'];

  @override
  void initState() {
    super.initState();
    // Set default values
    _typeController.text = _types[0];
    _priorityController.text = _priorities[1];
    _targetAudienceController.text = _audiences[0];
    
    // Load notifications from provider
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NotificationProvider>().loadNotifications();
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _messageController.dispose();
    _typeController.dispose();
    _priorityController.dispose();
    _targetAudienceController.dispose();
    super.dispose();
  }

  List<NotificationModel> _getFilteredNotifications(List<NotificationModel> notifications) {
    if (_selectedFilter == 'All') {
      return notifications;
    } else if (_selectedFilter == 'Unread') {
      return notifications.where((n) => !n.isRead).toList();
    } else {
      return notifications.where((n) => n.type == _selectedFilter).toList();
    }
  }

  void _markAsRead(String id) {
    context.read<NotificationProvider>().markAsRead(id);
  }

  void _markAllAsRead() {
    context.read<NotificationProvider>().markAllAsRead();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      floatingActionButton: _buildFloatingActionButton(),
      appBar: AppBar(
        title: const Text('Announcements'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/dashboard'),
        ),
        actions: [
          // Kidsy Branding in App Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Text(
                      'Kid',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 4,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.orange[600],
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        'sy',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Consumer<AuthProvider>(
            builder: (context, auth, _) {
              final role = auth.user?['role'] ?? 'Super Admin';
              return Row(
                children: [
                  if (role != 'Parent' && role != 'Teacher')
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () => _showAddNotificationDialog(context),
                      tooltip: 'Add Announcement',
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
            child: Consumer<NotificationProvider>(
              builder: (context, notificationProvider, child) {
                final filteredNotifications = _getFilteredNotifications(notificationProvider.notifications);
                
                if (filteredNotifications.isEmpty) {
                  return const Center(
                    child: Text(
                      'No notifications found',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  );
                }
                
                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: filteredNotifications.length,
                  itemBuilder: (context, index) {
                    final notification = filteredNotifications[index];
                    return _buildNotificationCard(notification);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationCard(NotificationModel notification) {
    final isRead = notification.isRead;
    final type = notification.type;
    
    MaterialColor priorityColor;
    IconData priorityIcon;
    
    // Since NotificationModel doesn't have priority, we'll use type for color coding
    switch (type) {
      case 'Important':
      case 'Urgent':
        priorityColor = Colors.red;
        priorityIcon = Icons.priority_high;
        break;
      case 'Normal':
      case 'General':
        priorityColor = Colors.blue;
        priorityIcon = Icons.info;
        break;
      default:
        priorityColor = Colors.grey;
        priorityIcon = Icons.notifications;
    }

    return Card(
      color: Colors.white,
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
                notification.title,
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
            Text(notification.message),
            const SizedBox(height: 8),
            Row(
              children: [
                Chip(
                  label: Text(type),
                  backgroundColor: Colors.white,
                  labelStyle: const TextStyle(fontSize: 12),
                ),
                const SizedBox(width: 8),
                Text(
                  _formatTimestamp(notification.createdAt),
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              'From: ${notification.senderName}',
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
                    _markAsRead(notification.id);
                    break;
                  case 'delete':
                    context.read<NotificationProvider>().deleteNotification(notification.id);
                    break;
                }
              },
            );
          },
        ),
        onTap: () {
          if (!isRead) {
            _markAsRead(notification.id);
          }
        },
      ),
    );
  }

  String _formatTimestamp(dynamic timestamp) {
    if (timestamp == null) {
      return 'Unknown time';
    }
    
    DateTime dateTime;
    if (timestamp is DateTime) {
      dateTime = timestamp;
    } else if (timestamp is String) {
      try {
        dateTime = DateTime.parse(timestamp);
      } catch (e) {
        return 'Invalid time';
      }
    } else {
      return 'Unknown time';
    }
    
    final now = DateTime.now();
    final difference = now.difference(dateTime);
    
    if (difference.inMinutes < 60) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hours ago';
    } else {
      return '${difference.inDays} days ago';
    }
  }

  void _showAddNotificationDialog(BuildContext context) {
    _titleController.clear();
    _messageController.clear();
    _typeController.text = _types[0];
    _priorityController.text = _priorities[1];
    _targetAudienceController.text = _audiences[0];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Announcement'),
        contentPadding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
        actionsPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _titleController,
                      decoration: const InputDecoration(
                        labelText: 'Title',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Title cannot be empty';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _messageController,
                      decoration: const InputDecoration(
                        labelText: 'Message',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Message cannot be empty';
                        }
                        return null;
                      },
                      maxLines: 3,
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: _typeController.text,
                      decoration: const InputDecoration(
                        labelText: 'Type',
                        border: OutlineInputBorder(),
                      ),
                      items: _types.map((type) {
                        return DropdownMenuItem(value: type, child: Text(type));
                      }).toList(),
                      onChanged: (value) {
                        _typeController.text = value ?? _types[0];
                      },
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: _priorityController.text,
                      decoration: const InputDecoration(
                        labelText: 'Priority',
                        border: OutlineInputBorder(),
                      ),
                      items: _priorities.map((priority) {
                        return DropdownMenuItem(value: priority, child: Text(priority));
                      }).toList(),
                      onChanged: (value) {
                        _priorityController.text = value ?? _priorities[1];
                      },
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: _targetAudienceController.text,
                      decoration: const InputDecoration(
                        labelText: 'Target Audience',
                        border: OutlineInputBorder(),
                      ),
                      items: _audiences.map((audience) {
                        return DropdownMenuItem(value: audience, child: Text(audience));
                      }).toList(),
                      onChanged: (value) {
                        _targetAudienceController.text = value ?? _audiences[0];
                      },
                    ),
                  ],
                ),
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
              if (_formKey.currentState?.validate() ?? false) {
                final newNotification = {
                  'id': context.read<NotificationProvider>().notifications.length + 1,
                  'title': _titleController.text,
                  'message': _messageController.text,
                  'type': _typeController.text,
                  'priority': _priorityController.text,
                  'timestamp': DateTime.now(),
                  'isRead': false,
                  'sender': 'You',
                };
                
                context.read<NotificationProvider>().addNotification(newNotification, context);
                
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Announcement added successfully!'),
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

  Widget? _buildFloatingActionButton() {
    final userRole = this.userRole;
    if (userRole == 'SUPER_ADMIN' || userRole == 'SCHOOL_ADMIN') {
      return FloatingActionButton(
        onPressed: () => _showAddNotificationDialog(context),
        backgroundColor: Colors.orange[600],
        child: const Icon(Icons.add, color: Colors.white),
      );
    }
    return null;
  }

  String get userRole {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    return authProvider.user?['role'] ?? 'USER';
  }
}

