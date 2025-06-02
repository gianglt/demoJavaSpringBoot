package com.example.demo.service;

import com.example.demo.dto.JobTitleSearchCriteria;
import com.example.demo.model.JobTitle;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

public interface JobTitleService {
    List<JobTitle> getAllJobTitles();
    Optional<JobTitle> getJobTitleById(UUID id);
    JobTitle createJobTitle(JobTitle jobTitle);
    Optional<JobTitle> updateJobTitle(UUID id, JobTitle jobTitleDetails);
    boolean deleteJobTitle(UUID id);
    Page<JobTitle> getAllJobTitles(Pageable pageable);

    Page<JobTitle> searchJobTitles(String keyword, Pageable pageable); // Tìm kiếm theo jobTitleName
    List<JobTitle> searchJobTitles(String keyword); // Tìm kiếm theo jobTitleName

    Page<JobTitle> searchJobTitlesByCriteria(JobTitleSearchCriteria criteria, Pageable pageable);
    List<JobTitle> searchJobTitlesByCriteria(JobTitleSearchCriteria criteria);
}