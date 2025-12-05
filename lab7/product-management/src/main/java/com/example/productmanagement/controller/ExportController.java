package com.example.productmanagement.controller;

import com.example.productmanagement.entity.Product;
import com.example.productmanagement.service.ProductService;
import org.apache.poi.ss.usermodel.*;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@Controller
@RequestMapping("/export")
public class ExportController {
    
    @Autowired
    private ProductService productService;
    
    @GetMapping("/excel")
    public void exportToExcel(HttpServletResponse response) throws IOException {
        // Create Excel workbook
        Workbook workbook = new XSSFWorkbook();
        Sheet sheet = workbook.createSheet("Products");
        
        // Create header row
        Row headerRow = sheet.createRow(0);
        String[] columns = {"ID", "Product Code", "Name", "Price", "Quantity", "Category", "Description"};
        
        for (int i = 0; i < columns.length; i++) {
            Cell cell = headerRow.createCell(i);
            cell.setCellValue(columns[i]);
        }
        
        // Write data
        List<Product> products = productService.getAllProducts();
        int rowNum = 1;
        
        for (Product product : products) {
            Row row = sheet.createRow(rowNum++);
            row.createCell(0).setCellValue(product.getId());
            row.createCell(1).setCellValue(product.getProductCode());
            row.createCell(2).setCellValue(product.getName());
            row.createCell(3).setCellValue(product.getPrice().doubleValue());
            row.createCell(4).setCellValue(product.getQuantity());
            row.createCell(5).setCellValue(product.getCategory());
            row.createCell(6).setCellValue(product.getDescription() != null ? product.getDescription() : "");
        }
        
        // Auto-size columns
        for (int i = 0; i < columns.length; i++) {
            sheet.autoSizeColumn(i);
        }
        
        // Send to browser
        response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
        response.setHeader("Content-Disposition", "attachment; filename=products.xlsx");
        
        workbook.write(response.getOutputStream());
        workbook.close();
    }
}
