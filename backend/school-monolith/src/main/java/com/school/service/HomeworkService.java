package com.school.service;

import com.school.dto.HomeworkDTO;
import com.school.dto.HomeworkSubmissionDTO;
import com.school.dto.HomeworkGradeDTO;

import java.util.List;

public interface HomeworkService {

    // Homework Assignment operations
    List<HomeworkDTO> getAllAssignments(Long schoolId);

    HomeworkDTO getAssignmentById(Long id, Long schoolId);

    HomeworkDTO createAssignment(HomeworkDTO homeworkDTO);

    HomeworkDTO updateAssignment(HomeworkDTO homeworkDTO);

    void deleteAssignment(Long id);

    List<HomeworkDTO> getAssignmentsByClass(String className, Long schoolId);

    List<HomeworkDTO> getAssignmentsBySubject(String subject, Long schoolId);

    // Homework Submission operations
    List<HomeworkSubmissionDTO> getAllSubmissions(Long schoolId);

    HomeworkSubmissionDTO getSubmissionById(Long id, Long schoolId);

    HomeworkSubmissionDTO submitHomework(HomeworkSubmissionDTO submissionDTO);

    HomeworkSubmissionDTO updateSubmission(HomeworkSubmissionDTO submissionDTO);

    void deleteSubmission(Long id);

    List<HomeworkSubmissionDTO> getSubmissionsByStudent(Long studentId, Long schoolId);

    List<HomeworkSubmissionDTO> getSubmissionsByAssignment(Long assignmentId, Long schoolId);

    // Homework Grading operations
    List<HomeworkGradeDTO> getAllGrades(Long schoolId);

    HomeworkGradeDTO getGradeById(Long id, Long schoolId);

    HomeworkGradeDTO createGrade(HomeworkGradeDTO gradeDTO);

    HomeworkGradeDTO updateGrade(HomeworkGradeDTO gradeDTO);

    void deleteGrade(Long id);

    List<HomeworkGradeDTO> getGradesByStudent(Long studentId, Long schoolId);

    List<HomeworkGradeDTO> getGradesByAssignment(Long assignmentId, Long schoolId);
}
