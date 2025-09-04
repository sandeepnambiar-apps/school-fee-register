package com.school.service.impl;

import com.school.dto.ParentDTO;
import com.school.dto.ParentLoginDTO;
import com.school.dto.ParentRegistrationDTO;
import com.school.entity.Parent;
import com.school.entity.School;
import com.school.repository.ParentRepository;
import com.school.repository.SchoolRepository;
import com.school.service.ParentService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;
import java.util.Random;
import java.util.stream.Collectors;

@Service
public class ParentServiceImpl implements ParentService {

    @Autowired
    private ParentRepository parentRepository;

    @Autowired
    private SchoolRepository schoolRepository;

    @Autowired
    private PasswordEncoder passwordEncoder;

    @Override
    public ParentDTO registerParent(ParentRegistrationDTO registrationDTO) {
        // Validate login code
        if (!verifyLoginCode(registrationDTO.getLoginCode(), registrationDTO.getSchoolId())) {
            throw new RuntimeException("Invalid login code for this school");
        }

        // Check if mobile number already exists
        if (parentRepository.existsByMobileNumberAndIsActiveTrue(registrationDTO.getMobileNumber())) {
            throw new RuntimeException("Mobile number already registered");
        }

        // Get school
        Optional<School> schoolOpt = schoolRepository.findById(registrationDTO.getSchoolId());
        if (schoolOpt.isEmpty()) {
            throw new RuntimeException("School not found");
        }

        // Create parent entity
        Parent parent = new Parent();
        parent.setMobileNumber(registrationDTO.getMobileNumber());
        parent.setPassword(passwordEncoder.encode(registrationDTO.getPassword()));
        parent.setName(registrationDTO.getName());
        parent.setEmail(registrationDTO.getEmail());
        parent.setLoginCode(registrationDTO.getLoginCode());
        parent.setSchool(schoolOpt.get());
        parent.setIsActive(true);

        Parent savedParent = parentRepository.save(parent);
        return convertToDTO(savedParent);
    }

    @Override
    public ParentDTO loginParent(ParentLoginDTO loginDTO) {
        Optional<Parent> parentOpt = parentRepository.findByMobileNumberAndIsActiveTrue(loginDTO.getMobileNumber());
        
        if (parentOpt.isEmpty()) {
            throw new RuntimeException("Invalid mobile number or password");
        }

        Parent parent = parentOpt.get();
        
        if (!passwordEncoder.matches(loginDTO.getPassword(), parent.getPassword())) {
            throw new RuntimeException("Invalid mobile number or password");
        }

        return convertToDTO(parent);
    }

    @Override
    public ParentDTO getParentById(Long id) {
        Optional<Parent> parentOpt = parentRepository.findById(id);
        if (parentOpt.isEmpty()) {
            throw new RuntimeException("Parent not found");
        }
        return convertToDTO(parentOpt.get());
    }

    @Override
    public List<ParentDTO> getAllParentsBySchool(Long schoolId) {
        List<Parent> parents = parentRepository.findActiveParentsBySchoolId(schoolId);
        return parents.stream()
                .map(this::convertToDTO)
                .collect(Collectors.toList());
    }

    @Override
    public ParentDTO updateParent(Long id, ParentRegistrationDTO updateDTO) {
        Optional<Parent> parentOpt = parentRepository.findById(id);
        if (parentOpt.isEmpty()) {
            throw new RuntimeException("Parent not found");
        }

        Parent parent = parentOpt.get();
        parent.setName(updateDTO.getName());
        parent.setEmail(updateDTO.getEmail());
        
        if (updateDTO.getPassword() != null && !updateDTO.getPassword().isEmpty()) {
            parent.setPassword(passwordEncoder.encode(updateDTO.getPassword()));
        }

        Parent savedParent = parentRepository.save(parent);
        return convertToDTO(savedParent);
    }

    @Override
    public void deleteParent(Long id) {
        Optional<Parent> parentOpt = parentRepository.findById(id);
        if (parentOpt.isPresent()) {
            Parent parent = parentOpt.get();
            parent.setIsActive(false);
            parentRepository.save(parent);
        }
    }

    @Override
    public String generateLoginCode() {
        Random random = new Random();
        StringBuilder code = new StringBuilder();
        
        // Generate 6-digit alphanumeric code
        for (int i = 0; i < 6; i++) {
            if (random.nextBoolean()) {
                // Add a letter
                code.append((char) (random.nextInt(26) + 'A'));
            } else {
                // Add a digit
                code.append(random.nextInt(10));
            }
        }
        
        return code.toString();
    }

    @Override
    public boolean verifyLoginCode(String loginCode, Long schoolId) {
        // For now, we'll use a simple verification
        // In a real implementation, this would check against a database of valid codes
        // associated with specific schools and students
        
        // Check if the login code exists and is not used
        Optional<Parent> existingParent = parentRepository.findByLoginCodeAndIsActiveTrue(loginCode);
        if (existingParent.isPresent()) {
            return false; // Code already used
        }
        
        // For demo purposes, accept any 6-character code
        return loginCode != null && loginCode.length() == 6;
    }

    private ParentDTO convertToDTO(Parent parent) {
        return new ParentDTO(
            parent.getId(),
            parent.getMobileNumber(),
            parent.getName(),
            parent.getEmail(),
            parent.getIsActive(),
            parent.getCreatedAt(),
            parent.getSchool().getId(),
            parent.getSchool().getName()
        );
    }
}

