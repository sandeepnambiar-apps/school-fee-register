package com.school.service;

import com.school.dto.LoginRequestDTO;
import com.school.dto.LoginResponseDTO;
import com.school.dto.UserDTO;
import com.school.dto.UserRegistrationDTO;

public interface AuthService {

    LoginResponseDTO login(LoginRequestDTO loginRequest);

    UserDTO register(UserRegistrationDTO registrationDTO);

    void logout(String token);

    UserDTO getProfile(String token);

    UserDTO updateProfile(String token, UserDTO userDTO);

    void changePassword(String token, String oldPassword, String newPassword);

    void forgotPassword(String email);

    void resetPassword(String token, String newPassword);

    boolean validateToken(String token);

    LoginResponseDTO refreshToken(String token);
}


