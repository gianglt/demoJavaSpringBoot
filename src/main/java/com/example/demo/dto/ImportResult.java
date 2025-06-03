package com.example.demo.dto;

import java.util.ArrayList;
import java.util.List;

public class ImportResult {
    private int successfulImports;
    private int skippedDuplicates;
    private int failedRows;
    private List<String> errorMessages;

    public ImportResult() {
        this.errorMessages = new ArrayList<>();
    }

    public int getSuccessfulImports() {
        return successfulImports;
    }

    public void setSuccessfulImports(int successfulImports) {
        this.successfulImports = successfulImports;
    }

    public void incrementSuccessfulImports() {
        this.successfulImports++;
    }

    public int getSkippedDuplicates() {
        return skippedDuplicates;
    }

    public void setSkippedDuplicates(int skippedDuplicates) {
        this.skippedDuplicates = skippedDuplicates;
    }

    public void incrementSkippedDuplicates() {
        this.skippedDuplicates++;
    }

    public int getFailedRows() {
        return failedRows;
    }

    public void setFailedRows(int failedRows) {
        this.failedRows = failedRows;
    }

    public void incrementFailedRows() {
        this.failedRows++;
    }

    public List<String> getErrorMessages() {
        return errorMessages;
    }

    public void addErrorMessage(String message) {
        this.errorMessages.add(message);
    }

    @Override
    public String toString() {
        return "ImportResult{" +
                "successfulImports=" + successfulImports +
                ", skippedDuplicates=" + skippedDuplicates +
                ", failedRows=" + failedRows +
                ", errorMessages=" + errorMessages +
                '}';
    }
}