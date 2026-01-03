# Secure Customer API with JWT Authentication

## Student Information

- **Name:** [Your Name]
- **Student ID:** [Your ID]
- **Class:** [Your Class]

## Features Implemented

### Authentication

- ✅ User registration
- ✅ User login with JWT
- ✅ Logout (Client-side token removal instructions)
- ✅ Get current user details
- ✅ Password hashing with BCrypt

### Authorization

- ✅ Role-based access control (USER, ADMIN)
- ✅ Protected endpoints for Customers

### Homework Exercises (Part B)

- **Exercise 6: Password Management**

  - ✅ Change Password (`PUT /api/auth/change-password`)
  - ✅ Forgot Password (Token generation)
  - ✅ Reset Password (with valid token)

- **Exercise 7: User Profile Management**

  - ✅ Update Profile (Name, Email) (`PUT /api/auth/me`)

- **Exercise 8: Admin Endpoints**

  - ✅ List all users (`GET /api/users`) - _Admin Only_
  - ✅ Delete user (`DELETE /api/users/{id}`) - _Admin Only_

- **Exercise 9: Refresh Token Mechanism**
  - ✅ Refresh Token Entity & Service
  - ✅ Generate Refresh Token on Login
  - ✅ Refresh Access Token Endpoint (`POST /api/auth/refresh-token`)
  - ✅ Token Expiration Handling

## How to Run

1. Create database: `customer_management`
2. Run SQL scripts to create tables
3. Update `application.properties` with your MySQL credentials
4. Run: `mvn spring-boot:run`

## Time Spent

Approximately 4 hours
