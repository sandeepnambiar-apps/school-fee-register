package com.school.repository;

import com.school.entity.Bus;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface BusRepository extends JpaRepository<Bus, Long> {
    
    // Find buses by school ID
    List<Bus> findBySchoolId(String schoolId);
    
    // Find active buses
    List<Bus> findByIsActiveTrue();
    
    // Find active buses by school ID
    List<Bus> findBySchoolIdAndIsActiveTrue(String schoolId);
    
    // Find buses by bus number and school ID
    Bus findByBusNumberAndSchoolId(String busNumber, String schoolId);
    
    // Find buses that contain a specific student
    @Query("SELECT b FROM Bus b WHERE :studentId MEMBER OF b.studentIds")
    List<Bus> findBusesByStudentId(@Param("studentId") String studentId);
    
    // Find buses by status
    List<Bus> findByCurrentStatus(String status);
    
    // Find buses by status and school ID
    List<Bus> findByCurrentStatusAndSchoolId(String status, String schoolId);
}

