package com.example.demo.service;

import com.example.demo.dto.DepartmentSearchCriteria;
import com.example.demo.model.Department;
import org.springframework.data.domain.Page;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.data.domain.Pageable;

import java.io.IOException;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

public interface DepartmentService {
    List<Department> getAllDepartments(); // Lấy tất cả department
    Optional<Department> getDepartmentById(UUID id); // Lấy department theo ID
    Department createDepartment(Department department); // Tạo department mới
    Optional<Department> updateDepartment(UUID id, Department departmentDetails); // Cập nhật department
    boolean deleteDepartment(UUID id); // Xóa department
    Page<Department> getAllDepartments(Pageable pageable); // Lấy department theo trang

    Page<Department> searchDepartments(String keyword, Pageable pageable); // Tìm kiếm department theo keyword, có phân trang
    List<Department> searchDepartments(String keyword); // Tìm kiếm department theo keyword, trả về tất cả

    Page<Department> searchDepartmentsByCriteria(DepartmentSearchCriteria criteria, Pageable pageable); // Tìm kiếm theo tiêu chí, có phân trang
    List<Department> searchDepartmentsByCriteria(DepartmentSearchCriteria criteria); // Tìm kiếm theo tiêu chí, trả về tất cả

    /**
     * Tạo một XSSFWorkbook chứa dữ liệu các department.
     * @return XSSFWorkbook chứa dữ liệu.
     */
    XSSFWorkbook generateDepartmentsExcel();

    XSSFWorkbook generateDepartmentsExcelFromTemplate() throws IOException; // Phương thức mới
}
