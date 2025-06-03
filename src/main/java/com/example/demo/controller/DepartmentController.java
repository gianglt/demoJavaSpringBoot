package com.example.demo.controller;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import com.example.demo.dto.ImportResult;
import com.example.demo.dto.DepartmentSearchCriteria;
import com.example.demo.model.Department;
import com.example.demo.service.DepartmentService;
import jakarta.validation.Valid; 
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;
import java.util.UUID;
import java.io.IOException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

@RestController
@RequestMapping("/api/v1/departments") // Đường dẫn cơ sở cho các endpoint của department
public class DepartmentController {

    private final DepartmentService departmentService;

    private static final Logger logger = LoggerFactory.getLogger(DepartmentController.class);

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
        } catch (DataIntegrityViolationException e) { // Bắt lỗi cụ thể hơn nếu có thể
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

    // GET: Xuất danh sách departments ra file Excel
    @GetMapping("/export/excel")
    public void exportDepartmentsToExcel(HttpServletResponse response) {
        try {
            // Đặt content type và header cho việc tải file Excel
            // Sử dụng timestamp trong tên file để tránh vấn đề caching và đảm bảo tính duy nhất
            String filename = "departments_" + System.currentTimeMillis() + ".xlsx";
            response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
            response.setHeader("Content-Disposition", "attachment; filename=\"" + filename + "\"");

            XSSFWorkbook workbook = departmentService.generateDepartmentsExcel();

            workbook.write(response.getOutputStream());
            workbook.close(); // Quan trọng: đóng workbook để giải phóng tài nguyên

            response.getOutputStream().flush(); // Đảm bảo tất cả dữ liệu được gửi đi
        } catch (IOException ex) {
            // Ghi log lỗi. Trong môi trường production, sử dụng một framework logging phù hợp.
            logger.error("Lỗi xảy ra khi xuất departments ra Excel: {}", ex.getMessage(), ex);
            // Rất khó để gửi một phản hồi lỗi rõ ràng cho client ở giai đoạn này
            // nếu header đã được gửi và stream đang được sử dụng.
            // Client có thể nhận được file bị lỗi hoặc tải xuống không hoàn chỉnh.
        } catch (Exception ex) { // Bắt các lỗi không mong muốn khác
            logger.error("Lỗi không xác định khi xuất Excel: {}", ex.getMessage(), ex);
        }
    }

    // GET: Xuất danh sách departments ra file Excel từ template
    @GetMapping("/export/excel-from-template")
    public void exportDepartmentsToExcelFromTemplate(HttpServletResponse response) {
        try {
            String filename = "departments_report_" + System.currentTimeMillis() + ".xlsx";
            response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
            response.setHeader("Content-Disposition", "attachment; filename=\"" + filename + "\"");

            XSSFWorkbook workbook = departmentService.generateDepartmentsExcelFromTemplate();

            workbook.write(response.getOutputStream());
            workbook.close();

            response.getOutputStream().flush();
        } catch (IOException ex) {
            logger.error("Lỗi IO khi xuất departments từ template: {}", ex.getMessage(), ex);
            // Cân nhắc việc thiết lập HTTP status code lỗi nếu có thể và header chưa được gửi.
            // if (!response.isCommitted()) {
            //     response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            // }
        } catch (Exception ex) { // Bắt các lỗi khác có thể xảy ra
            logger.error("Lỗi không xác định khi xuất Excel từ template: {}", ex.getMessage(), ex);
        }
    }

    // POST: Import departments from Excel file
    @PostMapping("/import/excel")
    public ResponseEntity<?> importDepartmentsFromExcel(@RequestParam("file") MultipartFile file) {
        if (file.isEmpty()) {
            return ResponseEntity.badRequest().body("Please upload an Excel file.");
        }
        // Optional: Add more specific file type validation (e.g., for .xlsx)
        // String contentType = file.getContentType();
        // if (contentType == null || !contentType.equals("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet")) {
        //     return ResponseEntity.badRequest().body("Invalid file type. Only .xlsx files are allowed.");
        // }

        try {
            ImportResult result = departmentService.importDepartmentsFromExcel(file);
            return ResponseEntity.ok(result);
        } catch (IOException e) {
            logger.error("Lỗi IO khi import departments từ Excel: {}", e.getMessage(), e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("Failed to process Excel file: " + e.getMessage());
        } catch (Exception e) { // Catch other potential errors during import
            logger.error("Lỗi không xác định khi import departments từ Excel: {}", e.getMessage(), e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("An unexpected error occurred during import: " + e.getMessage());
        }
    }
}
