package com.school.studentservice.service;

import com.school.studentservice.model.Class;
import java.util.List;
import java.util.Optional;

public interface ClassService {
    
    List<Class> getAllClasses();
    
    List<Class> getActiveClasses();
    
    Optional<Class> getClassById(Long id);
    
    Class createClass(Class classEntity);
    
    Class updateClass(Long id, Class classEntity);
    
    void deleteClass(Long id);
    
    String getClassNameById(Long id);
} 