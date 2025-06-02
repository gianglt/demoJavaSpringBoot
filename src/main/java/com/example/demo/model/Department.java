package com.example.demo.model;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;
import java.util.UUID;

@Entity
@Table(name = "departments")
@Data // Lombok: tự động tạo getters, setters, toString, equals, hashCode
@NoArgsConstructor // Lombok: tự động tạo constructor không tham số
@AllArgsConstructor // Lombok: tự động tạo constructor với tất cả tham số
public class Department {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID) // Sử dụng UUID do DB sinh ra (ví dụ: gen_random_uuid()) hoặc Hibernate
    @Column(name = "department_id", updatable = false, nullable = false)
    private UUID departmentId;

    @NotBlank(message = "Department name cannot be blank")
    @Size(max = 100, message = "Department name cannot exceed 100 characters")
    @Column(name = "department_name", length = 100, nullable = false, unique = true)
    private String departmentName;

    @Column(name = "description", columnDefinition = "TEXT") // Chỉ định kiểu TEXT cho PostgreSQL
    private String description;

    @Size(max = 255, message = "Location cannot exceed 255 characters")
    @Column(name = "location", length = 255)
    private String location;
}
