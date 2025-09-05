package com.school.repository;

import com.school.entity.User;
import com.school.entity.User.UserRole;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface UserRepository extends JpaRepository<User, Long> {
    
    // Find user by mobile number
    Optional<User> findByMobileNumber(String mobileNumber);
    
    // Find user by mobile number and is active
    Optional<User> findByMobileNumberAndIsActiveTrue(String mobileNumber);
    
    // Find users by role
    List<User> findByRole(UserRole role);
    
    // Find users by school ID
    List<User> findBySchoolId(Long schoolId);
    
    // Find users by role and school ID
    List<User> findByRoleAndSchoolId(UserRole role, Long schoolId);
    
    // Find users by role and school ID and is active
    List<User> findByRoleAndSchoolIdAndIsActiveTrue(UserRole role, Long schoolId);
    
    // Find teachers by school ID and class assigned
    List<User> findByRoleAndSchoolIdAndClassAssigned(UserRole role, Long schoolId, String classAssigned);
    
    // Check if mobile number exists
    boolean existsByMobileNumber(String mobileNumber);
    
    // Check if mobile number exists and is active
    boolean existsByMobileNumberAndIsActiveTrue(String mobileNumber);
    
    // Find users by school ID and is active
    List<User> findBySchoolIdAndIsActiveTrue(Long schoolId);
    
    // Find Super Admins (schoolId is null)
    List<User> findByRoleAndSchoolIdIsNull(UserRole role);
    
    // Find users by role and is active
    List<User> findByRoleAndIsActiveTrue(UserRole role);
    
    // Custom query to find users with specific criteria
    @Query("SELECT u FROM User u WHERE u.role = :role AND (u.schoolId = :schoolId OR u.schoolId IS NULL) AND u.isActive = true")
    List<User> findUsersByRoleAndSchoolAccess(@Param("role") UserRole role, @Param("schoolId") Long schoolId);
    
    // Custom query to find users for a specific school (including Super Admins)
    @Query("SELECT u FROM User u WHERE (u.schoolId = :schoolId OR u.schoolId IS NULL) AND u.isActive = true")
    List<User> findUsersForSchool(@Param("schoolId") Long schoolId);
    
    // Custom query to find teachers for a specific class in a school
    @Query("SELECT u FROM User u WHERE u.role = 'TEACHER' AND u.schoolId = :schoolId AND u.classAssigned = :classAssigned AND u.isActive = true")
    List<User> findTeachersBySchoolAndClass(@Param("schoolId") Long schoolId, @Param("classAssigned") String classAssigned);
    
    // Custom query to find parents for a specific student
    @Query("SELECT u FROM User u WHERE u.role = 'PARENT' AND u.schoolId = :schoolId AND u.parentId = :parentId AND u.isActive = true")
    List<User> findParentsBySchoolAndParentId(@Param("schoolId") Long schoolId, @Param("parentId") Long parentId);
}
