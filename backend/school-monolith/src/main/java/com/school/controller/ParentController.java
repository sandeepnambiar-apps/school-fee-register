package com.school.controller;

import com.school.dto.ParentDTO;
import com.school.dto.ParentLoginDTO;
import com.school.dto.ParentRegistrationDTO;
import com.school.service.ParentService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/parents")
@CrossOrigin(origins = "*")
public class ParentController {

    @Autowired
    private ParentService parentService;

    @PostMapping("/register")
    public ResponseEntity<?> registerParent(@RequestBody ParentRegistrationDTO registrationDTO) {
        try {
            ParentDTO parent = parentService.registerParent(registrationDTO);
            Map<String, Object> response = new HashMap<>();
            response.put("success", true);
            response.put("message", "Parent registered successfully");
            response.put("parent", parent);
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            Map<String, Object> response = new HashMap<>();
            response.put("success", false);
            response.put("message", e.getMessage());
            return ResponseEntity.badRequest().body(response);
        }
    }

    @PostMapping("/login")
    public ResponseEntity<?> loginParent(@RequestBody ParentLoginDTO loginDTO) {
        try {
            ParentDTO parent = parentService.loginParent(loginDTO);
            Map<String, Object> response = new HashMap<>();
            response.put("success", true);
            response.put("message", "Login successful");
            response.put("parent", parent);
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            Map<String, Object> response = new HashMap<>();
            response.put("success", false);
            response.put("message", e.getMessage());
            return ResponseEntity.badRequest().body(response);
        }
    }

    @GetMapping("/{id}")
    public ResponseEntity<?> getParentById(@PathVariable Long id) {
        try {
            ParentDTO parent = parentService.getParentById(id);
            Map<String, Object> response = new HashMap<>();
            response.put("success", true);
            response.put("parent", parent);
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            Map<String, Object> response = new HashMap<>();
            response.put("success", false);
            response.put("message", e.getMessage());
            return ResponseEntity.badRequest().body(response);
        }
    }

    @GetMapping("/school/{schoolId}")
    public ResponseEntity<?> getParentsBySchool(@PathVariable Long schoolId) {
        try {
            List<ParentDTO> parents = parentService.getAllParentsBySchool(schoolId);
            Map<String, Object> response = new HashMap<>();
            response.put("success", true);
            response.put("parents", parents);
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            Map<String, Object> response = new HashMap<>();
            response.put("success", false);
            response.put("message", e.getMessage());
            return ResponseEntity.badRequest().body(response);
        }
    }

    @PutMapping("/{id}")
    public ResponseEntity<?> updateParent(@PathVariable Long id, @RequestBody ParentRegistrationDTO updateDTO) {
        try {
            ParentDTO parent = parentService.updateParent(id, updateDTO);
            Map<String, Object> response = new HashMap<>();
            response.put("success", true);
            response.put("message", "Parent updated successfully");
            response.put("parent", parent);
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            Map<String, Object> response = new HashMap<>();
            response.put("success", false);
            response.put("message", e.getMessage());
            return ResponseEntity.badRequest().body(response);
        }
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<?> deleteParent(@PathVariable Long id) {
        try {
            parentService.deleteParent(id);
            Map<String, Object> response = new HashMap<>();
            response.put("success", true);
            response.put("message", "Parent deleted successfully");
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            Map<String, Object> response = new HashMap<>();
            response.put("success", false);
            response.put("message", e.getMessage());
            return ResponseEntity.badRequest().body(response);
        }
    }

    @PostMapping("/generate-login-code")
    public ResponseEntity<?> generateLoginCode() {
        try {
            String loginCode = parentService.generateLoginCode();
            Map<String, Object> response = new HashMap<>();
            response.put("success", true);
            response.put("loginCode", loginCode);
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            Map<String, Object> response = new HashMap<>();
            response.put("success", false);
            response.put("message", e.getMessage());
            return ResponseEntity.badRequest().body(response);
        }
    }

    @PostMapping("/verify-login-code")
    public ResponseEntity<?> verifyLoginCode(@RequestBody Map<String, String> request) {
        try {
            String loginCode = request.get("loginCode");
            Long schoolId = Long.parseLong(request.get("schoolId"));
            boolean isValid = parentService.verifyLoginCode(loginCode, schoolId);
            
            Map<String, Object> response = new HashMap<>();
            response.put("success", true);
            response.put("isValid", isValid);
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            Map<String, Object> response = new HashMap<>();
            response.put("success", false);
            response.put("message", e.getMessage());
            return ResponseEntity.badRequest().body(response);
        }
    }
}

