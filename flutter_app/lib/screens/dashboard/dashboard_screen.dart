import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/common/app_branding.dart';

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

  // Mobile Layout with Navigation Cards
  Widget _buildMobileLayout() {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        backgroundColor: Colors.orange[600],
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.help),
            onPressed: () => context.go('/helpdesk'),
            tooltip: 'Help Desk',
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _showLogoutDialog(context),
            tooltip: 'Logout',
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child: Column(
          children: [
            // App Branding for Mobile
            const AppBranding(),
            // Welcome Section
            _buildWelcomeSection(),
            // Navigation Cards
            Expanded(
              child: _buildNavigationCards(),
            ),
          ],
        ),
      ),
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
            decoration: BoxDecoration(
              color: Colors.white,
              border: const Border(
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
                        decoration: BoxDecoration(
                          color: Colors.orange[600],
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
                                decoration: BoxDecoration(
                                  color: Colors.orange[600],
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
                  child: Consumer<AuthProvider>(
                    builder: (context, authProvider, child) {
                      final userRole = authProvider.user?['role'] ?? 'Super Admin';
                      
                      List<Widget> menuItems = [
                        _buildNavItem(Icons.dashboard, 'Dashboard', 0, isSelected: true),
                        _buildNavItem(Icons.people, 'Students', 1),
                        _buildNavItem(Icons.receipt, 'Fees', 2),
                        _buildNavItem(Icons.assignment, 'Homework', 3),
                        _buildNavItem(Icons.calendar_today, 'Calendar', 4),
                        _buildNavItem(Icons.schedule, 'Timetable', 5),
                        _buildNavItem(Icons.notifications, 'Notifications', 6),
                        _buildNavItem(Icons.bar_chart, 'Marks', 7),
                        _buildNavItem(Icons.help, 'Help Desk', 8),
                        _buildNavItem(Icons.description, 'Payments', 9),
                      ];
                      
                      // Add role-specific items
                      if (userRole == 'Teacher' || userRole == 'School Admin' || userRole == 'Super Admin') {
                        menuItems.insert(5, _buildNavItem(Icons.schedule, 'Add Timetable', 10));
                      }
                      
                      return ListView(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        children: menuItems,
                      );
                    },
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
    return Container(
      color: const Color(0xFFF9FAFB),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                bottom: BorderSide(color: const Color(0xFFE5E7EB), width: 1),
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.dashboard, size: 24, color: Colors.orange[600]),
                const SizedBox(width: 12),
                const Text(
                  'Dashboard',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Consumer<AuthProvider>(
                  builder: (context, authProvider, child) {
                    return Row(
                      children: [
                        const Icon(Icons.person, color: Colors.grey),
                        const SizedBox(width: 8),
                        Text(
                          authProvider.user?['username'] ?? 'User',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
          
          // Dashboard Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Welcome Section
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.orange[600]!, Colors.orange[400]!],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Welcome back!',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Here\'s what\'s happening in your school today.',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Quick Stats
                  const Text(
                    'Quick Overview',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Responsive stats layout
                  LayoutBuilder(
                    builder: (context, constraints) {
                      if (constraints.maxWidth < 600) {
                        // Mobile: Stack vertically
                        return Column(
                          children: [
                            _buildStatCard(
                              'Total Students',
                              '1,247',
                              Icons.people,
                              Colors.blue,
                            ),
                            const SizedBox(height: 16),
                            _buildStatCard(
                              'Total Fees',
                              '₹2,45,000',
                              Icons.receipt,
                              Colors.green,
                            ),
                            const SizedBox(height: 16),
                            _buildStatCard(
                              'Pending Payments',
                              '₹45,000',
                              Icons.pending,
                              Colors.orange,
                            ),
                            const SizedBox(height: 16),
                            _buildStatCard(
                              'Active Homework',
                              '23',
                              Icons.assignment,
                              Colors.purple,
                            ),
                          ],
                        );
                      } else {
                        // Desktop: Row layout
                        return Row(
                          children: [
                            Expanded(
                              child: _buildStatCard(
                                'Total Students',
                                '1,247',
                                Icons.people,
                                Colors.blue,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _buildStatCard(
                                'Total Fees',
                                '₹2,45,000',
                                Icons.receipt,
                                Colors.green,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _buildStatCard(
                                'Pending Payments',
                                '₹45,000',
                                Icons.pending,
                                Colors.orange,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _buildStatCard(
                                'Active Homework',
                                '23',
                                Icons.assignment,
                                Colors.purple,
                              ),
                            ),
                          ],
                        );
                      }
                    },
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Quick Actions
                  const Text(
                    'Quick Actions',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Role-based Quick Actions
                  Consumer<AuthProvider>(
                    builder: (context, authProvider, child) {
                      final userRole = authProvider.user?['role'] ?? 'Super Admin';
                      
                      if (userRole == 'Parent') {
                        // Parent: View-only actions
                        return LayoutBuilder(
                          builder: (context, constraints) {
                            if (constraints.maxWidth < 600) {
                              // Mobile: Stack vertically
                              return Column(
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: _buildQuickActionCard(
                                          'View Timetable',
                                          Icons.schedule,
                                          Colors.indigo,
                                          () => context.go('/timetable'),
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        child: _buildQuickActionCard(
                                          'View Calendar',
                                          Icons.calendar_today,
                                          Colors.purple,
                                          () => context.go('/calendar'),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: _buildQuickActionCard(
                                          'View Marks',
                                          Icons.bar_chart,
                                          Colors.teal,
                                          () => context.go('/marks'),
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        child: _buildQuickActionCard(
                                          'View Notifications',
                                          Icons.notifications,
                                          Colors.red,
                                          () => context.go('/notifications'),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              );
                            } else {
                              // Desktop: Row layout
                              return Row(
                                children: [
                                  Expanded(
                                    child: _buildQuickActionCard(
                                      'View Timetable',
                                      Icons.schedule,
                                      Colors.indigo,
                                      () => context.go('/timetable'),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: _buildQuickActionCard(
                                      'View Calendar',
                                      Icons.calendar_today,
                                      Colors.purple,
                                      () => context.go('/calendar'),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: _buildQuickActionCard(
                                      'View Marks',
                                      Icons.bar_chart,
                                      Colors.teal,
                                      () => context.go('/marks'),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: _buildQuickActionCard(
                                      'View Notifications',
                                      Icons.notifications,
                                      Colors.red,
                                      () => context.go('/notifications'),
                                    ),
                                  ),
                                ],
                              );
                            }
                          },
                        );
                      } else {
                        // Teacher and Admin: Full actions
                        return LayoutBuilder(
                          builder: (context, constraints) {
                            if (constraints.maxWidth < 600) {
                              // Mobile: 2x2 grid
                              return Column(
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: _buildQuickActionCard(
                                          'Add Student',
                                          Icons.person_add,
                                          Colors.blue,
                                          () => context.go('/students'),
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        child: _buildQuickActionCard(
                                          'Record Payment',
                                          Icons.payment,
                                          Colors.green,
                                          () => context.go('/fees'),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: _buildQuickActionCard(
                                          'Assign Homework',
                                          Icons.assignment_add,
                                          Colors.orange,
                                          () => context.go('/homework'),
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        child: _buildQuickActionCard(
                                          'Add Event',
                                          Icons.add,
                                          Colors.purple,
                                          () => context.go('/calendar'),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              );
                            } else {
                              // Desktop: Row layout
                              return Row(
                                children: [
                                  Expanded(
                                    child: _buildQuickActionCard(
                                      'Add Student',
                                      Icons.person_add,
                                      Colors.blue,
                                      () => context.go('/students'),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: _buildQuickActionCard(
                                      'Record Payment',
                                      Icons.payment,
                                      Colors.green,
                                      () => context.go('/fees'),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: _buildQuickActionCard(
                                      'Assign Homework',
                                      Icons.assignment_add,
                                      Colors.orange,
                                      () => context.go('/homework'),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: _buildQuickActionCard(
                                      'Add Event',
                                      Icons.add,
                                      Colors.purple,
                                      () => context.go('/calendar'),
                                    ),
                                  ),
                                ],
                              );
                            }
                          },
                        );
                      }
                    },
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Recent Activity
                  const Text(
                    'Recent Activity',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Role-based Recent Activity
                  Consumer<AuthProvider>(
                    builder: (context, authProvider, child) {
                      final userRole = authProvider.user?['role'] ?? 'Super Admin';
                      
                      if (userRole == 'Parent') {
                        // Parent: View-only activities
                        return Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0xFFE5E7EB)),
                          ),
                          child: Column(
                            children: [
                              _buildActivityItem(
                                'Timetable updated for Class 5A',
                                '2 hours ago',
                                Icons.schedule,
                                Colors.indigo,
                              ),
                              const Divider(),
                              _buildActivityItem(
                                'New notification: Parent-Teacher meeting',
                                '1 day ago',
                                Icons.notifications,
                                Colors.red,
                              ),
                              const Divider(),
                              _buildActivityItem(
                                'Marks uploaded: Mathematics',
                                '2 days ago',
                                Icons.bar_chart,
                                Colors.teal,
                              ),
                              const Divider(),
                              _buildActivityItem(
                                'Calendar event: Annual Sports Day',
                                '3 days ago',
                                Icons.event,
                                Colors.purple,
                              ),
                            ],
                          ),
                        );
                      } else {
                        // Teacher and Admin: Full activities
                        return Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0xFFE5E7EB)),
                          ),
                          child: Column(
                            children: [
                              _buildActivityItem(
                                'New student registration: John Doe',
                                '2 minutes ago',
                                Icons.person_add,
                                Colors.blue,
                              ),
                              const Divider(),
                              _buildActivityItem(
                                'Fee payment received: ₹5,000',
                                '15 minutes ago',
                                Icons.payment,
                                Colors.green,
                              ),
                              const Divider(),
                              _buildActivityItem(
                                'Homework assigned: Mathematics',
                                '1 hour ago',
                                Icons.assignment,
                                Colors.orange,
                              ),
                              const Divider(),
                              _buildActivityItem(
                                'Event scheduled: Annual Sports Day',
                                '2 hours ago',
                                Icons.event,
                                Colors.purple,
                              ),
                            ],
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String title, int index, {bool isSelected = false}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: Icon(
          icon,
          color: isSelected ? Colors.orange[600] : Colors.grey[600],
          size: 20,
        ),
        title: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.orange[600] : Colors.black87,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
        selected: isSelected,
        selectedTileColor: Colors.orange.withValues(alpha: 0.1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        onTap: () {
          _navigateToScreen(index);
        },
      ),
    );
  }

  // Navigation logic for both mobile and desktop
  void _navigateToScreen(int index) {
    switch (index) {
      case 0: // Dashboard
        // Already on dashboard
        break;
      case 1: // Students
        context.go('/students');
        break;
      case 2: // Fees
        context.go('/fees');
        break;
      case 3: // Homework
        context.go('/homework');
        break;
      case 4: // Calendar
        context.go('/calendar');
        break;
      case 5: // Timetable
        context.go('/timetable');
        break;
      case 6: // Notifications
        context.go('/notifications');
        break;
      case 7: // Marks
        context.go('/marks');
        break;
      case 8: // Help Desk
        context.go('/helpdesk');
        break;
      case 9: // Payments
        context.go('/fees'); // Payments tab in fees screen
        break;
      case 10: // Add Timetable (for Teacher and Admin)
        context.go('/timetable');
        break;
    }
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const Spacer(),
              Icon(Icons.trending_up, color: Colors.green, size: 16),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionCard(String title, IconData icon, Color color, VoidCallback onTap) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: color, size: 24),
                ),
                const SizedBox(height: 12),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActivityItem(String title, String time, IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 16),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  time,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Welcome Section Method (with kid decorations)
  Widget _buildWelcomeSection() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.orange[600],
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.child_care,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome back!',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange[700],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Manage your school operations efficiently',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Navigation Cards Method
  Widget _buildNavigationCards() {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        final userRole = authProvider.user?['role'] ?? 'Super Admin';
        
        switch (userRole) {
          case 'Parent':
            return _buildParentDashboard();
          case 'Teacher':
            return _buildTeacherDashboard();
          case 'School Admin':
          case 'Super Admin':
          default:
            return _buildAdminDashboard();
        }
      },
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(context).pop();
              final authProvider = context.read<AuthProvider>();
              await authProvider.logout();
              if (context.mounted) {
                context.go('/login');
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationCard(String title, IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE5E7EB)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: Colors.grey[600],
                size: 32,
              ),
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
      childAspectRatio: 1.1,
      children: [
        _buildNavigationCard(
          'Kid Profile',
          Icons.person,
          Colors.lightBlue,
          () => context.go('/students'),
        ),
        _buildNavigationCard(
          'Fees Status',
          Icons.receipt,
          Colors.green,
          () => context.go('/fees'),
        ),
        _buildNavigationCard(
          'Notifications',
          Icons.notifications,
          Colors.red,
          () => context.go('/notifications'),
        ),
        _buildNavigationCard(
          'Timetable',
          Icons.schedule,
          Colors.indigo,
          () => context.go('/timetable'),
        ),
        _buildNavigationCard(
          'Calendar',
          Icons.calendar_today,
          Colors.purple,
          () => context.go('/calendar'),
        ),
        _buildNavigationCard(
          'Marks',
          Icons.bar_chart,
          Colors.teal,
          () => context.go('/marks'),
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
      childAspectRatio: 1.1,
      children: [
        _buildNavigationCard(
          'My Classes',
          Icons.class_,
          Colors.lightBlue,
          () => context.go('/students'),
        ),
        _buildNavigationCard(
          'Students',
          Icons.people,
          Colors.green,
          () => context.go('/students'),
        ),
        _buildNavigationCard(
          'Add Homework',
          Icons.assignment,
          Colors.orange,
          () => context.go('/homework'),
        ),
        _buildNavigationCard(
          'Add Timetable',
          Icons.schedule,
          Colors.indigo,
          () => context.go('/timetable'),
        ),
        _buildNavigationCard(
          'Timetable',
          Icons.schedule,
          Colors.indigo,
          () => context.go('/timetable'),
        ),
        _buildNavigationCard(
          'Marks',
          Icons.bar_chart,
          Colors.teal,
          () => context.go('/marks'),
        ),
        _buildNavigationCard(
          'Notifications',
          Icons.notifications,
          Colors.red,
          () => context.go('/notifications'),
        ),
      ],
    );
  }

  Widget _buildAdminDashboard() {
    return GridView.count(
      padding: const EdgeInsets.all(16),
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.1,
      children: [
        _buildNavigationCard(
          'Students',
          Icons.people,
          Colors.lightBlue,
          () => context.go('/students'),
        ),
        _buildNavigationCard(
          'Fees',
          Icons.receipt,
          Colors.green,
          () => context.go('/fees'),
        ),
        _buildNavigationCard(
          'Homework',
          Icons.assignment,
          Colors.orange,
          () => context.go('/homework'),
        ),
        _buildNavigationCard(
          'Add Timetable',
          Icons.schedule,
          Colors.indigo,
          () => context.go('/timetable'),
        ),
        _buildNavigationCard(
          'Calendar',
          Icons.calendar_today,
          Colors.purple,
          () => context.go('/calendar'),
        ),
        _buildNavigationCard(
          'Timetable',
          Icons.schedule,
          Colors.indigo,
          () => context.go('/timetable'),
        ),
        _buildNavigationCard(
          'Notifications',
          Icons.notifications,
          Colors.red,
          () => context.go('/notifications'),
        ),
        _buildNavigationCard(
          'Marks',
          Icons.bar_chart,
          Colors.teal,
          () => context.go('/marks'),
        ),
        _buildNavigationCard(
          'Reports',
          Icons.analytics,
          Colors.amber,
          () => context.go('/reports'),
        ),
      ],
    );
  }
}
