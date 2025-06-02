package com.example.demo.repository;

import com.example.demo.model.JobTitle;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.UUID;

@Repository
public interface JobTitleRepository extends JpaRepository<JobTitle, UUID> {

    Page<JobTitle> findByJobTitleNameContainingIgnoreCase(String jobTitleName, Pageable pageable);
    List<JobTitle> findByJobTitleNameContainingIgnoreCase(String jobTitleName);

    Page<JobTitle> findByDescriptionContainingIgnoreCase(String description, Pageable pageable);
    List<JobTitle> findByDescriptionContainingIgnoreCase(String description);

    Page<JobTitle> findByJobTitleNameContainingIgnoreCaseAndDescriptionContainingIgnoreCase(String jobTitleName, String description, Pageable pageable);
    List<JobTitle> findByJobTitleNameContainingIgnoreCaseAndDescriptionContainingIgnoreCase(String jobTitleName, String description);
}