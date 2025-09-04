package com.school.service.impl;

import com.school.dto.HomeworkDTO;
import com.school.dto.HomeworkSubmissionDTO;
import com.school.dto.HomeworkGradeDTO;
import com.school.service.HomeworkService;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import java.util.stream.Collectors;

@Service
public class HomeworkServiceImpl implements HomeworkService {

    private final Map<Long, HomeworkDTO> mockAssignments = new ConcurrentHashMap<>();
    private final Map<Long, HomeworkSubmissionDTO> mockSubmissions = new ConcurrentHashMap<>();
    private final Map<Long, HomeworkGradeDTO> mockGrades = new ConcurrentHashMap<>();

    private long nextAssignmentId = 1;
    private long nextSubmissionId = 1;
    private long nextGradeId = 1;

    public HomeworkServiceImpl() {
        initializeMockData();
    }

    private void initializeMockData() {
        // Initialize homework assignments
        createMockAssignment("Algebra Practice", "Complete exercises 1-20 from Chapter 5", "Mathematics", "Class 10");
        createMockAssignment("Science Project", "Create a model of solar system", "Science", "Class 9");
        createMockAssignment("Essay Writing", "Write a 500-word essay on 'My Dream Career'", "English", "Class 10");
        createMockAssignment("History Timeline", "Create timeline of World War II", "History", "Class 9");

        // Initialize submissions
        createMockSubmission(1L, 1L, "John Doe", "Algebra Practice", "Completed all exercises");
        createMockSubmission(2L, 1L, "Jane Smith", "Algebra Practice", "Completed exercises 1-15");
        createMockSubmission(3L, 2L, "Mike Johnson", "Science Project", "Solar system model completed");

        // Initialize grades
        createMockGrade(1L, 95, "Excellent work! All exercises completed correctly.");
        createMockGrade(2L, 75, "Good effort, but some exercises incomplete.");
        createMockGrade(3L, 88, "Great project! Very creative approach.");
    }

    private void createMockAssignment(String title, String description, String subject, String className) {
        HomeworkDTO assignment = new HomeworkDTO();
        assignment.setId(nextAssignmentId++);
        assignment.setTitle(title);
        assignment.setDescription(description);
        assignment.setSubject(subject);
        assignment.setClassName(className);
        assignment.setDueDate(LocalDate.now().plusDays(7));
        assignment.setAttachments("worksheet.pdf");
        assignment.setStatus("ACTIVE");
        assignment.setTeacherId(1L);
        assignment.setTeacherName("Mr. Johnson");
        assignment.setSchoolId(1L); // Demo school ID
        assignment.setCreatedAt(LocalDateTime.now());

        mockAssignments.put(assignment.getId(), assignment);
    }

    private void createMockSubmission(Long homeworkId, Long studentId, String studentName,
                                      String homeworkTitle, String submissionText) {
        HomeworkSubmissionDTO submission = new HomeworkSubmissionDTO();
        submission.setId(nextSubmissionId++);
        submission.setHomeworkId(homeworkId);
        submission.setStudentId(studentId);
        submission.setStudentName(studentName);
        submission.setHomeworkTitle(homeworkTitle);
        submission.setSubmissionText(submissionText);
        submission.setAttachments("submission.pdf");
        submission.setStatus("SUBMITTED");
        submission.setSubmittedAt(LocalDateTime.now());
        submission.setCreatedAt(LocalDateTime.now());

        mockSubmissions.put(submission.getId(), submission);
    }

    private void createMockGrade(Long submissionId, Integer grade, String feedback) {
        HomeworkGradeDTO gradeObj = new HomeworkGradeDTO();
        gradeObj.setId(nextGradeId++);
        gradeObj.setSubmissionId(submissionId);
        gradeObj.setGrade(grade);
        gradeObj.setFeedback(feedback);
        gradeObj.setGradedBy("Mr. Johnson");
        gradeObj.setGradedAt(LocalDateTime.now());
        gradeObj.setCreatedAt(LocalDateTime.now());

        mockGrades.put(gradeObj.getId(), gradeObj);
    }

