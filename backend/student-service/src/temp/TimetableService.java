package com.school.studentservice.service;

import com.school.studentservice.dto.TimetableEntryDTO;
import com.school.studentservice.model.TimetableEntry;
import com.school.studentservice.repository.TimetableEntryRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.stream.Collectors;

@Service
public class TimetableService {
    
    @Autowired
    private TimetableEntryRepository timetableEntryRepository;
    
    // Get all timetable entries
    public List<TimetableEntryDTO> getAllTimetableEntries() {
        return timetableEntryRepository.findAllOrderedByDayAndPeriod()
                .stream()
                .map(TimetableEntryDTO::new)
                .collect(Collectors.toList());
    }
    
    // Get timetable entries by class and section
    public List<TimetableEntryDTO> getTimetableByClassAndSection(Long classId, String section) {
        return timetableEntryRepository.findByClassAndSectionOrdered(classId, section)
                .stream()
                .map(TimetableEntryDTO::new)
                .collect(Collectors.toList());
    }
    
    // Get timetable entries by teacher
    public List<TimetableEntryDTO> getTimetableByTeacher(Long teacherId) {
        return timetableEntryRepository.findByTeacherOrdered(teacherId)
                .stream()
                .map(TimetableEntryDTO::new)
                .collect(Collectors.toList());
    }
    
    // Get timetable entries by day
    public List<TimetableEntryDTO> getTimetableByDay(TimetableEntry.DayOfWeek dayOfWeek) {
        return timetableEntryRepository.findByDayOfWeek(dayOfWeek)
                .stream()
                .map(TimetableEntryDTO::new)
                .collect(Collectors.toList());
    }
    
    // Get timetable entries by class, section and day
    public List<TimetableEntryDTO> getTimetableByClassSectionAndDay(Long classId, String section, TimetableEntry.DayOfWeek dayOfWeek) {
        return timetableEntryRepository.findByClassIdAndSectionAndDayOfWeek(classId, section, dayOfWeek)
                .stream()
                .map(TimetableEntryDTO::new)
                .collect(Collectors.toList());
    }
    
    // Get timetable entries by teacher and day
    public List<TimetableEntryDTO> getTimetableByTeacherAndDay(Long teacherId, TimetableEntry.DayOfWeek dayOfWeek) {
        return timetableEntryRepository.findByTeacherIdAndDayOfWeek(teacherId, dayOfWeek)
                .stream()
                .map(TimetableEntryDTO::new)
                .collect(Collectors.toList());
    }
    
    // Get timetable entries by subject
    public List<TimetableEntryDTO> getTimetableBySubject(Long subjectId) {
        return timetableEntryRepository.findBySubjectId(subjectId)
                .stream()
                .map(TimetableEntryDTO::new)
                .collect(Collectors.toList());
    }
    
    // Get timetable entries by period
    public List<TimetableEntryDTO> getTimetableByPeriod(Integer periodNumber) {
        return timetableEntryRepository.findByPeriodNumber(periodNumber)
                .stream()
                .map(TimetableEntryDTO::new)
                .collect(Collectors.toList());
    }
    
    // Create new timetable entry
    public TimetableEntryDTO createTimetableEntry(TimetableEntryDTO entryDTO) {
        // Check for conflicts
        TimetableEntry existingEntry = timetableEntryRepository.findByClassSectionDayPeriod(
            entryDTO.getClassId(), 
            entryDTO.getSection(), 
            entryDTO.getDayOfWeek(), 
            entryDTO.getPeriodNumber()
        );
        
        if (existingEntry != null) {
            throw new RuntimeException("A timetable entry already exists for this class, section, day and period");
        }
        
        // Check teacher availability
        TimetableEntry teacherConflict = timetableEntryRepository.findByTeacherDayPeriod(
            entryDTO.getTeacherId(), 
            entryDTO.getDayOfWeek(), 
            entryDTO.getPeriodNumber()
        );
        
        if (teacherConflict != null) {
            throw new RuntimeException("Teacher is already assigned to another class during this period");
        }
        
        TimetableEntry entry = entryDTO.toEntity();
        TimetableEntry savedEntry = timetableEntryRepository.save(entry);
        return new TimetableEntryDTO(savedEntry);
    }
    
