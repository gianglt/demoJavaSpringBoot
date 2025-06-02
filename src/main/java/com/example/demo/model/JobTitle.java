package com.example.demo.model;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;

import java.time.OffsetDateTime;
import java.util.UUID;

@Entity
@Table(name = "jobtitles", uniqueConstraints = {
    @UniqueConstraint(columnNames = "job_title_name", name = "jobtitles_job_title_name_key")
})
@Data
@NoArgsConstructor
@AllArgsConstructor
public class JobTitle {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    @Column(name = "job_title_id", updatable = false, nullable = false)
    private UUID jobTitleId;

    @NotBlank(message = "Job title name cannot be blank")
    @Size(max = 100, message = "Job title name cannot exceed 100 characters")
    @Column(name = "job_title_name", length = 100, nullable = false)
    private String jobTitleName;

    @Column(name = "description", columnDefinition = "TEXT")
    private String description;

    @CreationTimestamp
    @Column(name = "created_at", nullable = false, updatable = false)
    private OffsetDateTime createdAt;

    @UpdateTimestamp
    @Column(name = "updated_at")
    private OffsetDateTime updatedAt;
}