package com.school.studentservice.service;

import com.school.studentservice.dto.HomeworkDTO;
import com.school.studentservice.model.Homework;
import com.school.studentservice.model.TeacherSubject;
import com.school.studentservice.repository.HomeworkRepository;
import com.school.studentservice.repository.TeacherSubjectRepository;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.util.List;
import java.util.stream.Collectors;

@Service
public class HomeworkService {
    
    private static final Logger logger = LoggerFactory.getLogger(HomeworkService.class);
    
    @Autowired
    private HomeworkRepository homeworkRepository;
    
    @Autowired
    private TeacherSubjectRepository teacherSubjectRepository;
    
    /**
     * Create homework assignment (with teacher authorization)
     */
    public HomeworkDTO createHomework(HomeworkDTO homeworkDTO) {
        logger.info("Creating homework: {}", homeworkDTO.getTitle());
        
        // Verify teacher is authorized to assign homework for this subject, class, and section
        if (!isTeacherAuthorized(homeworkDTO.getTeacherId(), homeworkDTO.getSubjectId(), 
                                homeworkDTO.getClassId(), homeworkDTO.getSection())) {
            throw new RuntimeException("Teacher is not authorized to assign homework for this subject, class, and section");
        }
        
        Homework homework = homeworkDTO.toEntity();
        homework.setCreatedAt(java.time.LocalDateTime.now());
        homework.setUpdatedAt(java.time.LocalDateTime.now());
        
        homework = homeworkRepository.save(homework);
        logger.info("Homework created successfully with ID: {}", homework.getId());
        
        return new HomeworkDTO(homework);
    }
    
    /**
     * Update homework assignment (with teacher authorization)
     */
    public HomeworkDTO updateHomework(Long homeworkId, HomeworkDTO homeworkDTO) {
        logger.info("Updating homework: {}", homeworkId);
        
        Homework existingHomework = homeworkRepository.findById(homeworkId)
                .orElseThrow(() -> new RuntimeException("Homework not found with id: " + homeworkId));
        
        // Verify teacher is authorized to update this homework
        if (!existingHomework.getTeacherId().equals(homeworkDTO.getTeacherId())) {
            throw new RuntimeException("Teacher is not authorized to update this homework");
        }
        
        // Verify teacher is authorized for the new subject, class, and section
        if (!isTeacherAuthorized(homeworkDTO.getTeacherId(), homeworkDTO.getSubjectId(), 
                                homeworkDTO.getClassId(), homeworkDTO.getSection())) {
            throw new RuntimeException("Teacher is not authorized to assign homework for this subject, class, and section");
        }
        
        // Update fields
        existingHomework.setTitle(homeworkDTO.getTitle());
        existingHomework.setDescription(homeworkDTO.getDescription());
        existingHomework.setSubjectId(homeworkDTO.getSubjectId());
        existingHomework.setClassId(homeworkDTO.getClassId());
        existingHomework.setSection(homeworkDTO.getSection());
        existingHomework.setAssignedDate(homeworkDTO.getAssignedDate());
        existingHomework.setDueDate(homeworkDTO.getDueDate());
        existingHomework.setAttachmentUrl(homeworkDTO.getAttachmentUrl());
        existingHomework.setAttachmentName(homeworkDTO.getAttachmentName());
        existingHomework.setPriority(homeworkDTO.getPriority());
        existingHomework.setStatus(homeworkDTO.getStatus());
        existingHomework.setUpdatedAt(java.time.LocalDateTime.now());
        
        existingHomework = homeworkRepository.save(existingHomework);
        logger.info("Homework updated successfully: {}", homeworkId);
        
        return new HomeworkDTO(existingHomework);
    }
    
    /**
     * Get homework by ID
     */
    public HomeworkDTO getHomeworkById(Long homeworkId) {
        Homework homework = homeworkRepository.findById(homeworkId)
                .orElseThrow(() -> new RuntimeException("Homework not found with id: " + homeworkId));
        return new HomeworkDTO(homework);
    }
    
    /**
     * Get all homework by teacher
     */
    public List<HomeworkDTO> getHomeworkByTeacher(Long teacherId) {
        List<Homework> homeworkList = homeworkRepository.findByTeacherIdOrderByCreatedAtDesc(teacherId);
        return homeworkList.stream()
                .map(HomeworkDTO::new)
                .collect(Collectors.toList());
    }
    
    /**
     * Get homework by subject, class, and section (for students/parents)
     */
    public List<HomeworkDTO> getHomeworkBySubjectClassSection(Long subjectId, Long classId, String section) {
        List<Homework> homeworkList = homeworkRepository.findBySubjectIdAndClassIdAndSectionOrderByCreatedAtDesc(subjectId, classId, section);
        return homeworkList.stream()
                .map(HomeworkDTO::new)
                .collect(Collectors.toList());
    }
    
