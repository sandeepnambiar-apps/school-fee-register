package com.school.studentservice.service.impl;

import com.school.studentservice.model.Class;
import com.school.studentservice.repository.ClassRepository;
import com.school.studentservice.service.ClassService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class ClassServiceImpl implements ClassService {
    
    @Autowired
    private ClassRepository classRepository;
    
    @Override
    public List<Class> getAllClasses() {
        return classRepository.findAll();
    }
    
    @Override
    public List<Class> getActiveClasses() {
        return classRepository.findByIsActiveTrue();
    }
    
    @Override
    public Optional<Class> getClassById(Long id) {
        return classRepository.findByIdAndIsActiveTrue(id);
    }
    
    @Override
    public Class createClass(Class classEntity) {
        return classRepository.save(classEntity);
    }
    
    @Override
    public Class updateClass(Long id, Class classEntity) {
        Optional<Class> existingClass = classRepository.findById(id);
        if (existingClass.isPresent()) {
            Class updatedClass = existingClass.get();
            updatedClass.setName(classEntity.getName());
            updatedClass.setDescription(classEntity.getDescription());
            updatedClass.setGradeLevel(classEntity.getGradeLevel());
            updatedClass.setIsActive(classEntity.getIsActive());
            return classRepository.save(updatedClass);
        }
        throw new RuntimeException("Class not found with id: " + id);
    }
    
    @Override
    public void deleteClass(Long id) {
        classRepository.deleteById(id);
    }
    
    @Override
    public String getClassNameById(Long id) {
        Optional<Class> classEntity = classRepository.findById(id);
        if (classEntity.isPresent()) {
            return classEntity.get().getName();
        }
        // Return a default class name if not found
        return "Class " + id;
    }
} 