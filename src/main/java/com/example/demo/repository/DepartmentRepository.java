package com.example.demo.repository;

import com.example.demo.model.Department;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.UUID;

@Repository
public interface DepartmentRepository extends JpaRepository<Department, UUID> {
    // JpaRepository đã cung cấp sẵn phương thức findAll(Pageable pageable)

    Page<Department> findByDepartmentNameContainingIgnoreCase(String departmentName, Pageable pageable);
    List<Department> findByDepartmentNameContainingIgnoreCase(String departmentName);

    // Tìm kiếm theo cả departmentName và description
    Page<Department> findByDepartmentNameContainingIgnoreCaseAndDescriptionContainingIgnoreCase(String departmentName, String description, Pageable pageable);
    List<Department> findByDepartmentNameContainingIgnoreCaseAndDescriptionContainingIgnoreCase(String departmentName, String description);

    Page<Department> findByDescriptionContainingIgnoreCase(String description, Pageable pageable);
    List<Department> findByDescriptionContainingIgnoreCase(String description);
}