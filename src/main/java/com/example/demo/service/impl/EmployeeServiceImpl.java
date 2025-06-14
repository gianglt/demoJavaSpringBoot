package com.example.demo.service.impl;

import com.example.demo.dto.EmployeeSearchCriteria;
import com.example.demo.model.Department;
import com.example.demo.model.Employee;
import com.example.demo.repository.DepartmentRepository;
import com.example.demo.repository.EmployeeRepository;
import com.example.demo.service.EmployeeService;
import jakarta.persistence.criteria.Predicate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

@Service
public class EmployeeServiceImpl implements EmployeeService {

    private final EmployeeRepository employeeRepository;
    private final DepartmentRepository departmentRepository; // Cần thiết nếu tìm theo departmentId

    @Autowired
    public EmployeeServiceImpl(EmployeeRepository employeeRepository, DepartmentRepository departmentRepository) {
        this.employeeRepository = employeeRepository;
        this.departmentRepository = departmentRepository;
    }

    @Override
    public List<Employee> getAllEmployees() {
        return employeeRepository.findAll();
    }

    @Override
    public Optional<Employee> getEmployeeById(UUID id) {
        return employeeRepository.findById(id);
    }

    @Override
    @Transactional
    public Employee createEmployee(Employee employee) {
        // Logic kiểm tra employeeId cho việc tạo mới đã được xử lý ở Controller
        // Có thể thêm logic kiểm tra email/username đã tồn tại nếu cần thiết ở đây,
        // mặc dù DB constraint sẽ bắt lỗi.
        return employeeRepository.save(employee);
    }

    @Override
    @Transactional
    public Optional<Employee> updateEmployee(UUID id, Employee employeeDetails) {
        return employeeRepository.findById(id)
                .map(existingEmployee -> {
                    existingEmployee.setFirstName(employeeDetails.getFirstName());
                    existingEmployee.setLastName(employeeDetails.getLastName());
                    existingEmployee.setEmail(employeeDetails.getEmail());
                    existingEmployee.setPhoneNumber(employeeDetails.getPhoneNumber());
                    existingEmployee.setHireDate(employeeDetails.getHireDate());
                    existingEmployee.setJobTitleString(employeeDetails.getJobTitleString());
                    existingEmployee.setJobTitleEntity(employeeDetails.getJobTitleEntity());
                    existingEmployee.setDepartment(employeeDetails.getDepartment());
                    existingEmployee.setManager(employeeDetails.getManager());
                    existingEmployee.setSalary(employeeDetails.getSalary());
                    existingEmployee.setUsername(employeeDetails.getUsername());
                    existingEmployee.setActive(employeeDetails.isActive());
                    existingEmployee.setAppUserId(employeeDetails.getAppUserId());
                    // createdAt và updatedAt được quản lý tự động
                    return employeeRepository.save(existingEmployee);
                });
    }

    @Override
    @Transactional
    public boolean deleteEmployee(UUID id) {
        if (employeeRepository.existsById(id)) {
            employeeRepository.deleteById(id);
            return true;
        }
        return false;
    }

    @Override
    public Page<Employee> getAllEmployees(Pageable pageable) {
        return employeeRepository.findAll(pageable);
    }

    @Override
    public Page<Employee> searchEmployees(String keyword, Pageable pageable) {
        if (!StringUtils.hasText(keyword)) {
            return employeeRepository.findAll(pageable);
        }
        // Tìm kiếm đơn giản trên một vài trường chính, ví dụ: firstName, lastName, email
        Specification<Employee> spec = (root, query, cb) ->
                cb.or(
                        cb.like(cb.lower(root.get("firstName")), "%" + keyword.toLowerCase() + "%"),
                        cb.like(cb.lower(root.get("lastName")), "%" + keyword.toLowerCase() + "%"),
                        cb.like(cb.lower(root.get("email")), "%" + keyword.toLowerCase() + "%"),
                        cb.like(cb.lower(root.get("jobTitleString")), "%" + keyword.toLowerCase() + "%")
                );
        return employeeRepository.findAll(spec, pageable);
    }

    @Override
    public List<Employee> searchEmployees(String keyword) {
        if (!StringUtils.hasText(keyword)) {
            return employeeRepository.findAll();
        }
        Specification<Employee> spec = (root, query, cb) ->
                cb.or(
                        cb.like(cb.lower(root.get("firstName")), "%" + keyword.toLowerCase() + "%"),
                        cb.like(cb.lower(root.get("lastName")), "%" + keyword.toLowerCase() + "%"),
                        cb.like(cb.lower(root.get("email")), "%" + keyword.toLowerCase() + "%"),
                        cb.like(cb.lower(root.get("jobTitleString")), "%" + keyword.toLowerCase() + "%")
                );
        return employeeRepository.findAll(spec);
    }

    @Override
    public Page<Employee> searchEmployeesByCriteria(EmployeeSearchCriteria criteria, Pageable pageable) {
        return employeeRepository.findAll(buildSpecification(criteria), pageable);
    }

    @Override
    public List<Employee> searchEmployeesByCriteria(EmployeeSearchCriteria criteria) {
        return employeeRepository.findAll(buildSpecification(criteria));
    }

    private Specification<Employee> buildSpecification(EmployeeSearchCriteria criteria) {
        // Implementation for building Specification based on criteria
        // This can be complex depending on how many fields and how they interact
        // For a simpler version, you might need to add more specific methods to the repository
        // or use a query builder like QueryDSL.
        // Placeholder:
        return (root, query, cb) -> {
            List<Predicate> predicates = new ArrayList<>();
            if (StringUtils.hasText(criteria.getFirstName())) {
                predicates.add(cb.like(cb.lower(root.get("firstName")), "%" + criteria.getFirstName().toLowerCase() + "%"));
            }
            if (StringUtils.hasText(criteria.getLastName())) {
                predicates.add(cb.like(cb.lower(root.get("lastName")), "%" + criteria.getLastName().toLowerCase() + "%"));
            }
            if (StringUtils.hasText(criteria.getEmail())) {
                predicates.add(cb.like(cb.lower(root.get("email")), "%" + criteria.getEmail().toLowerCase() + "%"));
            }
            if (StringUtils.hasText(criteria.getJobTitleString())) {
                predicates.add(cb.like(cb.lower(root.get("jobTitleString")), "%" + criteria.getJobTitleString().toLowerCase() + "%"));
            }
            if (criteria.getDepartmentId() != null) {
                Optional<Department> department = departmentRepository.findById(criteria.getDepartmentId());
                department.ifPresent(dep -> predicates.add(cb.equal(root.get("department"), dep)));
            }
            if (StringUtils.hasText(criteria.getUsername())) {
                predicates.add(cb.equal(cb.lower(root.get("username")), criteria.getUsername().toLowerCase()));
            }
            if (criteria.getActive() != null) {
                predicates.add(cb.equal(root.get("active"), criteria.getActive()));
            }
            return cb.and(predicates.toArray(new Predicate[0]));
        };
    }
}