# Lab 8: REST API & DTO PATTERN - Report

**Course:** Web Application Development \
**Student Name:** Mai Long Thiên \
**Date:** 06/12/2025

---

## Exercise 1: Project Setup (Section 4)

### Task 1.1: Create New Spring Boot Project

**Requirements:**

- Spring Boot: 3.3.x
- Group Id: com.example
- Artifact Id: customer-api
- Dependencies: Spring Web, Spring Data JPA, MySQL Driver, Validation, Lombok, Spring Boot DevTools.

**Code/Configuration:**
_Project created using Spring Initializr with the specified dependencies._

**Evaluation Criteria:**

| Criteria                               | Points |
| :------------------------------------- | :----- |
| Project created with correct structure | 2      |
| All dependencies added                 | 2      |
| Project opens without errors           | 1      |

**Explanation:**

- **Project Structure**: The project follows the standard Maven directory layout.
- **Dependencies**:
  - `spring-boot-starter-web`: For building RESTful APIs.
  - `spring-boot-starter-data-jpa`: For database interactions.
  - `mysql-connector-j`: JDBC driver for MySQL.
  - `spring-boot-starter-validation`: For input validation.

**Screenshot:**

![alt text](images/image.png)

---

### Task 1.2: Database Setup

**Requirements:**

- Create `customer_management` database.
- Create `customers` table with columns: `id`, `customer_code`, `full_name`, `email`, `phone`, `address`, `status`, `created_at`, `updated_at`.
- Insert sample data.

**SQL Script:**

```sql
CREATE DATABASE customer_management;
USE customer_management;

CREATE TABLE customers (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    customer_code VARCHAR(20) UNIQUE NOT NULL,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(20),
    address TEXT,
    status ENUM('ACTIVE', 'INACTIVE') DEFAULT 'ACTIVE',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Sample data
INSERT INTO customers (customer_code, full_name, email, phone, address, status) VALUES
('C001', 'John Doe', 'john.doe@example.com', '+1-555-0101', '123 Main St, New York', 'ACTIVE'),
('C002', 'Jane Smith', 'jane.smith@example.com', '+1-555-0102', '456 Oak Ave, Los Angeles', 'ACTIVE'),
('C003', 'Bob Johnson', 'bob.johnson@example.com', '+1-555-0103', '789 Pine Rd, Chicago', 'INACTIVE'),
('C004', 'Alice Brown', 'alice.brown@example.com', '+1-555-0104', '321 Elm St, Houston', 'ACTIVE'),
('C005', 'Charlie Wilson', 'charlie.wilson@example.com', '+1-555-0105', '654 Maple Dr, Seattle', 'ACTIVE');
```

**Evaluation Criteria:**

| Criteria                | Points |
| :---------------------- | :----- |
| Database created        | 2      |
| Table structure correct | 2      |
| Sample data inserted    | 1      |

**Explanation:**

- **Database**: `customer_management` database created.
- **Table**: `customers` table created with appropriate constraints (`UNIQUE`, `NOT NULL`) and `ENUM` for status.
- **Timestamps**: `created_at` and `updated_at` configured for automatic updates.

**Screenshot:**


![alt text](images/image-1.png)

---

### Task 1.3: Configuration

**File:** `src/main/resources/application.properties`

**Requirements:**

- Configure server port.
- Configure database connection.
- Configure JPA/Hibernate settings.
- Configure JSON formatting.

**Code:**

```properties
# Application
spring.application.name=customer-api
server.port=8080

# Database
spring.datasource.url=jdbc:mysql://localhost:3306/customer_management?useSSL=false
spring.datasource.username=root
spring.datasource.password=your_password
spring.datasource.driver-class-name=com.mysql.cj.jdbc.Driver

# JPA
spring.jpa.hibernate.ddl-auto=update
spring.jpa.show-sql=true
spring.jpa.properties.hibernate.format_sql=true
spring.jpa.properties.hibernate.dialect=org.hibernate.dialect.MySQLDialect

# JSON formatting
spring.jackson.serialization.indent_output=true
spring.jackson.serialization.write-dates-as-timestamps=false

# Logging
logging.level.com.example.customerapi=DEBUG
```

**Evaluation Criteria:**

| Criteria                       | Points |
| :----------------------------- | :----- |
| Database connection configured | 2      |
| JPA properties set correctly   | 2      |
| JSON formatting configured     | 1      |

**Explanation:**

