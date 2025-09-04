package com.school.service;

import com.school.dto.ParentDTO;
import com.school.dto.ParentLoginDTO;
import com.school.dto.ParentRegistrationDTO;

import java.util.List;

public interface ParentService {
    
    ParentDTO registerParent(ParentRegistrationDTO registrationDTO);
    
    ParentDTO loginParent(ParentLoginDTO loginDTO);
    
    ParentDTO getParentById(Long id);
    
    List<ParentDTO> getAllParentsBySchool(Long schoolId);
    
    ParentDTO updateParent(Long id, ParentRegistrationDTO updateDTO);
    
    void deleteParent(Long id);
    
    String generateLoginCode();
    
    boolean verifyLoginCode(String loginCode, Long schoolId);
}

