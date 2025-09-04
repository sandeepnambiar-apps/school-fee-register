package com.school.dto;

import lombok.Data;

import javax.validation.constraints.NotNull;
import java.time.LocalDateTime;

@Data
public class HomeworkSubmissionDTO {
    private Long id;

    @NotNull(message = "Homework ID is required")
    private Long homeworkId;

    @NotNull(message = "Student ID is required")
    private Long studentId;

    private String studentName;
    private String homeworkTitle;
    private String submissionText;
    private String attachments;
    private String status; // submitted, graded
    private LocalDateTime submittedAt;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
}


