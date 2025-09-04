class Permission {
  // Student Management
  static const String CREATE_STUDENT = 'create_student';
  static const String VIEW_STUDENT = 'view_student';
  static const String EDIT_STUDENT = 'edit_student';
  static const String DELETE_STUDENT = 'delete_student';
  static const String VIEW_KID_PROFILE = 'view_kid_profile';

  // Fee Management
  static const String VIEW_FEES = 'view_fees';
  static const String MANAGE_FEES = 'manage_fees';
  static const String CREATE_FEE_STRUCTURE = 'create_fee_structure';
  static const String EDIT_FEE_STRUCTURE = 'edit_fee_structure';
  static const String DELETE_FEE_STRUCTURE = 'delete_fee_structure';
  static const String RECORD_PAYMENT = 'record_payment';
  static const String VIEW_PAYMENT_HISTORY = 'view_payment_history';

  // Homework Management
  static const String CREATE_HOMEWORK = 'create_homework';
  static const String EDIT_HOMEWORK = 'edit_homework';
  static const String DELETE_HOMEWORK = 'delete_homework';
  static const String VIEW_HOMEWORK = 'view_homework';
  static const String ASSIGN_HOMEWORK = 'assign_homework';

  // Timetable Management
  static const String CREATE_TIMETABLE = 'create_timetable';
  static const String EDIT_TIMETABLE = 'edit_timetable';
  static const String DELETE_TIMETABLE = 'delete_timetable';
  static const String VIEW_TIMETABLE = 'view_timetable';

  // Marks Management
  static const String UPLOAD_MARKS = 'upload_marks';
  static const String EDIT_MARKS = 'edit_marks';
  static const String DELETE_MARKS = 'delete_marks';
  static const String VIEW_MARKS = 'view_marks';

  // Notification Management
  static const String SEND_NOTIFICATIONS = 'send_notifications';
  static const String VIEW_NOTIFICATIONS = 'view_notifications';
  static const String MANAGE_NOTIFICATIONS = 'manage_notifications';

  // Calendar Management
  static const String CREATE_EVENT = 'create_event';
  static const String EDIT_EVENT = 'edit_event';
  static const String DELETE_EVENT = 'delete_event';
  static const String VIEW_EVENT = 'view_event';

  // Reports
  static const String VIEW_REPORTS = 'view_reports';
  static const String GENERATE_REPORTS = 'generate_reports';
  static const String EXPORT_REPORTS = 'export_reports';

  // User Management
  static const String CREATE_USER = 'create_user';
  static const String EDIT_USER = 'edit_user';
  static const String DELETE_USER = 'delete_user';
  static const String VIEW_USERS = 'view_users';
  static const String MANAGE_USER_ROLES = 'manage_user_roles';

  // School Management
  static const String CREATE_SCHOOL = 'create_school';
  static const String EDIT_SCHOOL = 'edit_school';
  static const String DELETE_SCHOOL = 'delete_school';
  static const String VIEW_SCHOOL = 'view_school';
  static const String MANAGE_SCHOOL_CONFIG = 'manage_school_config';

  // System Management
  static const String VIEW_SYSTEM_LOGS = 'view_system_logs';
  static const String MANAGE_SYSTEM_SETTINGS = 'manage_system_settings';
  static const String BACKUP_RESTORE = 'backup_restore';
}

