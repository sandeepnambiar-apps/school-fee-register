package com.school.dto;

import lombok.Data;

import javax.validation.constraints.NotBlank;
import javax.validation.constraints.NotNull;
import java.time.LocalDate;
import java.time.LocalDateTime;

@Data
public class HomeworkDTO {
    private Long id;

    @NotBlank(message = "Title is required")
    private String title;

    @NotBlank(message = "Description is required")
    private String description;

    @NotBlank(message = "Subject is required")
    private String subject;

    @NotBlank(message = "Class is required")
    private String className;

    @NotNull(message = "Due date is required")
    private LocalDate dueDate;

    private String attachments;
    private String status; // active, completed, cancelled
    private Long teacherId;
    private String teacherName;
    private Long schoolId; // Multi-school support
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
}
