package com.school.feeservice.repository;

import com.school.feeservice.model.FeeStructure;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface FeeStructureRepository extends JpaRepository<FeeStructure, Long> {
    
    List<FeeStructure> findByClassId(Long classId);
    
    List<FeeStructure> findByAcademicYearId(Long academicYearId);
    
    List<FeeStructure> findByIsActive(Boolean isActive);
    
    @Query("SELECT fs FROM FeeStructure fs WHERE fs.classId = :classId AND fs.academicYearId = :academicYearId")
    List<FeeStructure> findByClassIdAndAcademicYearId(@Param("classId") Long classId, 
                                                     @Param("academicYearId") Long academicYearId);
    
    @Query("SELECT fs FROM FeeStructure fs WHERE fs.feeCategoryId = :feeCategoryId AND fs.isActive = true")
    List<FeeStructure> findByFeeCategoryIdAndActive(@Param("feeCategoryId") Long feeCategoryId);
} 