- **Datasource**: Connects to local MySQL database.
- **JPA**: Configured to update schema automatically and show formatted SQL.
- **JSON**: Configured for pretty printing and ISO date format.

---

## Exercise 2: REST API Implementation (Section 5)

### Task 2.1: Entity Layer

**File:** `src/main/java/com/example/customerapi/entity/Customer.java`

**Requirements:**

- JPA Entity with annotations.
- Lifecycle callbacks (`@PrePersist`, `@PreUpdate`).
- Enum for `CustomerStatus`.

**Code:**

```java
package com.example.customerapi.entity;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "customers")
public class Customer {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "customer_code", unique = true, nullable = false, length = 20)
    private String customerCode;

    @Column(name = "full_name", nullable = false, length = 100)
    private String fullName;

    @Column(unique = true, nullable = false, length = 100)
    private String email;

    @Column(length = 20)
    private String phone;

    @Column(columnDefinition = "TEXT")
    private String address;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 20)
    private CustomerStatus status = CustomerStatus.ACTIVE;

    @Column(name = "created_at", updatable = false)
    private LocalDateTime createdAt;

    @Column(name = "updated_at")
    private LocalDateTime updatedAt;

    @PrePersist
    protected void onCreate() {
        this.createdAt = LocalDateTime.now();
        this.updatedAt = LocalDateTime.now();
    }

    @PreUpdate
    protected void onUpdate() {
        this.updatedAt = LocalDateTime.now();
    }

    // Constructors, Getters, Setters omitted for brevity
}

enum CustomerStatus {
    ACTIVE,
    INACTIVE
}
```

**Explanation:**

- **Entity**: Maps to `customers` table.
- **Lifecycle**: Automatically manages timestamps.
- **Enum**: Restricts status values.

---

### Task 2.2: DTO Layer

**Files:** `CustomerRequestDTO.java`, `CustomerResponseDTO.java`

**Requirements:**

- Separate Request and Response DTOs.
- Validation annotations in Request DTO.

**Code (CustomerRequestDTO):**

```java
package com.example.customerapi.dto;

import jakarta.validation.constraints.*;

public class CustomerRequestDTO {

    @NotBlank(message = "Customer code is required")
    @Size(min = 3, max = 20, message = "Customer code must be 3-20 characters")
    @Pattern(regexp = "^C\\d{3,}$", message = "Customer code must start with C followed by at least 3 digits")
    private String customerCode;

    @NotBlank(message = "Full name is required")
    @Size(min = 2, max = 100, message = "Name must be 2-100 characters")
    private String fullName;

    @NotBlank(message = "Email is required")
    @Email(message = "Invalid email format")
    private String email;

    @Pattern(regexp = "^\\+?[0-9]{10,20}$", message = "Invalid phone number format")
    private String phone;

    @Size(max = 500, message = "Address too long")
    private String address;

    private String status;

    // Getters and Setters
}
```

**Explanation:**

- **DTO Pattern**: Separates API contract from database entity.
- **Validation**: Ensures data integrity before processing.

---

### Task 2.3: Repository Layer

**File:** `src/main/java/com/example/customerapi/repository/CustomerRepository.java`

**Requirements:**

- Extend `JpaRepository`.
- Custom query methods.

**Code:**

```java
@Repository
public interface CustomerRepository extends JpaRepository<Customer, Long> {
    Optional<Customer> findByCustomerCode(String customerCode);
    Optional<Customer> findByEmail(String email);
    boolean existsByCustomerCode(String customerCode);
    boolean existsByEmail(String email);
    List<Customer> findByStatus(String status);

    @Query("SELECT c FROM Customer c WHERE " +
           "LOWER(c.fullName) LIKE LOWER(CONCAT('%', :keyword, '%')) OR " +
           "LOWER(c.email) LIKE LOWER(CONCAT('%', :keyword, '%')) OR " +
           "LOWER(c.customerCode) LIKE LOWER(CONCAT('%', :keyword, '%'))")
    List<Customer> searchCustomers(@Param("keyword") String keyword);
}
```

**Explanation:**

- **Queries**: Custom finders and JPQL search query.

---

### Task 2.4: Service Layer

**File:** `src/main/java/com/example/customerapi/service/CustomerServiceImpl.java`

**Requirements:**

- Business logic implementation.
- DTO conversion.
- Exception handling.

**Code:**

