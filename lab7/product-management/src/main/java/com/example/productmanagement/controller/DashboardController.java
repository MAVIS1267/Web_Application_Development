package com.example.productmanagement.controller;

import com.example.productmanagement.service.ProductService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/dashboard")
public class DashboardController {
    
    @Autowired
    private ProductService productService;
    
    @GetMapping
    public String showDashboard(Model model) {
        // Add statistics to model
        model.addAttribute("totalProducts", productService.getAllProducts().size());
        model.addAttribute("categories", productService.getAllCategories());
        model.addAttribute("productService", productService);
        model.addAttribute("totalValue", productService.calculateTotalValue());
        model.addAttribute("averagePrice", productService.calculateAveragePrice());
        model.addAttribute("lowStockProducts", productService.findLowStockProducts(10));
        model.addAttribute("recentProducts", productService.getAllProducts().stream()
                .sorted((p1, p2) -> p2.getCreatedAt().compareTo(p1.getCreatedAt()))
                .limit(5)
                .toList());
        
        return "dashboard";
    }
}
