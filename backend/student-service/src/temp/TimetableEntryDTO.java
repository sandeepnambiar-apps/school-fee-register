package com.school.studentservice.dto;

import com.school.studentservice.model.TimetableEntry;
import java.time.LocalTime;
import java.time.LocalDateTime;

public class TimetableEntryDTO {
    
    private Long id;
    private TimetableEntry.DayOfWeek dayOfWeek;
    private LocalTime startTime;
    private LocalTime endTime;
    private Integer periodNumber;
    private Long subjectId;
    private Long classId;
    private String section;
    private Long teacherId;
    private String roomNumber;
    private Long createdBy;
    private Long updatedBy;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    
    // Additional fields for display
    private String subjectName;
    private String className;
    private String teacherName;
    
    // Constructors
    public TimetableEntryDTO() {}
    
    public TimetableEntryDTO(TimetableEntry entry) {
        this.id = entry.getId();
        this.dayOfWeek = entry.getDayOfWeek();
        this.startTime = entry.getStartTime();
        this.endTime = entry.getEndTime();
        this.periodNumber = entry.getPeriodNumber();
        this.subjectId = entry.getSubjectId();
        this.classId = entry.getClassId();
        this.section = entry.getSection();
        this.teacherId = entry.getTeacherId();
        this.roomNumber = entry.getRoomNumber();
        this.createdBy = entry.getCreatedBy();
        this.updatedBy = entry.getUpdatedBy();
        this.createdAt = entry.getCreatedAt();
        this.updatedAt = entry.getUpdatedAt();
    }
    
    // Convert DTO to Entity
    public TimetableEntry toEntity() {
        TimetableEntry entry = new TimetableEntry();
        entry.setId(this.id);
        entry.setDayOfWeek(this.dayOfWeek);
        entry.setStartTime(this.startTime);
        entry.setEndTime(this.endTime);
        entry.setPeriodNumber(this.periodNumber);
        entry.setSubjectId(this.subjectId);
        entry.setClassId(this.classId);
        entry.setSection(this.section);
        entry.setTeacherId(this.teacherId);
        entry.setRoomNumber(this.roomNumber);
        entry.setCreatedBy(this.createdBy);
        entry.setUpdatedBy(this.updatedBy);
        return entry;
    }
    
    // Getters and Setters
    public Long getId() {
        return id;
    }
    
    public void setId(Long id) {
        this.id = id;
    }
    
    public TimetableEntry.DayOfWeek getDayOfWeek() {
        return dayOfWeek;
    }
    
    public void setDayOfWeek(TimetableEntry.DayOfWeek dayOfWeek) {
        this.dayOfWeek = dayOfWeek;
    }
    
    public LocalTime getStartTime() {
        return startTime;
    }
    
    public void setStartTime(LocalTime startTime) {
        this.startTime = startTime;
    }
    
    public LocalTime getEndTime() {
        return endTime;
    }
    
    public void setEndTime(LocalTime endTime) {
        this.endTime = endTime;
    }
    
    public Integer getPeriodNumber() {
        return periodNumber;
    }
    
    public void setPeriodNumber(Integer periodNumber) {
        this.periodNumber = periodNumber;
    }
    
    public Long getSubjectId() {
        return subjectId;
    }
    
    public void setSubjectId(Long subjectId) {
        this.subjectId = subjectId;
    }
    
    public Long getClassId() {
        return classId;
    }
    
    public void setClassId(Long classId) {
        this.classId = classId;
    }
    
    public String getSection() {
        return section;
    }
    
    public void setSection(String section) {
        this.section = section;
    }
    
    public Long getTeacherId() {
        return teacherId;
    }
    
    public void setTeacherId(Long teacherId) {
        this.teacherId = teacherId;
    }
    
    public String getRoomNumber() {
        return roomNumber;
    }
    
    public void setRoomNumber(String roomNumber) {
        this.roomNumber = roomNumber;
    }
    
    public Long getCreatedBy() {
        return createdBy;
    }
    
    public void setCreatedBy(Long createdBy) {
        this.createdBy = createdBy;
    }
    
    public Long getUpdatedBy() {
        return updatedBy;
    }
    
    public void setUpdatedBy(Long updatedBy) {
        this.updatedBy = updatedBy;
    }
    
    public LocalDateTime getCreatedAt() {
        return createdAt;
    }
    
    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }
    
    public LocalDateTime getUpdatedAt() {
        return updatedAt;
    }
    
    public void setUpdatedAt(LocalDateTime updatedAt) {
        this.updatedAt = updatedAt;
    }
    
    public String getSubjectName() {
        return subjectName;
    }
    
    public void setSubjectName(String subjectName) {
        this.subjectName = subjectName;
    }
    
    public String getClassName() {
        return className;
    }
    
    public void setClassName(String className) {
        this.className = className;
    }
    
    public String getTeacherName() {
        return teacherName;
    }
    
    public void setTeacherName(String teacherName) {
        this.teacherName = teacherName;
    }
} 