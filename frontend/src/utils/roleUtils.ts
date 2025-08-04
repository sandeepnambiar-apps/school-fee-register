// Role utility functions for the school management system

export type UserRole = 'SUPER_ADMIN' | 'SCHOOL_ADMIN' | 'TEACHER' | 'PARENT';

// Role hierarchy - higher roles have all permissions of lower roles
export const ROLE_HIERARCHY: Record<UserRole, number> = {
  'SUPER_ADMIN': 4,
  'SCHOOL_ADMIN': 3,
  'TEACHER': 2,
  'PARENT': 1
};

// Check if a user has a specific role or higher
export const hasRoleOrHigher = (userRole: string, requiredRole: UserRole): boolean => {
  const userLevel = ROLE_HIERARCHY[userRole as UserRole] || 0;
  const requiredLevel = ROLE_HIERARCHY[requiredRole];
  return userLevel >= requiredLevel;
};

// Check if a user has admin privileges (SUPER_ADMIN or SCHOOL_ADMIN)
export const hasAdminPrivileges = (userRole: string): boolean => {
  return hasRoleOrHigher(userRole, 'SCHOOL_ADMIN');
};

// Check if a user has super admin privileges
export const hasSuperAdminPrivileges = (userRole: string): boolean => {
  return userRole === 'SUPER_ADMIN';
};

// Check if a user can access server monitoring features
export const canAccessServerMonitoring = (userRole: string): boolean => {
  return userRole === 'SUPER_ADMIN';
};

// Get role display name
export const getRoleDisplayName = (role: string): string => {
  switch (role) {
    case 'SUPER_ADMIN':
      return 'System Administrator';
    case 'SCHOOL_ADMIN':
      return 'School Administrator';
    case 'TEACHER':
      return 'Teacher';
    case 'PARENT':
      return 'Parent';
    default:
      return 'User';
  }
};

// Get role description
export const getRoleDescription = (role: string): string => {
  switch (role) {
    case 'SUPER_ADMIN':
      return 'Full system access including server monitoring and technical features';
    case 'SCHOOL_ADMIN':
      return 'Complete school management access without technical features';
    case 'TEACHER':
      return 'Academic and classroom management access';
    case 'PARENT':
      return 'Access to children\'s information and payments';
    default:
      return 'Limited access';
  }
}; 