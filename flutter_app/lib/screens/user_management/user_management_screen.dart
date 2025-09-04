import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../providers/user_management_provider.dart';
import '../../providers/multi_school_provider.dart';
import '../../models/user.dart';
import '../../models/permissions.dart';
import '../../widgets/common/custom_text_field.dart';
import 'create_user_form.dart';
import 'edit_user_dialog.dart';

class UserManagementScreen extends StatefulWidget {
  const UserManagementScreen({super.key});

  @override
  State<UserManagementScreen> createState() => _UserManagementScreenState();
}

class _UserManagementScreenState extends State<UserManagementScreen> {
  final _searchController = TextEditingController();
  String _selectedRole = '';
  String _selectedStatus = '';
  String _selectedSchool = '';
  bool _showCreateForm = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userProvider = context.read<UserManagementProvider>();
      userProvider.refreshData();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _applyFilters() {
    final userProvider = context.read<UserManagementProvider>();
    userProvider.filterUsers(
      searchQuery: _searchController.text.trim(),
      role: _selectedRole.isEmpty ? null : _selectedRole,
      schoolId: _selectedSchool.isEmpty ? null : _selectedSchool,
      status: _selectedStatus.isEmpty ? null : _selectedStatus,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text('User Management'),
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
          Consumer<UserManagementProvider>(
            builder: (context, userProvider, child) {
              if (userProvider.currentUserHasPermission(Permission.CREATE_USER)) {
                return IconButton(
                  icon: Icon(_showCreateForm ? Icons.visibility : Icons.add),
                  onPressed: () {
                    setState(() {
                      _showCreateForm = !_showCreateForm;
                    });
                  },
                  tooltip: _showCreateForm ? 'Hide Form' : 'Add User',
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Create User Form
          if (_showCreateForm) _buildCreateUserForm(),
          
          // Filters Section
          _buildFiltersSection(),
          
          // Users List
          Expanded(
            child: _buildUsersList(),
          ),
        ],
      ),
    );
  }

  Widget _buildCreateUserForm() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.withValues(alpha: 0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: CreateUserForm(
        onUserCreated: () {
          setState(() {
            _showCreateForm = false;
          });
          _applyFilters();
        },
      ),
    );
  }

  Widget _buildFiltersSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Column(
        children: [
          // Search Bar
          CustomTextField(
            label: 'Search Users',
            hint: 'Search by name, username, or email',
            controller: _searchController,
            prefixIcon: const Icon(Icons.search),
            onChanged: (value) => _applyFilters(),
          ),
          const SizedBox(height: 16),
          
          // Filter Options
          Row(
            children: [
              // Role Filter
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: _selectedRole.isEmpty ? null : _selectedRole,
                  decoration: const InputDecoration(
                    labelText: 'Role',
                    border: OutlineInputBorder(),
                  ),
                  items: [
                    const DropdownMenuItem(
                      value: '',
                      child: Text('All Roles'),
                    ),
                    ...RolePermissions.getAvailableRoles().map((role) {
                      return DropdownMenuItem(
                        value: role,
                        child: Text(role),
                      );
                    }),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedRole = value ?? '';
                    });
                    _applyFilters();
                  },
                ),
              ),
              const SizedBox(width: 16),
              
              // Status Filter
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: _selectedStatus.isEmpty ? null : _selectedStatus,
                  decoration: const InputDecoration(
                    labelText: 'Status',
                    border: OutlineInputBorder(),
                  ),
                  items: [
                    const DropdownMenuItem(
                      value: '',
                      child: Text('All Status'),
                    ),
                    const DropdownMenuItem(
                      value: 'ACTIVE',
                      child: Text('Active'),
                    ),
                    const DropdownMenuItem(
                      value: 'INACTIVE',
                      child: Text('Inactive'),
                    ),
                    const DropdownMenuItem(
                      value: 'SUSPENDED',
                      child: Text('Suspended'),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedStatus = value ?? '';
                    });
                    _applyFilters();
                  },
                ),
              ),
              const SizedBox(width: 16),
              
              // School Filter
              Expanded(
                child: Consumer<MultiSchoolProvider>(
                  builder: (context, multiSchool, child) {
                    return DropdownButtonFormField<String>(
                      value: _selectedSchool.isEmpty ? null : _selectedSchool,
                      decoration: const InputDecoration(
                        labelText: 'School',
                        border: OutlineInputBorder(),
                      ),
                      items: [
                        const DropdownMenuItem(
                          value: '',
                          child: Text('All Schools'),
                        ),
                        ...multiSchool.schools.map((school) {
                          return DropdownMenuItem(
                            value: school.id,
                            child: Text(school.name),
                          );
                        }),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _selectedSchool = value ?? '';
                        });
                        _applyFilters();
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildUsersList() {
    return Consumer<UserManagementProvider>(
      builder: (context, userProvider, child) {
        if (userProvider.isLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (userProvider.error != null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 64,
                  color: Colors.red[400],
                ),
                const SizedBox(height: 16),
                Text(
                  'Error: ${userProvider.error}',
                  style: const TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => userProvider.refreshData(),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        if (userProvider.filteredUsers.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.people_outline,
                  size: 64,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                Text(
                  'No users found',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 8),
                if (userProvider.currentUserHasPermission(Permission.CREATE_USER))
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _showCreateForm = true;
                      });
                    },
                    child: const Text('Create First User'),
                  ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: userProvider.filteredUsers.length,
          itemBuilder: (context, index) {
            final user = userProvider.filteredUsers[index];
            return _buildUserCard(user, userProvider);
          },
        );
      },
    );
  }

  Widget _buildUserCard(User user, UserManagementProvider userProvider) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _getRoleColor(user.role),
          child: Text(
            user.fullName[0].toUpperCase(),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(
          user.fullName,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${user.role} • ${user.username}'),
            Text(user.email),
            if (user.schoolId != null)
              Consumer<MultiSchoolProvider>(
                builder: (context, multiSchool, child) {
                  final school = multiSchool.getSchoolById(user.schoolId!);
                  return Text('School: ${school?.name ?? 'Unknown'}');
                },
              ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: _getStatusColor(user.status),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                user.status,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        trailing: Consumer<UserManagementProvider>(
          builder: (context, userProvider, child) {
            if (userProvider.currentUserHasPermission(Permission.EDIT_USER) ||
                userProvider.currentUserHasPermission(Permission.DELETE_USER)) {
              return PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'edit') {
                    _showEditUserDialog(user, userProvider);
                  } else if (value == 'delete') {
                    _showDeleteUserDialog(user, userProvider);
                  } else if (value == 'status') {
                    _showStatusChangeDialog(user, userProvider);
                  } else if (value == 'role') {
                    _showRoleChangeDialog(user, userProvider);
                  }
                },
                itemBuilder: (context) => [
                  if (userProvider.currentUserHasPermission(Permission.EDIT_USER))
                    const PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          Icon(Icons.edit, size: 16),
                          SizedBox(width: 8),
                          Text('Edit'),
                        ],
                      ),
                    ),
                  if (userProvider.currentUserHasPermission(Permission.MANAGE_USER_ROLES))
                    const PopupMenuItem(
                      value: 'role',
                      child: Row(
                        children: [
                          Icon(Icons.swap_horiz, size: 16),
                          SizedBox(width: 8),
                          Text('Change Role'),
                        ],
                      ),
                    ),
                  if (userProvider.currentUserHasPermission(Permission.EDIT_USER))
                    const PopupMenuItem(
                      value: 'status',
                      child: Row(
                        children: [
                          Icon(Icons.block, size: 16),
                          SizedBox(width: 8),
                          Text('Change Status'),
                        ],
                      ),
                    ),
                  if (userProvider.currentUserHasPermission(Permission.DELETE_USER))
                    const PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete, size: 16),
                          SizedBox(width: 8),
                          Text('Delete'),
                        ],
                      ),
                    ),
                ],
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Color _getRoleColor(String role) {
    switch (role) {
      case 'Super Admin':
        return Colors.red;
      case 'School Admin':
        return Colors.blue;
      case 'Teacher':
        return Colors.green;
      case 'Parent':
        return Colors.orange;
      case 'Student':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'ACTIVE':
        return Colors.green;
      case 'INACTIVE':
        return Colors.orange;
      case 'SUSPENDED':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  void _showEditUserDialog(User user, UserManagementProvider userProvider) {
    showDialog(
      context: context,
      builder: (context) => EditUserDialog(user: user),
    );
  }

  void _showDeleteUserDialog(User user, UserManagementProvider userProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete User'),
        content: Text('Are you sure you want to delete ${user.fullName}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              final success = await userProvider.deleteUser(user.id);
              if (success) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${user.fullName} deleted successfully')),
                );
                _applyFilters();
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Failed to delete user: ${userProvider.error}'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showStatusChangeDialog(User user, UserManagementProvider userProvider) {
    String selectedStatus = user.status;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Change User Status'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Current status: ${user.status}'),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: selectedStatus,
              decoration: const InputDecoration(
                labelText: 'New Status',
                border: OutlineInputBorder(),
              ),
              items: ['ACTIVE', 'INACTIVE', 'SUSPENDED'].map((status) {
                return DropdownMenuItem(
                  value: status,
                  child: Text(status),
                );
              }).toList(),
              onChanged: (value) {
                selectedStatus = value!;
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              final success = await userProvider.changeUserStatus(user.id, selectedStatus);
              if (success) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${user.fullName} status changed to $selectedStatus')),
                );
                _applyFilters();
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Failed to change status: ${userProvider.error}'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  void _showRoleChangeDialog(User user, UserManagementProvider userProvider) {
    String selectedRole = user.role;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Change User Role'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Current role: ${user.role}'),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: selectedRole,
              decoration: const InputDecoration(
                labelText: 'New Role',
                border: OutlineInputBorder(),
              ),
              items: RolePermissions.getAvailableRoles().map((role) {
                return DropdownMenuItem(
                  value: role,
                  child: Text(role),
                );
              }).toList(),
              onChanged: (value) {
                selectedRole = value!;
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              final success = await userProvider.changeUserRole(user.id, selectedRole);
              if (success) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${user.fullName} role changed to $selectedRole')),
                );
                _applyFilters();
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Failed to change role: ${userProvider.error}'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }
}
