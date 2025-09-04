package com.school.repository;

import com.school.entity.Parent;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface ParentRepository extends JpaRepository<Parent, Long> {
    
    Optional<Parent> findByMobileNumberAndIsActiveTrue(String mobileNumber);
    
    Optional<Parent> findByLoginCodeAndIsActiveTrue(String loginCode);
    
    Optional<Parent> findByMobileNumberAndPasswordAndIsActiveTrue(String mobileNumber, String password);
    
    List<Parent> findBySchool_IdAndIsActiveTrue(Long schoolId);
    
    @Query("SELECT p FROM Parent p WHERE p.school.id = :schoolId AND p.isActive = true")
    List<Parent> findActiveParentsBySchoolId(@Param("schoolId") Long schoolId);
    
    boolean existsByMobileNumberAndIsActiveTrue(String mobileNumber);
    
    boolean existsByLoginCodeAndIsActiveTrue(String loginCode);
}

