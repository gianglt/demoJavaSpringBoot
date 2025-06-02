package com.example.demo.controller;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import com.example.demo.dto.DepartmentSearchCriteria;
import com.example.demo.model.Department;
import com.example.demo.service.DepartmentService;
import jakarta.validation.Valid; 
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.beans.factory.annotation.Autowired;

import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping("/api/v1/departments") // Đường dẫn cơ sở cho các endpoint của department
public class DepartmentController {

    private final DepartmentService departmentService;

    @Autowired
    public DepartmentController(DepartmentService departmentService) {
        this.departmentService = departmentService;
    }

    // GET: Lấy tất cả departments
    @GetMapping
    public ResponseEntity<List<Department>> getAllDepartments() {
        List<Department> departments = departmentService.getAllDepartments();
        return ResponseEntity.ok(departments);
    }

    // GET: Lấy một department theo ID
    @GetMapping("/{id}")
    public ResponseEntity<Department> getDepartmentById(@PathVariable UUID id) {
        return departmentService.getDepartmentById(id)
                .map(ResponseEntity::ok) // Nếu tìm thấy, trả về 200 OK với department
                .orElse(ResponseEntity.notFound().build()); // Nếu không tìm thấy, trả về 404 Not Found
    }

    // POST: Tạo một department mới
    @PostMapping
    public ResponseEntity<?> createDepartment(@Valid @RequestBody Department department) {
        // Kiểm tra xem client có gửi departmentId không, nếu có thì không hợp lệ cho việc tạo mới.
        if (department.getDepartmentId() != null) {
            return ResponseEntity.badRequest().body("Department ID must be null for creation.");
        }
        try {
            Department createdDepartment = departmentService.createDepartment(department);
            return new ResponseEntity<>(createdDepartment, HttpStatus.CREATED); // Trả về 201 Created
        } catch (Exception e) {
            // Xử lý các lỗi tiềm ẩn, ví dụ: department_name đã tồn tại (do constraint unique)
            // Bạn có thể muốn có một GlobalExceptionHandler để xử lý các lỗi này một cách nhất quán.
            return ResponseEntity.status(HttpStatus.CONFLICT).body("Error creating department: " + e.getMessage());
        }
    }

    // PUT: Cập nhật một department đã tồn tại
    @PutMapping("/{id}")
    public ResponseEntity<Department> updateDepartment(@PathVariable UUID id, @Valid @RequestBody Department departmentDetails) {
        return departmentService.updateDepartment(id, departmentDetails)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    // DELETE: Xóa một department
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteDepartment(@PathVariable UUID id) {
        if (departmentService.deleteDepartment(id)) {
            return ResponseEntity.noContent().build(); // Trả về 204 No Content
        } else {
            return ResponseEntity.notFound().build();
        }
    }

    // GET: Lấy tất cả departments theo trang
    @GetMapping("/paged")
    public ResponseEntity<Page<Department>> getAllDepartmentsPaged(
            @RequestParam(name = "page", defaultValue = "0") int page,
            @RequestParam(name = "size", defaultValue = "10") int size) {
        Pageable pageable = PageRequest.of(page, size);
        Page<Department> departmentPage = departmentService.getAllDepartments(pageable);
        return ResponseEntity.ok(departmentPage);
    }

    // GET: Tìm kiếm departments theo keyword, có thể phân trang hoặc trả về tất cả
    @GetMapping("/search")
    public ResponseEntity<?> searchDepartments(
            @RequestParam(name = "keyword", defaultValue = "") String keyword, // Mặc định keyword là chuỗi rỗng nếu không được cung cấp
            @RequestParam(name = "page", required = false) Integer page,
            @RequestParam(name = "size", required = false) Integer size) {

        if (page != null && size != null) {
            // Yêu cầu tìm kiếm có phân trang
            Pageable pageable = PageRequest.of(page, size);
            Page<Department> departmentPage = departmentService.searchDepartments(keyword, pageable);
            return ResponseEntity.ok(departmentPage);
        } else {
            // Yêu cầu tìm kiếm và trả về tất cả kết quả (không phân trang)
            List<Department> departments = departmentService.searchDepartments(keyword);
            return ResponseEntity.ok(departments);
        }
    }

    // POST: Tìm kiếm departments nâng cao theo name và description, có thể phân trang hoặc trả về tất cả
    @PostMapping("/search-advanced")
    public ResponseEntity<?> searchDepartmentsAdvanced(
            @RequestBody DepartmentSearchCriteria criteria, // Nhận tiêu chí tìm kiếm từ request body
            @RequestParam(name = "page", required = false) Integer page,
            @RequestParam(name = "size", required = false) Integer size) {

        if (page != null && size != null) {
            // Yêu cầu tìm kiếm có phân trang
            Pageable pageable = PageRequest.of(page, size);
            Page<Department> departmentPage = departmentService.searchDepartmentsByCriteria(criteria, pageable);
            return ResponseEntity.ok(departmentPage);
        } else {
            // Yêu cầu tìm kiếm và trả về tất cả kết quả (không phân trang)
            List<Department> departments = departmentService.searchDepartmentsByCriteria(criteria);
            return ResponseEntity.ok(departments);
        }
    }
}