    /**
     * Get homework by class and section (for students/parents)
     */
    public List<HomeworkDTO> getHomeworkByClassSection(Long classId, String section) {
        List<Homework> homeworkList = homeworkRepository.findByClassIdAndSectionOrderByCreatedAtDesc(classId, section);
        return homeworkList.stream()
                .map(HomeworkDTO::new)
                .collect(Collectors.toList());
    }
    
    /**
     * Get homework by subject (for students/parents)
     */
    public List<HomeworkDTO> getHomeworkBySubject(Long subjectId) {
        List<Homework> homeworkList = homeworkRepository.findBySubjectIdOrderByCreatedAtDesc(subjectId);
        return homeworkList.stream()
                .map(HomeworkDTO::new)
                .collect(Collectors.toList());
    }
    
    /**
     * Get active homework by teacher
     */
    public List<HomeworkDTO> getActiveHomeworkByTeacher(Long teacherId) {
        List<Homework> homeworkList = homeworkRepository.findByTeacherIdAndStatusOrderByCreatedAtDesc(teacherId, Homework.Status.ACTIVE);
        return homeworkList.stream()
                .map(HomeworkDTO::new)
                .collect(Collectors.toList());
    }
    
    /**
     * Get overdue homework
     */
    public List<HomeworkDTO> getOverdueHomework() {
        List<Homework> homeworkList = homeworkRepository.findOverdueHomework(LocalDate.now());
        return homeworkList.stream()
                .map(HomeworkDTO::new)
                .collect(Collectors.toList());
    }
    
    /**
     * Get upcoming homework (due in next 7 days)
     */
    public List<HomeworkDTO> getUpcomingHomework() {
        LocalDate today = LocalDate.now();
        LocalDate nextWeek = today.plusDays(7);
        List<Homework> homeworkList = homeworkRepository.findUpcomingHomework(today, nextWeek);
        return homeworkList.stream()
                .map(HomeworkDTO::new)
                .collect(Collectors.toList());
    }
    
    /**
     * Get homework by due date range
     */
    public List<HomeworkDTO> getHomeworkByDueDateRange(LocalDate startDate, LocalDate endDate) {
        List<Homework> homeworkList = homeworkRepository.findByDueDateBetweenOrderByDueDateAsc(startDate, endDate);
        return homeworkList.stream()
                .map(HomeworkDTO::new)
                .collect(Collectors.toList());
    }
    
    /**
     * Get homework by priority
     */
    public List<HomeworkDTO> getHomeworkByPriority(Homework.Priority priority) {
        List<Homework> homeworkList = homeworkRepository.findByPriorityOrderByCreatedAtDesc(priority);
        return homeworkList.stream()
                .map(HomeworkDTO::new)
                .collect(Collectors.toList());
    }
    
    /**
     * Delete homework (with teacher authorization)
     */
    public void deleteHomework(Long homeworkId, Long teacherId) {
        logger.info("Deleting homework: {} by teacher: {}", homeworkId, teacherId);
        
        Homework homework = homeworkRepository.findById(homeworkId)
                .orElseThrow(() -> new RuntimeException("Homework not found with id: " + homeworkId));
        
        // Verify teacher is authorized to delete this homework
        if (!homework.getTeacherId().equals(teacherId)) {
            throw new RuntimeException("Teacher is not authorized to delete this homework");
        }
        
        homeworkRepository.delete(homework);
        logger.info("Homework deleted successfully: {}", homeworkId);
    }
    
    /**
     * Archive homework (with teacher authorization)
     */
    public HomeworkDTO archiveHomework(Long homeworkId, Long teacherId) {
        logger.info("Archiving homework: {} by teacher: {}", homeworkId, teacherId);
        
        Homework homework = homeworkRepository.findById(homeworkId)
                .orElseThrow(() -> new RuntimeException("Homework not found with id: " + homeworkId));
        
        // Verify teacher is authorized to archive this homework
        if (!homework.getTeacherId().equals(teacherId)) {
            throw new RuntimeException("Teacher is not authorized to archive this homework");
        }
        
        homework.setStatus(Homework.Status.ARCHIVED);
        homework.setUpdatedAt(java.time.LocalDateTime.now());
        
        homework = homeworkRepository.save(homework);
        logger.info("Homework archived successfully: {}", homeworkId);
        
        return new HomeworkDTO(homework);
    }
    
    /**
     * Complete homework (with teacher authorization)
     */
    public HomeworkDTO completeHomework(Long homeworkId, Long teacherId) {
        logger.info("Completing homework: {} by teacher: {}", homeworkId, teacherId);
        
        Homework homework = homeworkRepository.findById(homeworkId)
                .orElseThrow(() -> new RuntimeException("Homework not found with id: " + homeworkId));
        
        // Verify teacher is authorized to complete this homework
        if (!homework.getTeacherId().equals(teacherId)) {
            throw new RuntimeException("Teacher is not authorized to complete this homework");
        }
        
        homework.setStatus(Homework.Status.COMPLETED);
        homework.setUpdatedAt(java.time.LocalDateTime.now());
        
        homework = homeworkRepository.save(homework);
        logger.info("Homework completed successfully: {}", homeworkId);
        
        return new HomeworkDTO(homework);
    }
    
