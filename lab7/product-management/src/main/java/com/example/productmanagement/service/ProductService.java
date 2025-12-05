package com.example.productmanagement.service;

import com.example.productmanagement.entity.Product;

import java.math.BigDecimal;
import java.util.List;
import java.util.Optional;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;

public interface ProductService {
    List<Product> getAllProducts();
    
    Page<Product> getAllProducts(Pageable pageable);
    
    List<Product> getAllProducts(Sort sort);

    Optional<Product> getProductById(Long id);

    Product saveProduct(Product product);

    void deleteProduct(Long id);

    Page<Product> searchProducts(String keyword, Pageable pageable);

    List<Product> getProductsByCategory(String category);
    
    Page<Product> getProductsByCategory(String category, Pageable pageable);
    
    List<Product> searchProducts(String name, String category, BigDecimal minPrice, BigDecimal maxPrice);

    List<String> getAllCategories();
    
    long countByCategory(String category);
    
    BigDecimal calculateTotalValue();
    
    BigDecimal calculateAveragePrice();
    
    List<Product> findLowStockProducts(int threshold);
}
