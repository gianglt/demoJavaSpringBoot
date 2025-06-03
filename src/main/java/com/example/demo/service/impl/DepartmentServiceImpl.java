package com.example.demo.service.impl;

import com.example.demo.dto.DepartmentSearchCriteria;
import com.example.demo.dto.ImportResult;
import com.example.demo.model.Department;
import com.example.demo.repository.DepartmentRepository;
import com.example.demo.service.DepartmentService;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.FillPatternType;
import org.apache.poi.ss.usermodel.Font;
import org.apache.poi.ss.usermodel.HorizontalAlignment;
import org.apache.poi.ss.usermodel.IndexedColors;
import org.apache.poi.ss.usermodel.DataFormatter;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;


import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;
import org.springframework.core.io.ClassPathResource;
import org.springframework.web.multipart.MultipartFile;

import java.io.InputStream;
import java.io.IOException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.Optional;
import java.util.UUID;
import org.apache.poi.ss.util.CellRangeAddress;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

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

    private static final String DEPARTMENTS_TEMPLATE_PATH = "templates/departments.xlsx";
    // Dữ liệu sẽ bắt đầu được ghi từ dòng thứ 4 trong file Excel (index là 3).
    // Dòng 1 (index 0): Tiêu đề chính của báo cáo.
    // Dòng 2 (index 1): Có thể là dòng trống hoặc thông tin phụ.
    // Dòng 3 (index 2): Tiêu đề các cột (ID Phòng Ban, Tên Phòng Ban, ...).
    private static final int DATA_START_ROW_INDEX_IN_TEMPLATE = 3;
    private static final int HEADER_ROW_INDEX_IN_TEMPLATE = 2; // Dòng chứa header cột là dòng 3 (index 2)

    // Constants for Excel import
    private static final int IMPORT_COL_INDEX_DEPARTMENT_NAME = 1; // "Tên Phòng Ban"
    private static final int IMPORT_COL_INDEX_DESCRIPTION = 2;     // "Mô Tả"
    private static final int IMPORT_COL_INDEX_LOCATION = 3;        // "Vị Trí"
    private static final int IMPORT_DATA_START_ROW_INDEX = 3;      // Data starts from the 4th row (index 3)

    private static final Logger logger = LoggerFactory.getLogger(DepartmentServiceImpl.class);

    @Override
    public XSSFWorkbook generateDepartmentsExcelFromTemplate() throws IOException {
        InputStream templateInputStream = null;
        try {
            // Tải file template từ thư mục resources/templates
            templateInputStream = new ClassPathResource(DEPARTMENTS_TEMPLATE_PATH).getInputStream();
            if (templateInputStream == null) {
                throw new IOException("Không thể tìm thấy file template: " + DEPARTMENTS_TEMPLATE_PATH);
            }
            XSSFWorkbook workbook = new XSSFWorkbook(templateInputStream);
            XSSFSheet sheet = workbook.getSheetAt(0); // Giả sử làm việc với sheet đầu tiên

            List<Department> departments = getAllDepartments();

            // Xác định số cột từ header trong template (dòng 3, index 2)
            Row headerDefinitionRow = sheet.getRow(HEADER_ROW_INDEX_IN_TEMPLATE);
            int numberOfColumns = 0;
            if (headerDefinitionRow != null) {
                numberOfColumns = headerDefinitionRow.getLastCellNum(); // getLastCellNum() trả về số cột + 1 (1-based)
            } else {
                logger.warn("Không tìm thấy dòng header (dòng {}) trong template. Sẽ sử dụng mặc định 4 cột cho footer.", HEADER_ROW_INDEX_IN_TEMPLATE + 1);
                numberOfColumns = 4; // Fallback nếu template không đúng chuẩn
            }
            if (numberOfColumns <= 0) { // Đảm bảo numberOfColumns luôn dương
                logger.warn("Số cột đọc từ template là {}. Sẽ sử dụng mặc định 4 cột cho footer.", numberOfColumns);
                numberOfColumns = 4;
            }

            int currentRowIdx = DATA_START_ROW_INDEX_IN_TEMPLATE;
            if (departments != null) {
                for (Department department : departments) {
                    Row row = sheet.createRow(currentRowIdx++); // Tạo dòng mới cho dữ liệu

                    row.createCell(0).setCellValue(department.getDepartmentId() != null ? department.getDepartmentId().toString() : "N/A");
                    row.createCell(1).setCellValue(department.getDepartmentName() != null ? department.getDepartmentName() : "");
                    row.createCell(2).setCellValue(department.getDescription() != null ? department.getDescription() : "");
                    row.createCell(3).setCellValue(department.getLocation() != null ? department.getLocation() : "");
                    // Nếu template của bạn có nhiều hơn 4 cột dữ liệu, bạn cần thêm các row.createCell(index).setCellValue(...) tương ứng.
                }
            }

            // --- Tạo dòng Chân trang (Footer) ---
            // Footer sẽ được đặt sau dòng dữ liệu cuối cùng, cách 1 dòng trống
            int footerRowIdx = (departments == null || departments.isEmpty()) ? DATA_START_ROW_INDEX_IN_TEMPLATE + 1 : currentRowIdx + 1;

            Row footerRow = sheet.createRow(footerRowIdx);
            Cell footerCell = footerRow.createCell(0); // Footer bắt đầu từ cột đầu tiên

            CellStyle footerCellStyle = workbook.createCellStyle(); // Nên tạo style mới hoặc lấy từ template nếu có
            Font footerFont = workbook.createFont();
            footerFont.setItalic(true);
            footerFont.setFontHeightInPoints((short) 10);
            footerCellStyle.setFont(footerFont);
            footerCellStyle.setAlignment(HorizontalAlignment.RIGHT);

            LocalDateTime now = LocalDateTime.now();
            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm:ss");
            footerCell.setCellValue("Báo cáo được tạo lúc: " + now.format(formatter));
            footerCell.setCellStyle(footerCellStyle);

            // Gộp ô cho footer dựa trên số cột đã xác định từ template
            sheet.addMergedRegion(new CellRangeAddress(footerRowIdx, footerRowIdx, 0, numberOfColumns - 1));

            return workbook;
        } finally {
            if (templateInputStream != null) {
                templateInputStream.close();
            }
        }
    }

    @Override
    @Transactional // Optional: consider if the entire import should be one transaction
    public ImportResult importDepartmentsFromExcel(MultipartFile file) throws IOException {
        ImportResult result = new ImportResult();
        InputStream inputStream = file.getInputStream();
        XSSFWorkbook workbook = new XSSFWorkbook(inputStream);
        XSSFSheet sheet = workbook.getSheetAt(0); // Assuming data is in the first sheet

        DataFormatter dataFormatter = new DataFormatter();

        int lastRowNum = sheet.getLastRowNum();
        for (int i = IMPORT_DATA_START_ROW_INDEX; i <= lastRowNum; i++) {
            Row row = sheet.getRow(i);
            if (row == null) { // Skip entirely empty rows
                continue;
            }

            try {
                String departmentName = getCellValueAsString(row, IMPORT_COL_INDEX_DEPARTMENT_NAME, dataFormatter);
                String description = getCellValueAsString(row, IMPORT_COL_INDEX_DESCRIPTION, dataFormatter);
                String location = getCellValueAsString(row, IMPORT_COL_INDEX_LOCATION, dataFormatter);

                // Basic validation: Department name is mandatory
                if (!StringUtils.hasText(departmentName)) {
                    result.incrementFailedRows();
                    result.addErrorMessage("Row " + (i + 1) + ": Department name is missing or empty.");
                    logger.warn("Skipping row {}: Department name is missing.", i + 1);
                    continue;
                }
                 // Location is also considered mandatory for the duplicate check logic
                if (!StringUtils.hasText(location)) {
                    result.incrementFailedRows();
                    result.addErrorMessage("Row " + (i + 1) + ": Location is missing or empty.");
                    logger.warn("Skipping row {}: Location is missing.", i + 1);
                    continue;
                }


                // Check for duplicates: same name AND same location (case-insensitive)
                if (departmentRepository.existsByDepartmentNameIgnoreCaseAndLocationIgnoreCase(departmentName, location)) {
                    result.incrementSkippedDuplicates();
                    logger.info("Skipping duplicate department: Name='{}', Location='{}' at row {}", departmentName, location, i + 1);
                } else {
                    Department department = new Department();
                    department.setDepartmentName(departmentName);
                    department.setDescription(description);
                    department.setLocation(location);
                    departmentRepository.save(department);
                    result.incrementSuccessfulImports();
                }
            } catch (Exception e) {
                result.incrementFailedRows();
                result.addErrorMessage("Row " + (i + 1) + ": Error processing row - " + e.getMessage());
                logger.error("Error processing row {} from Excel: {}", i + 1, e.getMessage(), e);
            }
        }

        workbook.close();
        inputStream.close();
        return result;
    }

    private String getCellValueAsString(Row row, int cellIndex, DataFormatter dataFormatter) {
        Cell cell = row.getCell(cellIndex);
        return dataFormatter.formatCellValue(cell).trim();
    }
}