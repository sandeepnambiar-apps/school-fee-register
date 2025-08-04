package com.school.studentservice.model;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "transport_routes")
public class TransportRoute {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @Column(name = "name", nullable = false)
    private String name;
    
    @Column(name = "code", unique = true, nullable = false)
    private String code;
    
    @Column(name = "pickup_location", nullable = false)
    private String pickupLocation;
    
    @Column(name = "drop_location", nullable = false)
    private String dropLocation;
    
    @Column(name = "distance_km")
    private Double distanceKm;
    
    @Column(name = "estimated_time_minutes")
    private Integer estimatedTimeMinutes;
    
    @Column(name = "vehicle_number")
    private String vehicleNumber;
    
    @Column(name = "driver_name")
    private String driverName;
    
    @Column(name = "driver_phone")
    private String driverPhone;
    
    @Column(name = "capacity")
    private Integer capacity;
    
    @Column(name = "current_occupancy")
    private Integer currentOccupancy;
    
    @Column(name = "monthly_fee")
    private Double monthlyFee;
    
    @Column(name = "is_active")
    private Boolean isActive = true;
    
    @Column(name = "created_at")
    private LocalDateTime createdAt;
    
    @Column(name = "updated_at")
    private LocalDateTime updatedAt;
    
    // Constructors
    public TransportRoute() {
        this.createdAt = LocalDateTime.now();
        this.updatedAt = LocalDateTime.now();
    }
    
    public TransportRoute(String name, String code, String pickupLocation, String dropLocation) {
        this();
        this.name = name;
        this.code = code;
        this.pickupLocation = pickupLocation;
        this.dropLocation = dropLocation;
    }
    
    // Getters and Setters
    public Long getId() {
        return id;
    }
    
    public void setId(Long id) {
        this.id = id;
    }
    
    public String getName() {
        return name;
    }
    
    public void setName(String name) {
        this.name = name;
    }
    
    public String getCode() {
        return code;
    }
    
    public void setCode(String code) {
        this.code = code;
    }
    
    public String getPickupLocation() {
        return pickupLocation;
    }
    
    public void setPickupLocation(String pickupLocation) {
        this.pickupLocation = pickupLocation;
    }
    
    public String getDropLocation() {
        return dropLocation;
    }
    
    public void setDropLocation(String dropLocation) {
        this.dropLocation = dropLocation;
    }
    
    public Double getDistanceKm() {
        return distanceKm;
    }
    
    public void setDistanceKm(Double distanceKm) {
        this.distanceKm = distanceKm;
    }
    
    public Integer getEstimatedTimeMinutes() {
        return estimatedTimeMinutes;
    }
    
    public void setEstimatedTimeMinutes(Integer estimatedTimeMinutes) {
        this.estimatedTimeMinutes = estimatedTimeMinutes;
    }
    
    public String getVehicleNumber() {
        return vehicleNumber;
    }
    
    public void setVehicleNumber(String vehicleNumber) {
        this.vehicleNumber = vehicleNumber;
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
    
    public Integer getCapacity() {
        return capacity;
    }
    
    public void setCapacity(Integer capacity) {
        this.capacity = capacity;
    }
    
    public Integer getCurrentOccupancy() {
        return currentOccupancy;
    }
    
    public void setCurrentOccupancy(Integer currentOccupancy) {
        this.currentOccupancy = currentOccupancy;
    }
    
    public Double getMonthlyFee() {
        return monthlyFee;
    }
    
    public void setMonthlyFee(Double monthlyFee) {
        this.monthlyFee = monthlyFee;
    }
    
    public Boolean getIsActive() {
        return isActive;
    }
    
    public void setIsActive(Boolean isActive) {
        this.isActive = isActive;
    }
    
    public LocalDateTime getCreatedAt() {
        return createdAt;
    }
    
    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }
    
    public LocalDateTime getUpdatedAt() {
        return updatedAt;
    }
    
    public void setUpdatedAt(LocalDateTime updatedAt) {
        this.updatedAt = updatedAt;
    }
    
    @PreUpdate
    public void preUpdate() {
        this.updatedAt = LocalDateTime.now();
    }
    
    // Helper methods
    public boolean hasAvailableSeats() {
        return currentOccupancy < capacity;
    }
    
    public int getAvailableSeats() {
        return capacity - currentOccupancy;
    }
    
    public double getOccupancyPercentage() {
        if (capacity == null || capacity == 0) return 0.0;
        return (double) currentOccupancy / capacity * 100;
    }
} 