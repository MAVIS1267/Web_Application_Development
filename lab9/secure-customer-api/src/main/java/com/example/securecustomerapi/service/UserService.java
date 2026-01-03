package com.example.securecustomerapi.service;

import com.example.securecustomerapi.dto.*;

public interface UserService {

    LoginResponseDTO login(LoginRequestDTO loginRequest);

    UserResponseDTO register(RegisterRequestDTO registerRequest);

    UserResponseDTO getCurrentUser(String username);

    void changePassword(String username, ChangePasswordDTO dto);
    String forgotPassword(String email);
    void resetPassword(String token, String newPassword);

    UserResponseDTO updateProfile(String username, UserUpdateDTO dto);
    java.util.List<UserResponseDTO> getAllUsers();
    void deleteUser(Long id);
}
