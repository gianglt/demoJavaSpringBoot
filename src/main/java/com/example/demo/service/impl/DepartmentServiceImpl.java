package com.example.demo.service.impl;

import com.example.demo.dto.DepartmentSearchCriteria;
import com.example.demo.model.Department;
import com.example.demo.repository.DepartmentRepository;
import com.example.demo.service.DepartmentService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

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
                    existingDepartment.setDepartmentName(departmentDetails.getDepartmentName());
                    // Cập nhật các trường khác của Department nếu cần
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
}