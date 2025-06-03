package com.example.demo.service.impl;

import com.example.demo.dto.DepartmentSearchCriteria;
import com.example.demo.model.Department;
import com.example.demo.repository.DepartmentRepository;
import com.example.demo.service.DepartmentService;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.FillPatternType;
import org.apache.poi.ss.usermodel.Font;
import org.apache.poi.ss.usermodel.HorizontalAlignment;
import org.apache.poi.ss.usermodel.IndexedColors;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;


import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.Optional;
import java.util.UUID;
import org.apache.poi.ss.util.CellRangeAddress;

@Service
public class DepartmentServiceImpl implements DepartmentService {

    private final DepartmentRepository departmentRepository;

    @Autowired
    public DepartmentServiceImpl(DepartmentRepository departmentRepository) {
        this.departmentRepository = departmentRepository;
    }

    @Override
    public List<Department> getAllDepartments() {
        return departmentRepository.findAll();
    }

    @Override
    public Optional<Department> getDepartmentById(UUID id) {
        return departmentRepository.findById(id);
    }

    @Override
    @Transactional
    public Department createDepartment(Department department) {
        // Logic kiểm tra departmentId cho việc tạo mới đã được xử lý ở Controller
        return departmentRepository.save(department);
    }

    @Override
    @Transactional
    public Optional<Department> updateDepartment(UUID id, Department departmentDetails) {
        return departmentRepository.findById(id)
                .map(existingDepartment -> {
                    // Cập nhật các trường từ departmentDetails vào existingDepartment
                    existingDepartment.setDepartmentName(departmentDetails.getDepartmentName());
                    existingDepartment.setDescription(departmentDetails.getDescription());
                    existingDepartment.setLocation(departmentDetails.getLocation());
                    return departmentRepository.save(existingDepartment);
                });
    }

    @Override
    @Transactional
    public boolean deleteDepartment(UUID id) {
        if (departmentRepository.existsById(id)) {
            departmentRepository.deleteById(id);
            return true;
        }
        return false;
    }

    @Override
    public Page<Department> getAllDepartments(Pageable pageable) {
        // Sử dụng phương thức findAll(Pageable) từ JpaRepository
        return departmentRepository.findAll(pageable);
    }

    @Override
    public Page<Department> searchDepartments(String keyword, Pageable pageable) {
        if (keyword == null || keyword.trim().isEmpty()) {
            return departmentRepository.findAll(pageable);
        }
        return departmentRepository.findByDepartmentNameContainingIgnoreCase(keyword, pageable);
    }

    @Override
    public List<Department> searchDepartments(String keyword) {
        if (keyword == null || keyword.trim().isEmpty()) {
            return departmentRepository.findAll();
        }
        return departmentRepository.findByDepartmentNameContainingIgnoreCase(keyword);
    }

    @Override
    public Page<Department> searchDepartmentsByCriteria(DepartmentSearchCriteria criteria, Pageable pageable) {
        String name = criteria.getDepartmentName();
        String desc = criteria.getDescription();

        boolean hasName = StringUtils.hasText(name);
        boolean hasDesc = StringUtils.hasText(desc);

        if (hasName && hasDesc) {
            return departmentRepository.findByDepartmentNameContainingIgnoreCaseAndDescriptionContainingIgnoreCase(name, desc, pageable);
        } else if (hasName) {
            return departmentRepository.findByDepartmentNameContainingIgnoreCase(name, pageable);
        } else if (hasDesc) {
            return departmentRepository.findByDescriptionContainingIgnoreCase(desc, pageable);
        } else {
            return departmentRepository.findAll(pageable);
        }
    }

