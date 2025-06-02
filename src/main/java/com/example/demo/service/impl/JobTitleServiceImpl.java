package com.example.demo.service.impl;

import com.example.demo.dto.JobTitleSearchCriteria;
import com.example.demo.model.JobTitle;
import com.example.demo.repository.JobTitleRepository;
import com.example.demo.service.JobTitleService;
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
public class JobTitleServiceImpl implements JobTitleService {

    private final JobTitleRepository jobTitleRepository;

    @Autowired
    public JobTitleServiceImpl(JobTitleRepository jobTitleRepository) {
        this.jobTitleRepository = jobTitleRepository;
    }

    @Override
    public List<JobTitle> getAllJobTitles() {
        return jobTitleRepository.findAll();
    }

    @Override
    public Optional<JobTitle> getJobTitleById(UUID id) {
        return jobTitleRepository.findById(id);
    }

    @Override
    @Transactional
    public JobTitle createJobTitle(JobTitle jobTitle) {
        // jobTitle.setJobTitleId(null); // Đảm bảo ID là null để tạo mới, hoặc để DB tự sinh
        return jobTitleRepository.save(jobTitle);
    }

    @Override
    @Transactional
    public Optional<JobTitle> updateJobTitle(UUID id, JobTitle jobTitleDetails) {
        return jobTitleRepository.findById(id)
                .map(existingJobTitle -> {
                    existingJobTitle.setJobTitleName(jobTitleDetails.getJobTitleName());
                    existingJobTitle.setDescription(jobTitleDetails.getDescription());
                    // createdAt và updatedAt sẽ được quản lý tự động bởi @CreationTimestamp và @UpdateTimestamp
                    return jobTitleRepository.save(existingJobTitle);
                });
    }

    @Override
    @Transactional
    public boolean deleteJobTitle(UUID id) {
        if (jobTitleRepository.existsById(id)) {
            jobTitleRepository.deleteById(id);
            return true;
        }
        return false;
    }

    @Override
    public Page<JobTitle> getAllJobTitles(Pageable pageable) {
        return jobTitleRepository.findAll(pageable);
    }

    @Override
    public Page<JobTitle> searchJobTitles(String keyword, Pageable pageable) {
        if (!StringUtils.hasText(keyword)) {
            return jobTitleRepository.findAll(pageable);
        }
        return jobTitleRepository.findByJobTitleNameContainingIgnoreCase(keyword, pageable);
    }

    @Override
    public List<JobTitle> searchJobTitles(String keyword) {
        if (!StringUtils.hasText(keyword)) {
            return jobTitleRepository.findAll();
        }
        return jobTitleRepository.findByJobTitleNameContainingIgnoreCase(keyword);
    }

    @Override
    public Page<JobTitle> searchJobTitlesByCriteria(JobTitleSearchCriteria criteria, Pageable pageable) {
        String name = criteria.getJobTitleName();
        String desc = criteria.getDescription();
        boolean hasName = StringUtils.hasText(name);
        boolean hasDesc = StringUtils.hasText(desc);

        if (hasName && hasDesc) {
            return jobTitleRepository.findByJobTitleNameContainingIgnoreCaseAndDescriptionContainingIgnoreCase(name, desc, pageable);
        } else if (hasName) {
            return jobTitleRepository.findByJobTitleNameContainingIgnoreCase(name, pageable);
        } else if (hasDesc) {
            return jobTitleRepository.findByDescriptionContainingIgnoreCase(desc, pageable);
        } else {
            return jobTitleRepository.findAll(pageable);
        }
    }

    @Override
    public List<JobTitle> searchJobTitlesByCriteria(JobTitleSearchCriteria criteria) {
        String name = criteria.getJobTitleName();
        String desc = criteria.getDescription();
        boolean hasName = StringUtils.hasText(name);
        boolean hasDesc = StringUtils.hasText(desc);

        if (hasName && hasDesc) {
            return jobTitleRepository.findByJobTitleNameContainingIgnoreCaseAndDescriptionContainingIgnoreCase(name, desc);
        } else if (hasName) {
            return jobTitleRepository.findByJobTitleNameContainingIgnoreCase(name);
        } else if (hasDesc) {
            return jobTitleRepository.findByDescriptionContainingIgnoreCase(desc);
        } else {
            return jobTitleRepository.findAll();
        }
    }
}