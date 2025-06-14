package com.example.demo.model;

import jakarta.persistence.*;
import jakarta.validation.constraints.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.OffsetDateTime;
import java.util.UUID;

@Entity
@Table(name = "employees", uniqueConstraints = {
        @UniqueConstraint(columnNames = "email", name = "employees_email_key_constraint"), // Tên constraint cho email unique
        @UniqueConstraint(columnNames = "username", name = "employees_username_key_constraint") // Tên constraint cho username unique
})
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Employee {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    @Column(name = "employee_id", updatable = false, nullable = false)
    private UUID employeeId;

    @NotBlank(message = "First name cannot be blank")
    @Size(max = 50, message = "First name cannot exceed 50 characters")
    @Column(name = "first_name", length = 50, nullable = false)
    private String firstName;

    @NotBlank(message = "Last name cannot be blank")
    @Size(max = 50, message = "Last name cannot exceed 50 characters")
    @Column(name = "last_name", length = 50, nullable = false)
    private String lastName;

    @NotBlank(message = "Email cannot be blank")
    @Email(message = "Email should be valid")
    @Size(max = 100, message = "Email cannot exceed 100 characters")
    @Column(name = "email", length = 100, nullable = false) // unique = true được xử lý bởi @UniqueConstraint ở @Table
    private String email;

    @Size(max = 20, message = "Phone number cannot exceed 20 characters")
    @Column(name = "phone_number", length = 20)
    private String phoneNumber;

    @NotNull(message = "Hire date cannot be null")
    @Column(name = "hire_date", nullable = false)
    private LocalDate hireDate;

    // Trường này tương ứng với cột 'job_title' kiểu string trong DB.
    // DDL: job_title character varying(100) COLLATE pg_catalog."default" NOT NULL
    @NotBlank(message = "Job title string cannot be blank")
    @Size(max = 100, message = "Job title string cannot exceed 100 characters")
    @Column(name = "job_title", length = 100, nullable = false)
    private String jobTitleString;

    // Trường này liên kết với JobTitle entity thông qua job_title_id (FK)
    // DDL: job_title_id uuid (có thể null)
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "job_title_id")
    private JobTitle jobTitleEntity;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "department_id")
    private Department department;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "manager_id")
    private Employee manager; // Quan hệ tự tham chiếu đến Employee khác (quản lý)

    @Digits(integer = 8, fraction = 2, message = "Salary must have up to 8 digits for the integer part and 2 for the fractional part.")
    @Column(name = "salary", precision = 10, scale = 2)
    private BigDecimal salary;

    @CreationTimestamp
    @Column(name = "created_at", nullable = false, updatable = false, columnDefinition = "TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP")
    private OffsetDateTime createdAt;

    @UpdateTimestamp
    @Column(name = "updated_at", columnDefinition = "TIMESTAMP WITH TIME ZONE")
    private OffsetDateTime updatedAt;

    @Size(max = 255, message = "Username cannot exceed 255 characters")
    @Column(name = "username", length = 255) // unique = true được xử lý bởi @UniqueConstraint ở @Table
    private String username;

    @Column(name = "active", nullable = false, columnDefinition = "boolean DEFAULT true")
    private boolean active = true; // Giá trị mặc định trong Java, khớp với DB

    // Liên kết với app_user table.
    // Nếu có AppUser entity, đây sẽ là @ManyToOne hoặc @OneToOne AppUser appUser;
    @Column(name = "app_user_id")
    private UUID appUserId;
}