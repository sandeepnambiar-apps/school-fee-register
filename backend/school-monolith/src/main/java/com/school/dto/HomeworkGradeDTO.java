package com.school.dto;

import lombok.Data;

import javax.validation.constraints.NotNull;
import javax.validation.constraints.Min;
import javax.validation.constraints.Max;
import java.time.LocalDateTime;

@Data
public class HomeworkGradeDTO {
    private Long id;

    @NotNull(message = "Submission ID is required")
    private Long submissionId;

    @NotNull(message = "Grade is required")
    @Min(value = 0, message = "Grade must be at least 0")
    @Max(value = 100, message = "Grade must be at most 100")
    private Integer grade;

    private String feedback;
    private String gradedBy;
    private LocalDateTime gradedAt;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
}


