package com.example.demo.controller;

import com.example.demo.dto.JobTitleSearchCriteria;
import com.example.demo.model.JobTitle;
import com.example.demo.service.JobTitleService;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping("/api/v1/jobtitles")
public class JobTitleController {

    private final JobTitleService jobTitleService;

    @Autowired
    public JobTitleController(JobTitleService jobTitleService) {
        this.jobTitleService = jobTitleService;
    }

    @GetMapping
    public ResponseEntity<List<JobTitle>> getAllJobTitles() {
        List<JobTitle> jobTitles = jobTitleService.getAllJobTitles();
        return ResponseEntity.ok(jobTitles);
    }

    @GetMapping("/{id}")
    public ResponseEntity<JobTitle> getJobTitleById(@PathVariable UUID id) {
        return jobTitleService.getJobTitleById(id)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    @PostMapping
    public ResponseEntity<?> createJobTitle(@Valid @RequestBody JobTitle jobTitle) {
        if (jobTitle.getJobTitleId() != null) {
            return ResponseEntity.badRequest().body("JobTitle ID must be null for creation.");
        }
        try {
            JobTitle createdJobTitle = jobTitleService.createJobTitle(jobTitle);
            return new ResponseEntity<>(createdJobTitle, HttpStatus.CREATED);
        } catch (Exception e) {
            // Cân nhắc sử dụng @ControllerAdvice để xử lý exception tập trung
            return ResponseEntity.status(HttpStatus.CONFLICT).body("Error creating job title: " + e.getMessage());
        }
    }

    @PutMapping("/{id}")
    public ResponseEntity<JobTitle> updateJobTitle(@PathVariable UUID id, @Valid @RequestBody JobTitle jobTitleDetails) {
        return jobTitleService.updateJobTitle(id, jobTitleDetails)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteJobTitle(@PathVariable UUID id) {
        if (jobTitleService.deleteJobTitle(id)) {
            return ResponseEntity.noContent().build();
        } else {
            return ResponseEntity.notFound().build();
        }
    }

    @GetMapping("/paged")
    public ResponseEntity<Page<JobTitle>> getAllJobTitlesPaged(
            @RequestParam(name = "page", defaultValue = "0") int page,
            @RequestParam(name = "size", defaultValue = "10") int size) {
        Pageable pageable = PageRequest.of(page, size);
        Page<JobTitle> jobTitlePage = jobTitleService.getAllJobTitles(pageable);
        return ResponseEntity.ok(jobTitlePage);
    }

    @GetMapping("/search")
    public ResponseEntity<?> searchJobTitles(
            @RequestParam(name = "keyword", defaultValue = "") String keyword,
            @RequestParam(name = "page", required = false) Integer page,
            @RequestParam(name = "size", required = false) Integer size) {
        if (page != null && size != null) {
            Pageable pageable = PageRequest.of(page, size);
            Page<JobTitle> jobTitlePage = jobTitleService.searchJobTitles(keyword, pageable);
            return ResponseEntity.ok(jobTitlePage);
        } else {
            List<JobTitle> jobTitles = jobTitleService.searchJobTitles(keyword);
            return ResponseEntity.ok(jobTitles);
        }
    }

    @PostMapping("/search-advanced")
    public ResponseEntity<?> searchJobTitlesAdvanced(
            @RequestBody JobTitleSearchCriteria criteria,
            @RequestParam(name = "page", required = false) Integer page,
            @RequestParam(name = "size", required = false) Integer size) {
        if (page != null && size != null) {
            Pageable pageable = PageRequest.of(page, size);
            Page<JobTitle> jobTitlePage = jobTitleService.searchJobTitlesByCriteria(criteria, pageable);
            return ResponseEntity.ok(jobTitlePage);
        } else {
            List<JobTitle> jobTitles = jobTitleService.searchJobTitlesByCriteria(criteria);
            return ResponseEntity.ok(jobTitles);
        }
    }
}