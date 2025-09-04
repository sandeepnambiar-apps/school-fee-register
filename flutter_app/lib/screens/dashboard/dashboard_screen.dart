import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../providers/auth_provider.dart';

import '../../widgets/common/kids_card_image.dart';
import '../../widgets/common/fees_card_image.dart';
import '../../widgets/common/homework_card_image.dart';
import '../../widgets/common/announcements_card_image.dart';
import '../../widgets/common/calendar_card_image.dart';
import '../../widgets/common/marks_card_image.dart';
import '../../widgets/common/static_reports_icon.dart';
import '../../widgets/common/static_user_management_icon.dart';
import '../../widgets/common/timetable_card_image.dart';
import '../../widgets/common/talk_to_us_card_image.dart';
import '../../widgets/common/track_bus_card_image.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {

  @override
  void initState() {
    super.initState();
    // Check authentication
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = context.read<AuthProvider>();
      if (!authProvider.isAuthenticated) {
        context.go('/login');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Check if we're on mobile (narrow screen)
    final isMobile = MediaQuery.of(context).size.width < 768;
    
    if (isMobile) {
      return _buildMobileLayout();
    } else {
      return _buildDesktopLayout();
    }
  }

  // Mobile Layout with Bottom Navigation
  Widget _buildMobileLayout() {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _logout(context),
            tooltip: 'Logout',
          ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              _showMobileMenu(context);
            },
          ),
        ],
      ),
      body: _buildMainContent(),
    );
  }

  // Logout method
  void _logout(BuildContext context) async {
    final authProvider = context.read<AuthProvider>();
    await authProvider.logout();
    if (context.mounted) {
      context.go('/login');
    }
  }

  // Show mobile menu drawer for additional items
  void _showMobileMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'More Options',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            _buildMobileMenuItem(
              Icons.description,
              'Payments',
              () {
                Navigator.pop(context);
                context.go('/fees');
              },
            ),
            _buildMobileMenuItem(
              Icons.schedule,
              'Timetable',
              () {
                Navigator.pop(context);
                context.go('/timetable');
              },
            ),
            _buildMobileMenuItem(
              Icons.notifications,
              'Notifications',
              () {
                Navigator.pop(context);
                context.go('/notifications');
              },
            ),
            _buildMobileMenuItem(
              Icons.bar_chart,
              'Marks & Reports',
              () {
                Navigator.pop(context);
                context.go('/marks');
              },
            ),
            _buildMobileMenuItem(
              Icons.help,
              'Help Desk',
              () {
                Navigator.pop(context);
                context.go('/helpdesk');
              },
            ),
            const SizedBox(height: 20),
            Consumer<AuthProvider>(
              builder: (context, authProvider, child) {
                return SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      Navigator.pop(context);
                      await authProvider.logout();
                      if (context.mounted) {
                        context.go('/login');
                      }
                    },
                    icon: const Icon(Icons.logout, color: Colors.white),
                    label: const Text(
                      'Logout',
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMobileMenuItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue),
      title: Text(title),
      onTap: onTap,
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
    );
  }

  // Desktop/Tablet Layout with Sidebar
  Widget _buildDesktopLayout() {
    return Scaffold(
      body: Row(
        children: [
          // Sidebar Navigation
          Container(
            width: 280,
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(
                right: BorderSide(color: Color(0xFFE5E7EB), width: 1),
              ),
            ),
            child: Column(
              children: [
                // Branding Section
                Container(
                  padding: const EdgeInsets.all(24),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: const BoxDecoration(
                          color: Colors.blue,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.person,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Text(
                                'Kid',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: const BoxDecoration(
                                  color: Colors.orange,
                                  shape: BoxShape.circle,
                                ),
                                child: const Text(
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
                          const Text(
                            'School Management System',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),
                
                // Navigation Menu
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    children: [
                      _buildNavItem(Icons.dashboard, 'Dashboard', 0, isSelected: true),
                      _buildNavItem(Icons.people, 'Students', 1),
                      _buildNavItem(Icons.receipt, 'Fees', 2),
                      _buildNavItem(Icons.description, 'Payments', 3),
                      _buildNavItem(Icons.assignment, 'Homework', 4),
                      _buildNavItem(Icons.calendar_today, 'Calendar', 5),
                      _buildNavItem(Icons.schedule, 'Timetable', 6),
                      _buildNavItem(Icons.notifications, 'Notifications', 7),
                      _buildNavItem(Icons.bar_chart, 'Marks & Reports', 8),
                      _buildNavItem(Icons.help, 'Help Desk', 9),
                    ],
                  ),
                ),
                
                // Logout Section
                Container(
                  padding: const EdgeInsets.all(16),
                  child: Consumer<AuthProvider>(
                    builder: (context, authProvider, child) {
                      return ListTile(
                        leading: const Icon(Icons.logout, color: Colors.red),
                        title: const Text(
                          'Logout',
                          style: TextStyle(color: Colors.red),
                        ),
                        onTap: () async {
                          await authProvider.logout();
                          if (context.mounted) {
                            context.go('/login');
                          }
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          
          // Main Content Area
          Expanded(
            child: _buildMainContent(),
          ),
        ],
      ),
    );
  }

  // Main Content (shared between mobile and desktop)
  Widget _buildMainContent() {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        final userRole = authProvider.user?['role'] ?? 'Super Admin';
        
        switch (userRole) {
          case 'PARENT':
            return _buildParentDashboard();
          case 'TEACHER':
            return _buildTeacherDashboard();
          case 'SCHOOL_ADMIN':
          case 'SUPER_ADMIN':
          default:
            return _buildAdminDashboard(userRole);
        }
      },
    );
  }

  Widget _buildNavigationCard(String title, IconData icon, Color color, VoidCallback onTap) {
    return _buildNavigationCardWithWidget(
      title: title,
      icon: Icon(icon, color: color, size: 36),
      color: color,
      onTap: onTap,
    );
  }

  Widget _buildNavigationCardWithWidget({
    required String title,
    required Widget icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
              spreadRadius: 0,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              child: icon,
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildParentDashboard() {
    return GridView.count(
      padding: const EdgeInsets.all(16),
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 0.9,
      children: [
        _buildNavigationCard(
          'Profile',
          Icons.person,
          Colors.orange[600]!,
          () => context.go('/students'),
        ),
        _buildNavigationCardWithWidget(
          title: 'Time Table',
          icon: const TimetableCardImage(),
          color: Colors.purple[600]!,
          onTap: () => context.go('/timetable'),
        ),
        _buildNavigationCard(
          'My Fee Payments',
          Icons.payment,
          Colors.amber[600]!,
          () => context.go('/fees'),
        ),
        _buildNavigationCard(
          'My Diary',
          Icons.book,
          Colors.teal[600]!,
          () => context.go('/homework'),
        ),
        _buildNavigationCard(
          'Announcements',
          Icons.notifications,
          Colors.red[600]!,
          () => context.go('/notifications'),
        ),
        _buildNavigationCardWithWidget(
          title: 'Calendar',
          icon: const CalendarCardImage(),
          color: Colors.purple[600]!,
          onTap: () => context.go('/calendar'),
        ),
        _buildNavigationCardWithWidget(
          title: 'Talk to Us',
          icon: const TalkToUsCardImage(),
          color: Colors.purple[600]!,
          onTap: () => context.go('/helpdesk'),
        ),
        _buildNavigationCardWithWidget(
          title: 'Track Your Bus',
          icon: const TrackBusCardImage(),
          color: Colors.blue[600]!,
          onTap: () => context.go('/track-bus'),
        ),
      ],
    );
  }

  Widget _buildTeacherDashboard() {
    return GridView.count(
      padding: const EdgeInsets.all(16),
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 0.9,
      children: [
        _buildNavigationCard(
          'My Classes',
          Icons.class_,
          Colors.orange[600]!,
          () => context.go('/my-classes'), // Changed from /students to /my-classes
        ),
        _buildNavigationCard(
          'Add Homework',
          Icons.assignment,
          Colors.orange[600]!,
          () => context.go('/homework'),
        ),
        _buildNavigationCardWithWidget(
          title: 'Timetable',
          icon: const TimetableCardImage(),
          color: Colors.indigo[600]!,
          onTap: () => context.go('/timetable'),
        ),
        _buildNavigationCardWithWidget(
          title: 'Calendar',
          icon: const CalendarCardImage(),
          color: Colors.purple[600]!,
          onTap: () => context.go('/calendar'),
        ),
        _buildNavigationCard(
          'Add Marks',
          Icons.grade,
          Colors.teal[600]!,
          () => context.go('/marks'),
        ),
        _buildNavigationCard(
          'Announcements',
          Icons.notifications,
          Colors.red[600]!,
          () => context.go('/notifications'),
        ),
        _buildNavigationCardWithWidget(
          title: 'Track Your Bus',
          icon: const TrackBusCardImage(),
          color: Colors.blue[600]!,
          onTap: () => context.go('/track-bus'),
        ),
      ],
    );
  }

  Widget _buildAdminDashboard([String? userRole]) {
    final List<Widget> cards = [
      _buildNavigationCardWithWidget(
        title: 'Kids',
        icon: const KidsCardImage(),
        color: Colors.orange[600]!,
        onTap: () => context.go('/students'),
      ),
      _buildNavigationCardWithWidget(
        title: 'Fees',
        icon: const FeesCardImage(),
        color: Colors.green[600]!,
        onTap: () => context.go('/fees'),
      ),
      _buildNavigationCardWithWidget(
        title: 'Homework',
        icon: const HomeworkCardImage(),
        color: Colors.orange[600]!,
        onTap: () => context.go('/homework'),
      ),
      _buildNavigationCardWithWidget(
        title: 'Timetable',
        icon: const TimetableCardImage(),
        color: Colors.indigo[600]!,
        onTap: () => context.go('/timetable'),
      ),
      _buildNavigationCardWithWidget(
        title: 'Calendar',
        icon: const CalendarCardImage(),
        color: Colors.purple[600]!,
        onTap: () => context.go('/calendar'),
      ),
      _buildNavigationCardWithWidget(
        title: 'Announcements',
        icon: const AnnouncementsCardImage(),
        color: Colors.red[600]!,
        onTap: () => context.go('/notifications'),
      ),
      _buildNavigationCardWithWidget(
        title: 'Marks',
        icon: const MarksCardImage(),
        color: Colors.teal[600]!,
        onTap: () => context.go('/marks'),
      ),
      _buildNavigationCardWithWidget(
        title: 'Reports',
        icon: const StaticReportsIcon(),
        color: Colors.amber[600]!,
        onTap: () => context.go('/reports'),
      ),
      _buildNavigationCardWithWidget(
        title: 'Talk to Us',
        icon: const TalkToUsCardImage(),
        color: Colors.purple[600]!,
        onTap: () => context.go('/helpdesk'),
      ),
      _buildNavigationCardWithWidget(
        title: 'Track Your Bus',
        icon: const TrackBusCardImage(),
        color: Colors.blue[600]!,
        onTap: () => context.go('/track-bus'),
      ),
    ];

    // Only show School Config for Super Admin
    if (userRole == 'SUPER_ADMIN') {
      cards.add(
        _buildNavigationCard(
          'School Config',
          Icons.settings,
          Colors.indigo[600]!,
          () => context.go('/school-config'),
        ),
      );
    }

    // Add User Management for Super Admin and School Admin
    if (userRole == 'SUPER_ADMIN' || userRole == 'SCHOOL_ADMIN') {
      cards.add(
        _buildNavigationCardWithWidget(
          title: 'User Management',
          icon: const StaticUserManagementIcon(),
          color: Colors.blue[600]!,
          onTap: () => context.go('/user-management'),
        ),
      );
    }

    return GridView.count(
      padding: const EdgeInsets.all(16),
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 0.9,
      children: cards,
    );
  }

  Widget _buildNavItem(IconData icon, String title, int index, {bool isSelected = false}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: Icon(
          icon,
          color: isSelected ? Colors.blue : Colors.grey[600],
          size: 20,
        ),
        title: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.blue : Colors.black87,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
        selected: isSelected,
        selectedTileColor: Colors.blue.withOpacity(0.1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        onTap: () {
          // Navigation removed - items are now just for display
        },
      ),
    );
  }
}

