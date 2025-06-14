package com.example.demo.service;

import com.example.demo.dto.EmployeeSearchCriteria;
import com.example.demo.model.Employee;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

public interface EmployeeService {

    List<Employee> getAllEmployees();

    Optional<Employee> getEmployeeById(UUID id);

    Employee createEmployee(Employee employee);

    Optional<Employee> updateEmployee(UUID id, Employee employeeDetails);

    boolean deleteEmployee(UUID id);

    Page<Employee> getAllEmployees(Pageable pageable);

    Page<Employee> searchEmployees(String keyword, Pageable pageable); // Tìm kiếm đơn giản theo keyword
    List<Employee> searchEmployees(String keyword);

    Page<Employee> searchEmployeesByCriteria(EmployeeSearchCriteria criteria, Pageable pageable);
    List<Employee> searchEmployeesByCriteria(EmployeeSearchCriteria criteria);
}