    @Override
    public List<Department> searchDepartmentsByCriteria(DepartmentSearchCriteria criteria) {
        String name = criteria.getDepartmentName();
        String desc = criteria.getDescription();

        boolean hasName = StringUtils.hasText(name);
        boolean hasDesc = StringUtils.hasText(desc);

        if (hasName && hasDesc) {
            return departmentRepository.findByDepartmentNameContainingIgnoreCaseAndDescriptionContainingIgnoreCase(name, desc);
        } else if (hasName) {
            return departmentRepository.findByDepartmentNameContainingIgnoreCase(name);
        } else if (hasDesc) {
            return departmentRepository.findByDescriptionContainingIgnoreCase(desc);
        } else {
            return departmentRepository.findAll();
        }
    }

@Override
    public XSSFWorkbook generateDepartmentsExcel() {
        final String SHEET_NAME = "Departments";
        final String TITLE = "DANH SÁCH PHÒNG BAN";
        final String[] HEADERS = {"ID Phòng Ban", "Tên Phòng Ban", "Mô Tả", "Vị Trí"};

        List<Department> departments = getAllDepartments(); // Lấy tất cả departments

        XSSFWorkbook workbook = new XSSFWorkbook();
        XSSFSheet sheet = workbook.createSheet(SHEET_NAME);

        // --- Tạo Style cho Tiêu đề chính ---
        CellStyle titleCellStyle = workbook.createCellStyle();
        Font titleFont = workbook.createFont();
        titleFont.setBold(true);
        titleFont.setFontHeightInPoints((short) 16);
        titleCellStyle.setFont(titleFont);
        titleCellStyle.setAlignment(HorizontalAlignment.CENTER);

        // --- Tạo dòng Tiêu đề chính ---
        Row titleRow = sheet.createRow(0);
        Cell titleCell = titleRow.createCell(0);
        titleCell.setCellValue(TITLE);
        titleCell.setCellStyle(titleCellStyle);
        sheet.addMergedRegion(new CellRangeAddress(0, 0, 0, HEADERS.length - 1)); // Gộp ô cho tiêu đề

        // --- Tạo Font và CellStyle cho Header của bảng ---
        Font headerFont = workbook.createFont();
        headerFont.setBold(true);
        headerFont.setColor(IndexedColors.WHITE.getIndex()); // Màu chữ trắng

        CellStyle headerCellStyle = workbook.createCellStyle();
        headerCellStyle.setFont(headerFont);
        headerCellStyle.setFillForegroundColor(IndexedColors.DARK_BLUE.getIndex()); // Màu nền xanh đậm
        headerCellStyle.setFillPattern(FillPatternType.SOLID_FOREGROUND);
        headerCellStyle.setAlignment(HorizontalAlignment.CENTER); // Căn giữa

        // --- Tạo dòng Header của bảng (sau dòng tiêu đề chính và một dòng trống) ---
        Row headerRow = sheet.createRow(2); // Bắt đầu từ hàng thứ 3 (index 2)
        for (int i = 0; i < HEADERS.length; i++) {
            Cell cell = headerRow.createCell(i);
            cell.setCellValue(HEADERS[i]);
            cell.setCellStyle(headerCellStyle);
        }

        // --- Tạo các dòng dữ liệu ---
        int dataRowIdx = 3; // Dữ liệu bắt đầu từ hàng thứ 4 (index 3)
        if (departments != null) {
            for (Department department : departments) {
                Row row = sheet.createRow(dataRowIdx++);
                row.createCell(0).setCellValue(department.getDepartmentId() != null ? department.getDepartmentId().toString() : "N/A");
                row.createCell(1).setCellValue(department.getDepartmentName() != null ? department.getDepartmentName() : "");
                row.createCell(2).setCellValue(department.getDescription() != null ? department.getDescription() : "");
                row.createCell(3).setCellValue(department.getLocation() != null ? department.getLocation() : "");
            }
        }

        // --- Tạo dòng Chân trang (Footer) ---
        int footerRowIdx = dataRowIdx + 1; // Cách một dòng sau dữ liệu
        Row footerRow = sheet.createRow(footerRowIdx);
        Cell footerCell = footerRow.createCell(0);

        CellStyle footerCellStyle = workbook.createCellStyle();
        Font footerFont = workbook.createFont();
        footerFont.setItalic(true);
        footerFont.setFontHeightInPoints((short) 10);
        footerCellStyle.setFont(footerFont);
        footerCellStyle.setAlignment(HorizontalAlignment.RIGHT);

        LocalDateTime now = LocalDateTime.now();
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm:ss");
        footerCell.setCellValue("Báo cáo được tạo lúc: " + now.format(formatter));
        footerCell.setCellStyle(footerCellStyle);
        sheet.addMergedRegion(new CellRangeAddress(footerRowIdx, footerRowIdx, 0, HEADERS.length - 1)); // Gộp ô cho chân trang


        // --- Tự động điều chỉnh kích thước cột cho dễ đọc ---
        for(int i = 0; i < HEADERS.length; i++) {
            sheet.autoSizeColumn(i);
            // Có thể thêm một chút padding nếu muốn cột rộng hơn một chút so với autoSize
            sheet.setColumnWidth(i, sheet.getColumnWidth(i) + 512); // 512 units = khoảng 2 ký tự
        }

        return workbook;
    }    
}