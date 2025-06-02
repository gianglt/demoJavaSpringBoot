package com.example.demo.dto;

import lombok.Data;

@Data // Lombok: tự động tạo getters, setters, toString, equals, hashCode
public class DepartmentSearchCriteria {
    private String departmentName;
    private String description;
}