    /**
     * Get homework statistics for a teacher
     */
    public HomeworkStatistics getHomeworkStatistics(Long teacherId) {
        HomeworkStatistics stats = new HomeworkStatistics();
        
        stats.setTotalHomework(homeworkRepository.countByTeacherId(teacherId));
        stats.setActiveHomework(homeworkRepository.countActiveByTeacherId(teacherId));
        
        List<Homework> overdueHomework = homeworkRepository.findOverdueHomework(LocalDate.now());
        stats.setOverdueHomework((long) overdueHomework.size());
        
        LocalDate today = LocalDate.now();
        LocalDate nextWeek = today.plusDays(7);
        List<Homework> upcomingHomework = homeworkRepository.findUpcomingHomework(today, nextWeek);
        stats.setUpcomingHomework((long) upcomingHomework.size());
        
        return stats;
    }
    
    /**
     * Check if teacher is authorized to assign homework for the given subject, class, and section
     */
    private boolean isTeacherAuthorized(Long teacherId, Long subjectId, Long classId, String section) {
        List<TeacherSubject> teacherSubjects = teacherSubjectRepository
                .findByTeacherIdAndSubjectIdAndClassIdAndSectionAndIsActiveTrue(teacherId, subjectId, classId, section);
        return !teacherSubjects.isEmpty();
    }
    
    /**
     * Get subjects that a teacher can assign homework for
     */
    public List<Long> getTeacherSubjects(Long teacherId) {
        List<TeacherSubject> teacherSubjects = teacherSubjectRepository.findByTeacherIdAndIsActiveTrue(teacherId);
        return teacherSubjects.stream()
                .map(TeacherSubject::getSubjectId)
                .distinct()
                .collect(Collectors.toList());
    }
    
    /**
     * Get classes that a teacher can assign homework for
     */
    public List<Long> getTeacherClasses(Long teacherId) {
        List<TeacherSubject> teacherSubjects = teacherSubjectRepository.findByTeacherIdAndIsActiveTrue(teacherId);
        return teacherSubjects.stream()
                .map(TeacherSubject::getClassId)
                .distinct()
                .collect(Collectors.toList());
    }
    
    /**
     * Inner class for homework statistics
     */
    public static class HomeworkStatistics {
        private Long totalHomework;
        private Long activeHomework;
        private Long overdueHomework;
        private Long upcomingHomework;
        
        // Getters and Setters
        public Long getTotalHomework() {
            return totalHomework;
        }
        
        public void setTotalHomework(Long totalHomework) {
            this.totalHomework = totalHomework;
        }
        
        public Long getActiveHomework() {
            return activeHomework;
        }
        
        public void setActiveHomework(Long activeHomework) {
            this.activeHomework = activeHomework;
        }
        
        public Long getOverdueHomework() {
            return overdueHomework;
        }
        
        public void setOverdueHomework(Long overdueHomework) {
            this.overdueHomework = overdueHomework;
        }
        
        public Long getUpcomingHomework() {
            return upcomingHomework;
        }
        
        public void setUpcomingHomework(Long upcomingHomework) {
            this.upcomingHomework = upcomingHomework;
        }
    }
    
    /**
     * Get homework by academic year
     */
    public List<Homework> getHomeworkByAcademicYear(Long academicYearId) {
        return homeworkRepository.findByAcademicYearIdOrderByCreatedAtDesc(academicYearId);
    }
    
    /**
     * Get homework by teacher and academic year
     */
    public List<Homework> getHomeworkByTeacherAndAcademicYear(Long teacherId, Long academicYearId) {
        return homeworkRepository.findByTeacherIdAndAcademicYearIdOrderByCreatedAtDesc(teacherId, academicYearId);
    }
    
    /**
     * Get homework by class and academic year
     */
    public List<Homework> getHomeworkByClassAndAcademicYear(Long classId, Long academicYearId) {
        return homeworkRepository.findByClassIdAndAcademicYearIdOrderByCreatedAtDesc(classId, academicYearId);
    }
    
    /**
     * Get homework by subject, class, section and academic year
     */
    public List<Homework> getHomeworkBySubjectClassSectionAndAcademicYear(Long subjectId, Long classId, String section, Long academicYearId) {
        return homeworkRepository.findBySubjectIdAndClassIdAndSectionAndAcademicYearIdOrderByCreatedAtDesc(subjectId, classId, section, academicYearId);
    }
} 