```java
@Service
@Transactional
public class CustomerServiceImpl implements CustomerService {
    // ... dependencies

    @Override
    public List<CustomerResponseDTO> getAllCustomers() {
        return customerRepository.findAll().stream()
            .map(this::convertToResponseDTO)
            .collect(Collectors.toList());
    }

    @Override
    public CustomerResponseDTO createCustomer(CustomerRequestDTO requestDTO) {
        if (customerRepository.existsByCustomerCode(requestDTO.getCustomerCode())) {
            throw new DuplicateResourceException("Customer code already exists");
        }
        // ... other checks and saving
        Customer customer = convertToEntity(requestDTO);
        Customer saved = customerRepository.save(customer);
        return convertToResponseDTO(saved);
    }

    // ... other methods (update, delete, search)
}
```

**Explanation:**

- **Logic**: Handles business rules (e.g., duplicate checks).
- **Conversion**: Maps between Entity and DTOs.

---

### Task 2.5: Controller Layer (REST API)

**File:** `src/main/java/com/example/customerapi/controller/CustomerRestController.java`

**Requirements:**

- REST endpoints.
- Proper HTTP methods and status codes.

**Code:**

```java
@RestController
@RequestMapping("/api/customers")
@CrossOrigin(origins = "*")
public class CustomerRestController {
    // ... dependencies

    @GetMapping
    public ResponseEntity<List<CustomerResponseDTO>> getAllCustomers() {
        return ResponseEntity.ok(customerService.getAllCustomers());
    }

    @PostMapping
    public ResponseEntity<CustomerResponseDTO> createCustomer(@Valid @RequestBody CustomerRequestDTO requestDTO) {
        return ResponseEntity.status(HttpStatus.CREATED).body(customerService.createCustomer(requestDTO));
    }

    // ... other endpoints (GET id, PUT, DELETE, search)
}
```

**Explanation:**

- **@RestController**: Returns JSON responses.
- **Endpoints**: Implements standard CRUD operations via HTTP verbs.

---

## Exercise 3: Exception Handling (Section 6)

### Task 3.1: Custom Exceptions & Global Handler

**Files:** `ResourceNotFoundException.java`, `DuplicateResourceException.java`, `GlobalExceptionHandler.java`

**Requirements:**

- Custom exception classes.
- Global handler using `@RestControllerAdvice`.

**Code (GlobalExceptionHandler):**

```java
@RestControllerAdvice
public class GlobalExceptionHandler {

    @ExceptionHandler(ResourceNotFoundException.class)
    public ResponseEntity<ErrorResponseDTO> handleResourceNotFoundException(ResourceNotFoundException ex, WebRequest request) {
        ErrorResponseDTO error = new ErrorResponseDTO(
            HttpStatus.NOT_FOUND.value(), "Not Found", ex.getMessage(), request.getDescription(false).replace("uri=", "")
        );
        return new ResponseEntity<>(error, HttpStatus.NOT_FOUND);
    }

    // ... other handlers (DuplicateResource, Validation, Global)
}
```

**Explanation:**

- **Global Handling**: Centralized error handling for consistent API responses.
- **Error DTO**: Standardized error format (timestamp, status, error, message, path).

---

## Exercise 4: Testing with REST Client (Section 7)

### Task 4.1: API Testing

**Requirements:**

- Test all endpoints using Thunder Client or cURL.
- Verify success and error scenarios.

**Test Cases:**

1.  **GET All Customers**: Retrieves list of customers.
2.  **GET Customer by ID**: Retrieves specific customer.
3.  **POST Create Customer**: Creates a new customer (Status 201).
4.  **PUT Update Customer**: Updates existing customer.
5.  **DELETE Customer**: Deletes a customer.
6.  **Search Customers**: Finds customers by keyword.
7.  **Validation Error**: Tries to create customer with invalid data (Status 400).
8.  **Resource Not Found**: Tries to get non-existent ID (Status 404).
9.  **Duplicate Resource**: Tries to create duplicate email/code (Status 409).

**Screenshots:**

- **Test 1: GET All Customers**
  ![alt text](images/image-2.png)

- **Test 2: GET Customer by ID**
  ![alt text](images/image-3.png)

- **Test 3: POST Create Customer**
![alt text](images/image-4.png)

- **Test 4: PUT Update Customer**
![alt text](images/image-5.png)

- **Test 5: DELETE Customer**
![alt text](images/image-6.png)

- **Test 6: Search Customers**
![alt text](images/image-7.png)

- **Test 7: Validation Error**
![alt text](images/image-8.png)

- **Test 8: Resource Not Found**
![alt text](images/image-9.png)

- **Test 9: Duplicate Resource**
![alt text](images/image-10.png)
---
