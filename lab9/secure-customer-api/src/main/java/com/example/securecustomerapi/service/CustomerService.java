package com.example.securecustomerapi.service;

import com.example.securecustomerapi.dto.CustomerRequestDTO;
import com.example.securecustomerapi.dto.CustomerResponseDTO;
import com.example.securecustomerapi.dto.CustomerUpdateDTO;

import java.util.List;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

public interface CustomerService {

    List<CustomerResponseDTO> getAllCustomers();

    CustomerResponseDTO getCustomerById(Long id);

    CustomerResponseDTO createCustomer(CustomerRequestDTO requestDTO);

    CustomerResponseDTO updateCustomer(Long id, CustomerRequestDTO requestDTO);

    void deleteCustomer(Long id);

    List<CustomerResponseDTO> searchCustomers(String keyword);

    List<CustomerResponseDTO> getCustomersByStatus(String status);

    List<CustomerResponseDTO> advancedSearch(String name, String email, String status);

    Page<CustomerResponseDTO> getAllCustomers(Pageable pageable);

    CustomerResponseDTO updateCustomer(Long id, CustomerUpdateDTO updateDTO);
}