    // Update timetable entry
    public TimetableEntryDTO updateTimetableEntry(Long entryId, TimetableEntryDTO entryDTO) {
        TimetableEntry existingEntry = timetableEntryRepository.findById(entryId)
                .orElseThrow(() -> new RuntimeException("Timetable entry not found"));
        
        // Check for conflicts (excluding current entry)
        TimetableEntry conflictEntry = timetableEntryRepository.findByClassSectionDayPeriod(
            entryDTO.getClassId(), 
            entryDTO.getSection(), 
            entryDTO.getDayOfWeek(), 
            entryDTO.getPeriodNumber()
        );
        
        if (conflictEntry != null && !conflictEntry.getId().equals(entryId)) {
            throw new RuntimeException("A timetable entry already exists for this class, section, day and period");
        }
        
        // Check teacher availability (excluding current entry)
        TimetableEntry teacherConflict = timetableEntryRepository.findByTeacherDayPeriod(
            entryDTO.getTeacherId(), 
            entryDTO.getDayOfWeek(), 
            entryDTO.getPeriodNumber()
        );
        
        if (teacherConflict != null && !teacherConflict.getId().equals(entryId)) {
            throw new RuntimeException("Teacher is already assigned to another class during this period");
        }
        
        existingEntry.setDayOfWeek(entryDTO.getDayOfWeek());
        existingEntry.setStartTime(entryDTO.getStartTime());
        existingEntry.setEndTime(entryDTO.getEndTime());
        existingEntry.setPeriodNumber(entryDTO.getPeriodNumber());
        existingEntry.setSubjectId(entryDTO.getSubjectId());
        existingEntry.setClassId(entryDTO.getClassId());
        existingEntry.setSection(entryDTO.getSection());
        existingEntry.setTeacherId(entryDTO.getTeacherId());
        existingEntry.setRoomNumber(entryDTO.getRoomNumber());
        existingEntry.setUpdatedBy(entryDTO.getUpdatedBy());
        
        TimetableEntry updatedEntry = timetableEntryRepository.save(existingEntry);
        return new TimetableEntryDTO(updatedEntry);
    }
    
    // Delete timetable entry
    public void deleteTimetableEntry(Long entryId) {
        if (!timetableEntryRepository.existsById(entryId)) {
            throw new RuntimeException("Timetable entry not found");
        }
        timetableEntryRepository.deleteById(entryId);
    }
    
    // Get timetable entry by ID
    public TimetableEntryDTO getTimetableEntryById(Long entryId) {
        TimetableEntry entry = timetableEntryRepository.findById(entryId)
                .orElseThrow(() -> new RuntimeException("Timetable entry not found"));
        return new TimetableEntryDTO(entry);
    }
    
    // Get timetable entries by creator
    public List<TimetableEntryDTO> getTimetableEntriesByCreator(Long createdBy) {
        return timetableEntryRepository.findByCreatedBy(createdBy)
                .stream()
                .map(TimetableEntryDTO::new)
                .collect(Collectors.toList());
    }
    
    // Check for timetable conflicts
    public boolean hasConflict(Long classId, String section, TimetableEntry.DayOfWeek dayOfWeek, Integer periodNumber, Long excludeEntryId) {
        TimetableEntry conflict = timetableEntryRepository.findByClassSectionDayPeriod(classId, section, dayOfWeek, periodNumber);
        return conflict != null && !conflict.getId().equals(excludeEntryId);
    }
    
    // Check for teacher conflicts
    public boolean hasTeacherConflict(Long teacherId, TimetableEntry.DayOfWeek dayOfWeek, Integer periodNumber, Long excludeEntryId) {
        TimetableEntry conflict = timetableEntryRepository.findByTeacherDayPeriod(teacherId, dayOfWeek, periodNumber);
        return conflict != null && !conflict.getId().equals(excludeEntryId);
    }
} 