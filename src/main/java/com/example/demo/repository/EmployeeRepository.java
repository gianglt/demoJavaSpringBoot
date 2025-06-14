package com.example.demo.repository;

import com.example.demo.model.Department;
import com.example.demo.model.Employee;
import com.example.demo.model.JobTitle;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

@Repository
public interface EmployeeRepository extends JpaRepository<Employee, UUID>, JpaSpecificationExecutor<Employee> {

    // Tìm kiếm cơ bản
    Page<Employee> findByFirstNameContainingIgnoreCase(String firstName, Pageable pageable);
    List<Employee> findByFirstNameContainingIgnoreCase(String firstName);

    Page<Employee> findByLastNameContainingIgnoreCase(String lastName, Pageable pageable);
    List<Employee> findByLastNameContainingIgnoreCase(String lastName);

    Page<Employee> findByEmailContainingIgnoreCase(String email, Pageable pageable);
    List<Employee> findByEmailContainingIgnoreCase(String email);

    Optional<Employee> findByEmail(String email); // Tìm chính xác email (thường dùng để kiểm tra unique)
    Optional<Employee> findByUsername(String username); // Tìm chính xác username

    Page<Employee> findByJobTitleStringContainingIgnoreCase(String jobTitleString, Pageable pageable);
    List<Employee> findByJobTitleStringContainingIgnoreCase(String jobTitleString);

    Page<Employee> findByDepartment(Department department, Pageable pageable);
    Page<Employee> findByJobTitleEntity(JobTitle jobTitleEntity, Pageable pageable);
}