    // Homework Assignment implementations
    @Override
    public List<HomeworkDTO> getAllAssignments(Long schoolId) {
        if (schoolId == null) {
            return new ArrayList<>();
        }
        return mockAssignments.values().stream()
                .filter(assignment -> schoolId.equals(assignment.getSchoolId()))
                .collect(Collectors.toList());
    }

    @Override
    public HomeworkDTO getAssignmentById(Long id, Long schoolId) {
        HomeworkDTO assignment = mockAssignments.get(id);
        if (assignment == null || !schoolId.equals(assignment.getSchoolId())) {
            throw new RuntimeException("Homework assignment not found with ID: " + id);
        }
        return assignment;
    }

    @Override
    public HomeworkDTO createAssignment(HomeworkDTO homeworkDTO) {
        homeworkDTO.setId(nextAssignmentId++);
        homeworkDTO.setCreatedAt(LocalDateTime.now());
        mockAssignments.put(homeworkDTO.getId(), homeworkDTO);
        return homeworkDTO;
    }

    @Override
    public HomeworkDTO updateAssignment(HomeworkDTO homeworkDTO) {
        HomeworkDTO existing = mockAssignments.get(homeworkDTO.getId());
        if (existing == null) {
            throw new RuntimeException("Homework assignment not found with ID: " + homeworkDTO.getId());
        }

        existing.setTitle(homeworkDTO.getTitle());
        existing.setDescription(homeworkDTO.getDescription());
        existing.setSubject(homeworkDTO.getSubject());
        existing.setClassName(homeworkDTO.getClassName());
        existing.setDueDate(homeworkDTO.getDueDate());
        existing.setAttachments(homeworkDTO.getAttachments());
        existing.setStatus(homeworkDTO.getStatus());
        existing.setUpdatedAt(LocalDateTime.now());

        return existing;
    }

    @Override
    public void deleteAssignment(Long id) {
        HomeworkDTO assignment = mockAssignments.remove(id);
        if (assignment == null) {
            throw new RuntimeException("Homework assignment not found with ID: " + id);
        }
    }

    @Override
    public List<HomeworkDTO> getAssignmentsByClass(String className, Long schoolId) {
        if (schoolId == null) {
            return new ArrayList<>();
        }
        return mockAssignments.values().stream()
                .filter(assignment -> assignment.getClassName().equals(className) && schoolId.equals(assignment.getSchoolId()))
                .collect(Collectors.toList());
    }

    @Override
    public List<HomeworkDTO> getAssignmentsBySubject(String subject, Long schoolId) {
        if (schoolId == null) {
            return new ArrayList<>();
        }
        return mockAssignments.values().stream()
                .filter(assignment -> assignment.getSubject().equals(subject) && schoolId.equals(assignment.getSchoolId()))
                .collect(Collectors.toList());
    }

    // Homework Submission implementations
    @Override
    public List<HomeworkSubmissionDTO> getAllSubmissions(Long schoolId) {
        if (schoolId == null) {
            return new ArrayList<>();
        }
        // For now, return all submissions since they don't have schoolId yet
        // In a real implementation, submissions would be linked to assignments with schoolId
        return new ArrayList<>(mockSubmissions.values());
    }

    @Override
    public HomeworkSubmissionDTO getSubmissionById(Long id, Long schoolId) {
        HomeworkSubmissionDTO submission = mockSubmissions.get(id);
        if (submission == null) {
            throw new RuntimeException("Homework submission not found with ID: " + id);
        }
        return submission;
    }

    @Override
    public HomeworkSubmissionDTO submitHomework(HomeworkSubmissionDTO submissionDTO) {
        submissionDTO.setId(nextSubmissionId++);
        submissionDTO.setCreatedAt(LocalDateTime.now());
        mockSubmissions.put(submissionDTO.getId(), submissionDTO);
        return submissionDTO;
    }

