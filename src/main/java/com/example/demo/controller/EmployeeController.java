package com.example.demo.controller;

import com.example.demo.dto.EmployeeSearchCriteria;
import com.example.demo.model.Employee;
import com.example.demo.service.EmployeeService;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping("/api/v1/employees")
public class EmployeeController {

    private final EmployeeService employeeService;

    @Autowired
    public EmployeeController(EmployeeService employeeService) {
        this.employeeService = employeeService;
    }

    @GetMapping
    public ResponseEntity<List<Employee>> getAllEmployees() {
        List<Employee> employees = employeeService.getAllEmployees();
        return ResponseEntity.ok(employees);
    }

    @GetMapping("/{id}")
    public ResponseEntity<Employee> getEmployeeById(@PathVariable UUID id) {
        return employeeService.getEmployeeById(id)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    @PostMapping
    public ResponseEntity<?> createEmployee(@Valid @RequestBody Employee employee) {
        if (employee.getEmployeeId() != null) {
            return ResponseEntity.badRequest().body("Employee ID must be null for creation.");
        }
        // Consider validating if departmentId or jobTitleId (if sent as part of a DTO) are valid
        // Or if Employee object contains Department/JobTitle objects, ensure they are fetched/managed correctly.
        try {
            Employee createdEmployee = employeeService.createEmployee(employee);
            return new ResponseEntity<>(createdEmployee, HttpStatus.CREATED);
        } catch (DataIntegrityViolationException e) {
            // Catch unique constraint violations (e.g., email, username)
            // A more specific exception handler (@ControllerAdvice) is recommended for production
            return ResponseEntity.status(HttpStatus.CONFLICT).body("Error creating employee: " + e.getMessage());
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("An unexpected error occurred: " + e.getMessage());
        }
    }

    @PutMapping("/{id}")
    public ResponseEntity<Employee> updateEmployee(@PathVariable UUID id, @Valid @RequestBody Employee employeeDetails) {
        return employeeService.updateEmployee(id, employeeDetails)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteEmployee(@PathVariable UUID id) {
        if (employeeService.deleteEmployee(id)) {
            return ResponseEntity.noContent().build();
        } else {
            return ResponseEntity.notFound().build();
        }
    }

    @GetMapping("/paged")
    public ResponseEntity<Page<Employee>> getAllEmployeesPaged(
            @RequestParam(name = "page", defaultValue = "0") int page,
            @RequestParam(name = "size", defaultValue = "10") int size) {
        Pageable pageable = PageRequest.of(page, size);
        Page<Employee> employeePage = employeeService.getAllEmployees(pageable);
        return ResponseEntity.ok(employeePage);
    }

    @GetMapping("/search")
    public ResponseEntity<?> searchEmployees(
            @RequestParam(name = "keyword", defaultValue = "") String keyword,
            @RequestParam(name = "page", required = false) Integer page,
            @RequestParam(name = "size", required = false) Integer size) {

        if (page != null && size != null) {
            Pageable pageable = PageRequest.of(page, size);
            Page<Employee> employeePage = employeeService.searchEmployees(keyword, pageable);
            return ResponseEntity.ok(employeePage);
        } else {
            List<Employee> employees = employeeService.searchEmployees(keyword);
            return ResponseEntity.ok(employees);
        }
    }

    @PostMapping("/search-advanced")
    public ResponseEntity<?> searchEmployeesAdvanced(
            @RequestBody EmployeeSearchCriteria criteria,
            @RequestParam(name = "page", required = false) Integer page,
            @RequestParam(name = "size", required = false) Integer size) {

        // Basic validation for criteria can be added here if needed
        // e.g. if (criteria == null) { return ResponseEntity.badRequest().body("Search criteria cannot be null."); }

        if (page != null && size != null) {
            Pageable pageable = PageRequest.of(page, size);
            Page<Employee> employeePage = employeeService.searchEmployeesByCriteria(criteria, pageable);
            return ResponseEntity.ok(employeePage);
        } else {
            List<Employee> employees = employeeService.searchEmployeesByCriteria(criteria);
            return ResponseEntity.ok(employees);
        }
    }
}