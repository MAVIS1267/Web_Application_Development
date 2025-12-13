package com.example.securecustomerapi;

import org.junit.jupiter.api.Test;
import org.springframework.boot.test.context.SpringBootTest;

@SpringBootTest
class SecureCustomerApiApplicationTests {

    @org.springframework.beans.factory.annotation.Autowired
    private com.example.securecustomerapi.repository.UserRepository userRepository;

    @Test
    void contextLoads() {
    }

    @Test
    void testFindUserByUsername() {
        // Assuming database has 'admin' user from migration/seed
        java.util.Optional<com.example.securecustomerapi.entity.User> user = userRepository.findByUsername("admin");
        
        if (user.isPresent()) {
            System.out.println("Found User: " + user.get().getUsername());
        } else {
            System.out.println("User not found!");
        }
    }
}
