package com.schoolfeeregister.authservice.service;

import com.schoolfeeregister.authservice.dto.LoginRequest;
import com.schoolfeeregister.authservice.dto.LoginResponse;
import com.schoolfeeregister.authservice.model.User;
import com.schoolfeeregister.authservice.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.Optional;

@Service
public class AuthService {
    
    @Autowired
    private AuthenticationManager authenticationManager;
    
    @Autowired
    private JwtService jwtService;
    
    @Autowired
    private UserRepository userRepository;
    
    @Autowired
    private PasswordEncoder passwordEncoder;
    
    public LoginResponse login(LoginRequest loginRequest) {
        String loginIdentifier;
        Optional<User> userOpt;
        
        // Determine login method and find user
        if (loginRequest.getMobile() != null && !loginRequest.getMobile().trim().isEmpty()) {
            // Mobile number login
            loginIdentifier = loginRequest.getMobile();
            userOpt = userRepository.findByPhone(loginRequest.getMobile());
        } else if (loginRequest.getUsername() != null && !loginRequest.getUsername().trim().isEmpty()) {
            // Username login
            loginIdentifier = loginRequest.getUsername();
            userOpt = userRepository.findByUsername(loginRequest.getUsername());
        } else {
            throw new RuntimeException("Either username or mobile number is required");
        }
        
        if (userOpt.isEmpty()) {
            throw new RuntimeException("User not found");
        }
        
        User user = userOpt.get();
        
        // Authenticate user using the found username
        Authentication authentication = authenticationManager.authenticate(
            new UsernamePasswordAuthenticationToken(
                user.getUsername(), // Always use username for authentication
                loginRequest.getPassword()
            )
        );
        
        SecurityContextHolder.getContext().setAuthentication(authentication);
        
        // Update last login
        user.setLastLoginAt(LocalDateTime.now());
        userRepository.save(user);
        
        // Generate tokens
        String token = jwtService.generateToken(
            user.getUsername(),
            user.getId(),
            user.getRole().name(),
            user.getUserType().name(),
            user.getStudentId()
        );
        
        String refreshToken = jwtService.generateRefreshToken(user.getUsername());
        
        // Calculate expiration
        LocalDateTime expiresAt = LocalDateTime.now().plusSeconds(86400); // 24 hours
        
        return new LoginResponse(
            token,
            refreshToken,
            user.getId(),
            user.getUsername(),
            user.getFullName(),
            user.getRole().name(),
            user.getUserType().name(),
            user.getStudentId(),
            expiresAt
        );
    }
    
    public LoginResponse refreshToken(String refreshToken) {
        if (!jwtService.validateToken(refreshToken)) {
            throw new RuntimeException("Invalid refresh token");
        }
        
        String username = jwtService.extractUsername(refreshToken);
        Optional<User> userOpt = userRepository.findByUsername(username);
        
        if (userOpt.isEmpty()) {
            throw new RuntimeException("User not found");
        }
        
        User user = userOpt.get();
        
        // Generate new tokens
        String newToken = jwtService.generateToken(
            user.getUsername(),
            user.getId(),
            user.getRole().name(),
            user.getUserType().name(),
            user.getStudentId()
        );
        
        String newRefreshToken = jwtService.generateRefreshToken(user.getUsername());
        
        // Calculate expiration
        LocalDateTime expiresAt = LocalDateTime.now().plusSeconds(86400); // 24 hours
        
        return new LoginResponse(
            newToken,
            newRefreshToken,
            user.getId(),
            user.getUsername(),
            user.getFullName(),
            user.getRole().name(),
            user.getUserType().name(),
            user.getStudentId(),
            expiresAt
        );
    }
    
    public void logout(String token) {
        // In a real implementation, you might want to blacklist the token
        // For now, we'll just validate it was a valid token
        if (!jwtService.validateToken(token)) {
            throw new RuntimeException("Invalid token");
        }
        
        // Token is considered logged out
        // In production, you might want to add it to a blacklist
    }
    
    public User getCurrentUser(String token) {
        if (!jwtService.validateToken(token)) {
            throw new RuntimeException("Invalid token");
        }
        
        String username = jwtService.extractUsername(token);
        Optional<User> userOpt = userRepository.findByUsername(username);
        
        if (userOpt.isEmpty()) {
            throw new RuntimeException("User not found");
        }
        
        return userOpt.get();
    }
    
    public boolean validateToken(String token) {
        return jwtService.validateToken(token);
    }
} 