    @Override
    public HomeworkSubmissionDTO updateSubmission(HomeworkSubmissionDTO submissionDTO) {
        HomeworkSubmissionDTO existing = mockSubmissions.get(submissionDTO.getId());
        if (existing == null) {
            throw new RuntimeException("Homework submission not found with ID: " + submissionDTO.getId());
        }

        existing.setSubmissionText(submissionDTO.getSubmissionText());
        existing.setAttachments(submissionDTO.getAttachments());
        existing.setUpdatedAt(LocalDateTime.now());

        return existing;
    }

    @Override
    public void deleteSubmission(Long id) {
        HomeworkSubmissionDTO submission = mockSubmissions.remove(id);
        if (submission == null) {
            throw new RuntimeException("Homework submission not found with ID: " + id);
        }
    }

    @Override
    public List<HomeworkSubmissionDTO> getSubmissionsByStudent(Long studentId, Long schoolId) {
        if (schoolId == null) {
            return new ArrayList<>();
        }
        // For now, return all submissions since they don't have schoolId yet
        return mockSubmissions.values().stream()
                .filter(submission -> submission.getStudentId().equals(studentId))
                .collect(Collectors.toList());
    }

    @Override
    public List<HomeworkSubmissionDTO> getSubmissionsByAssignment(Long assignmentId, Long schoolId) {
        if (schoolId == null) {
            return new ArrayList<>();
        }
        // For now, return all submissions since they don't have schoolId yet
        return mockSubmissions.values().stream()
                .filter(submission -> submission.getHomeworkId().equals(assignmentId))
                .collect(Collectors.toList());
    }

    // Homework Grading implementations
    @Override
    public List<HomeworkGradeDTO> getAllGrades(Long schoolId) {
        if (schoolId == null) {
            return new ArrayList<>();
        }
        // For now, return all grades since they don't have schoolId yet
        return new ArrayList<>(mockGrades.values());
    }

    @Override
    public HomeworkGradeDTO getGradeById(Long id, Long schoolId) {
        HomeworkGradeDTO grade = mockGrades.get(id);
        if (grade == null) {
            throw new RuntimeException("Homework grade not found with ID: " + id);
        }
        return grade;
    }

    @Override
    public HomeworkGradeDTO createGrade(HomeworkGradeDTO gradeDTO) {
        gradeDTO.setId(nextGradeId++);
        gradeDTO.setCreatedAt(LocalDateTime.now());
        mockGrades.put(gradeDTO.getId(), gradeDTO);
        return gradeDTO;
    }

    @Override
    public HomeworkGradeDTO updateGrade(HomeworkGradeDTO gradeDTO) {
        HomeworkGradeDTO existing = mockGrades.get(gradeDTO.getId());
        if (existing == null) {
            throw new RuntimeException("Homework grade not found with ID: " + gradeDTO.getId());
        }

        existing.setGrade(gradeDTO.getGrade());
        existing.setFeedback(gradeDTO.getFeedback());
        existing.setUpdatedAt(LocalDateTime.now());

        return existing;
    }

    @Override
    public void deleteGrade(Long id) {
        HomeworkGradeDTO grade = mockGrades.remove(id);
        if (grade == null) {
            throw new RuntimeException("Homework grade not found with ID: " + id);
        }
    }

    @Override
    public List<HomeworkGradeDTO> getGradesByStudent(Long studentId, Long schoolId) {
        if (schoolId == null) {
            return new ArrayList<>();
        }
        // For now, return all grades since they don't have schoolId yet
        return mockSubmissions.values().stream()
                .filter(submission -> submission.getStudentId().equals(studentId))
                .flatMap(submission -> mockGrades.values().stream()
                        .filter(grade -> grade.getSubmissionId().equals(submission.getId())))
                .collect(Collectors.toList());
    }

    @Override
    public List<HomeworkGradeDTO> getGradesByAssignment(Long assignmentId, Long schoolId) {
        if (schoolId == null) {
            return new ArrayList<>();
        }
        // For now, return all grades since they don't have schoolId yet
        return mockSubmissions.values().stream()
                .filter(submission -> submission.getHomeworkId().equals(assignmentId))
                .flatMap(submission -> mockGrades.values().stream()
                        .filter(grade -> grade.getSubmissionId().equals(submission.getId())))
                .collect(Collectors.toList());
    }
}
