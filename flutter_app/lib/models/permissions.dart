enum Permission {
  CREATE_USER,
  EDIT_USER,
  DELETE_USER,
  MANAGE_USER_ROLES,
  VIEW_USERS,
  MANAGE_SCHOOLS,
  MANAGE_STUDENTS,
  MANAGE_TEACHERS,
  MANAGE_PARENTS,
  VIEW_REPORTS,
  MANAGE_FEES,
  MANAGE_ATTENDANCE,
  MANAGE_MARKS,
  MANAGE_HOMEWORK,
  MANAGE_ANNOUNCEMENTS,
  MANAGE_CALENDAR,
}

class RolePermissions {
  static const Map<String, List<Permission>> _rolePermissions = {
    'SUPER_ADMIN': [
      Permission.CREATE_USER,
      Permission.EDIT_USER,
      Permission.DELETE_USER,
      Permission.MANAGE_USER_ROLES,
      Permission.VIEW_USERS,
      Permission.MANAGE_SCHOOLS,
      Permission.MANAGE_STUDENTS,
      Permission.MANAGE_TEACHERS,
      Permission.MANAGE_PARENTS,
      Permission.VIEW_REPORTS,
      Permission.MANAGE_FEES,
      Permission.MANAGE_ATTENDANCE,
      Permission.MANAGE_MARKS,
      Permission.MANAGE_HOMEWORK,
      Permission.MANAGE_ANNOUNCEMENTS,
      Permission.MANAGE_CALENDAR,
    ],
    'SCHOOL_ADMIN': [
      Permission.CREATE_USER,
      Permission.EDIT_USER,
      Permission.DELETE_USER,
      Permission.VIEW_USERS,
      Permission.MANAGE_STUDENTS,
      Permission.MANAGE_TEACHERS,
      Permission.MANAGE_PARENTS,
      Permission.VIEW_REPORTS,
      Permission.MANAGE_FEES,
      Permission.MANAGE_ATTENDANCE,
      Permission.MANAGE_MARKS,
      Permission.MANAGE_HOMEWORK,
      Permission.MANAGE_ANNOUNCEMENTS,
      Permission.MANAGE_CALENDAR,
    ],
    'TEACHER': [
      Permission.CREATE_USER, // Can create parents
      Permission.VIEW_USERS,
      Permission.MANAGE_STUDENTS,
      Permission.MANAGE_ATTENDANCE,
      Permission.MANAGE_MARKS,
      Permission.MANAGE_HOMEWORK,
      Permission.MANAGE_ANNOUNCEMENTS,
    ],
    'PARENT': [
      Permission.VIEW_USERS, // Limited to own children
    ],
  };

  static List<Permission> getPermissionsForRole(String role) {
    return _rolePermissions[role] ?? [];
  }

  static bool hasPermission(String role, Permission permission) {
    final permissions = getPermissionsForRole(role);
    return permissions.contains(permission);
  }

  static List<String> getAvailableRoles() {
    return _rolePermissions.keys.toList();
  }

  static String getRoleDisplayName(String role) {
    switch (role) {
      case 'SUPER_ADMIN':
        return 'Super Admin';
      case 'SCHOOL_ADMIN':
        return 'School Admin';
      case 'TEACHER':
        return 'Teacher';
      case 'PARENT':
        return 'Parent';
      case 'STUDENT':
        return 'Student';
      default:
        return role;
    }
  }

  static String getRoleDescription(String role) {
    switch (role) {
      case 'SUPER_ADMIN':
        return 'Full system access across all schools';
      case 'SCHOOL_ADMIN':
        return 'Administrative access to assigned school';
      case 'TEACHER':
        return 'Teaching and student management access';
      case 'PARENT':
        return 'Access to children\'s information';
      case 'STUDENT':
        return 'Student account access';
      default:
        return 'Unknown role';
    }
  }
}