package com.school.entity;

import javax.persistence.*;
import java.time.LocalDateTime;
import java.util.List;

@Entity
@Table(name = "buses")
public class Bus {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @Column(name = "bus_number", nullable = false)
    private String busNumber;
    
    @Column(name = "driver_name", nullable = false)
    private String driverName;
    
    @Column(name = "driver_phone")
    private String driverPhone;
    
    @Column(name = "route_name")
    private String routeName;
    
    @Column(name = "school_id", nullable = false)
    private String schoolId;
    
    @Column(name = "latitude")
    private Double latitude;
    
    @Column(name = "longitude")
    private Double longitude;
    
    @Column(name = "last_updated")
    private LocalDateTime lastUpdated;
    
    @Column(name = "is_active")
    private Boolean isActive;
    
    @Column(name = "current_status")
    private String currentStatus;
    
    @ElementCollection
    @CollectionTable(name = "bus_students", joinColumns = @JoinColumn(name = "bus_id"))
    @Column(name = "student_id")
    private List<String> studentIds;
    
    @PrePersist
    protected void onCreate() {
        lastUpdated = LocalDateTime.now();
        if (isActive == null) {
            isActive = true;
        }
        if (currentStatus == null) {
            currentStatus = "at_school";
        }
    }
    
    @PreUpdate
    protected void onUpdate() {
        lastUpdated = LocalDateTime.now();
    }
    
    // Constructors
    public Bus() {}
    
    public Bus(String busNumber, String driverName, String driverPhone, String routeName, 
                String schoolId, Double latitude, Double longitude, List<String> studentIds) {
        this.busNumber = busNumber;
        this.driverName = driverName;
        this.driverPhone = driverPhone;
        this.routeName = routeName;
        this.schoolId = schoolId;
        this.latitude = latitude;
        this.longitude = longitude;
        this.studentIds = studentIds;
        this.isActive = true;
        this.currentStatus = "at_school";
        this.lastUpdated = LocalDateTime.now();
    }
    
    // Getters and Setters
    public Long getId() {
        return id;
    }
    
    public void setId(Long id) {
        this.id = id;
    }
    
    public String getBusNumber() {
        return busNumber;
    }
    
    public void setBusNumber(String busNumber) {
        this.busNumber = busNumber;
    }
    
    public String getDriverName() {
        return driverName;
    }
    
    public void setDriverName(String driverName) {
        this.driverName = driverName;
    }
    
    public String getDriverPhone() {
        return driverPhone;
    }
    
    public void setDriverPhone(String driverPhone) {
        this.driverPhone = driverPhone;
    }
    
    public String getRouteName() {
        return routeName;
    }
    
    public void setRouteName(String routeName) {
        this.routeName = routeName;
    }
    
    public String getSchoolId() {
        return schoolId;
    }
    
    public void setSchoolId(String schoolId) {
        this.schoolId = schoolId;
    }
    
    public Double getLatitude() {
        return latitude;
    }
    
    public void setLatitude(Double latitude) {
        this.latitude = latitude;
    }
    
    public Double getLongitude() {
        return longitude;
    }
    
    public void setLongitude(Double longitude) {
        this.longitude = longitude;
    }
    
    public LocalDateTime getLastUpdated() {
        return lastUpdated;
    }
    
    public void setLastUpdated(LocalDateTime lastUpdated) {
        this.lastUpdated = lastUpdated;
    }
    
    public Boolean getIsActive() {
        return isActive;
    }
    
    public void setIsActive(Boolean isActive) {
        this.isActive = isActive;
    }
    
    public String getCurrentStatus() {
        return currentStatus;
    }
    
    public void setCurrentStatus(String currentStatus) {
        this.currentStatus = currentStatus;
    }
    
    public List<String> getStudentIds() {
        return studentIds;
    }
    
    public void setStudentIds(List<String> studentIds) {
        this.studentIds = studentIds;
    }
}