class RolePermissions {
  static const Map<String, List<String>> rolePermissions = {
    'Super Admin': [
      // All permissions
      Permission.CREATE_STUDENT,
      Permission.VIEW_STUDENT,
      Permission.EDIT_STUDENT,
      Permission.DELETE_STUDENT,
      Permission.VIEW_KID_PROFILE,
      Permission.VIEW_FEES,
      Permission.MANAGE_FEES,
      Permission.CREATE_FEE_STRUCTURE,
      Permission.EDIT_FEE_STRUCTURE,
      Permission.DELETE_FEE_STRUCTURE,
      Permission.RECORD_PAYMENT,
      Permission.VIEW_PAYMENT_HISTORY,
      Permission.CREATE_HOMEWORK,
      Permission.EDIT_HOMEWORK,
      Permission.DELETE_HOMEWORK,
      Permission.VIEW_HOMEWORK,
      Permission.ASSIGN_HOMEWORK,
      Permission.CREATE_TIMETABLE,
      Permission.EDIT_TIMETABLE,
      Permission.DELETE_TIMETABLE,
      Permission.VIEW_TIMETABLE,
      Permission.UPLOAD_MARKS,
      Permission.EDIT_MARKS,
      Permission.DELETE_MARKS,
      Permission.VIEW_MARKS,
      Permission.SEND_NOTIFICATIONS,
      Permission.VIEW_NOTIFICATIONS,
      Permission.MANAGE_NOTIFICATIONS,
      Permission.CREATE_EVENT,
      Permission.EDIT_EVENT,
      Permission.DELETE_EVENT,
      Permission.VIEW_EVENT,
      Permission.VIEW_REPORTS,
      Permission.GENERATE_REPORTS,
      Permission.EXPORT_REPORTS,
      Permission.CREATE_USER,
      Permission.EDIT_USER,
      Permission.DELETE_USER,
      Permission.VIEW_USERS,
      Permission.MANAGE_USER_ROLES,
      Permission.CREATE_SCHOOL,
      Permission.EDIT_SCHOOL,
      Permission.DELETE_SCHOOL,
      Permission.VIEW_SCHOOL,
      Permission.MANAGE_SCHOOL_CONFIG,
      Permission.VIEW_SYSTEM_LOGS,
      Permission.MANAGE_SYSTEM_SETTINGS,
      Permission.BACKUP_RESTORE,
    ],

    'School Admin': [
      // School-specific permissions
      Permission.CREATE_STUDENT,
      Permission.VIEW_STUDENT,
      Permission.EDIT_STUDENT,
      Permission.DELETE_STUDENT,
      Permission.VIEW_KID_PROFILE,
      Permission.VIEW_FEES,
      Permission.MANAGE_FEES,
      Permission.CREATE_FEE_STRUCTURE,
      Permission.EDIT_FEE_STRUCTURE,
      Permission.DELETE_FEE_STRUCTURE,
      Permission.RECORD_PAYMENT,
      Permission.VIEW_PAYMENT_HISTORY,
      Permission.CREATE_HOMEWORK,
      Permission.EDIT_HOMEWORK,
      Permission.DELETE_HOMEWORK,
      Permission.VIEW_HOMEWORK,
      Permission.ASSIGN_HOMEWORK,
      Permission.CREATE_TIMETABLE,
      Permission.EDIT_TIMETABLE,
      Permission.DELETE_TIMETABLE,
      Permission.VIEW_TIMETABLE,
      Permission.UPLOAD_MARKS,
      Permission.EDIT_MARKS,
      Permission.DELETE_MARKS,
      Permission.VIEW_MARKS,
      Permission.SEND_NOTIFICATIONS,
      Permission.VIEW_NOTIFICATIONS,
      Permission.MANAGE_NOTIFICATIONS,
      Permission.CREATE_EVENT,
      Permission.EDIT_EVENT,
      Permission.DELETE_EVENT,
      Permission.VIEW_EVENT,
      Permission.VIEW_REPORTS,
      Permission.GENERATE_REPORTS,
      Permission.EXPORT_REPORTS,
      Permission.CREATE_USER,
      Permission.EDIT_USER,
      Permission.DELETE_USER,
      Permission.VIEW_USERS,
      Permission.MANAGE_USER_ROLES,
      Permission.VIEW_SCHOOL,
      Permission.MANAGE_SCHOOL_CONFIG,
    ],

    'Teacher': [
      // Teacher-specific permissions
      Permission.VIEW_STUDENT,
      Permission.EDIT_STUDENT,
      Permission.VIEW_KID_PROFILE,
      Permission.VIEW_FEES,
      Permission.VIEW_PAYMENT_HISTORY,
      Permission.CREATE_HOMEWORK,
      Permission.EDIT_HOMEWORK,
      Permission.DELETE_HOMEWORK,
      Permission.VIEW_HOMEWORK,
      Permission.ASSIGN_HOMEWORK,
      Permission.VIEW_TIMETABLE,
      Permission.UPLOAD_MARKS,
      Permission.EDIT_MARKS,
      Permission.VIEW_MARKS,
      Permission.SEND_NOTIFICATIONS,
      Permission.VIEW_NOTIFICATIONS,
      Permission.VIEW_EVENT,
      Permission.VIEW_REPORTS,
      Permission.GENERATE_REPORTS,
      Permission.VIEW_USERS,
    ],

    'Parent': [
      // Parent-specific permissions
      Permission.VIEW_KID_PROFILE,
      Permission.VIEW_FEES,
      Permission.VIEW_PAYMENT_HISTORY,
      Permission.VIEW_HOMEWORK,
      Permission.VIEW_TIMETABLE,
      Permission.VIEW_MARKS,
      Permission.VIEW_NOTIFICATIONS,
      Permission.VIEW_EVENT,
      Permission.VIEW_REPORTS,
    ],

    'Student': [
      // Student-specific permissions
      Permission.VIEW_HOMEWORK,
      Permission.VIEW_TIMETABLE,
      Permission.VIEW_MARKS,
      Permission.VIEW_NOTIFICATIONS,
      Permission.VIEW_EVENT,
    ],
  };

  // Get permissions for a specific role
  static List<String> getPermissionsForRole(String role) {
    return rolePermissions[role] ?? [];
  }

  // Check if a role has a specific permission
  static bool hasPermission(String role, String permission) {
    final permissions = rolePermissions[role];
    return permissions != null && permissions.contains(permission);
  }

  // Get all available roles
  static List<String> getAvailableRoles() {
    return rolePermissions.keys.toList();
  }

  // Get roles that can perform a specific action
  static List<String> getRolesWithPermission(String permission) {
    final roles = <String>[];
    for (final entry in rolePermissions.entries) {
      if (entry.value.contains(permission)) {
        roles.add(entry.key);
      }
    }
    return roles;
  }
}


