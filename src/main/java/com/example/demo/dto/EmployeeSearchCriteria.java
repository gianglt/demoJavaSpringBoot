package com.example.demo.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.UUID;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class EmployeeSearchCriteria {
    private String firstName;
    private String lastName;
    private String email;
    private String jobTitleString; // Tìm theo trường job_title (string)
    private UUID departmentId;
    private String username;
    private Boolean active; // Sử dụng Boolean để cho phép tìm kiếm cả true, false hoặc không quan tâm (null)
}