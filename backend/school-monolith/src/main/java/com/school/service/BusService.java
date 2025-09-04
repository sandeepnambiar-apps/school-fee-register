package com.school.service;

import com.school.entity.Bus;
import com.school.repository.BusRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Service
public class BusService {
    
    @Autowired
    private BusRepository busRepository;
    
    // Get all buses
    public List<Bus> getAllBuses() {
        return busRepository.findAll();
    }
    
    // Get buses by school ID
    public List<Bus> getBusesBySchool(String schoolId) {
        return busRepository.findBySchoolId(schoolId);
    }
    
    // Get buses by student ID
    public List<Bus> getBusesByStudent(String studentId) {
        return busRepository.findBusesByStudentId(studentId);
    }
    
    // Get bus by ID
    public Bus getBusById(String id) {
        try {
            Long busId = Long.parseLong(id);
            Optional<Bus> bus = busRepository.findById(busId);
            return bus.orElse(null);
        } catch (NumberFormatException e) {
            return null;
        }
    }
    
    // Create new bus
    public Bus createBus(Bus bus) {
        // Set default values
        if (bus.getIsActive() == null) {
            bus.setIsActive(true);
        }
        if (bus.getCurrentStatus() == null) {
            bus.setCurrentStatus("at_school");
        }
        if (bus.getLastUpdated() == null) {
            bus.setLastUpdated(LocalDateTime.now());
        }
        
        return busRepository.save(bus);
    }
    
    // Update bus
    public Bus updateBus(String id, Bus busDetails) {
        try {
            Long busId = Long.parseLong(id);
            Optional<Bus> busOptional = busRepository.findById(busId);
            
            if (busOptional.isPresent()) {
                Bus bus = busOptional.get();
                
                // Update fields
                if (busDetails.getBusNumber() != null) {
                    bus.setBusNumber(busDetails.getBusNumber());
                }
                if (busDetails.getDriverName() != null) {
                    bus.setDriverName(busDetails.getDriverName());
                }
                if (busDetails.getDriverPhone() != null) {
                    bus.setDriverPhone(busDetails.getDriverPhone());
                }
                if (busDetails.getRouteName() != null) {
                    bus.setRouteName(busDetails.getRouteName());
                }
                if (busDetails.getStudentIds() != null) {
                    bus.setStudentIds(busDetails.getStudentIds());
                }
                if (busDetails.getIsActive() != null) {
                    bus.setIsActive(busDetails.getIsActive());
                }
                if (busDetails.getCurrentStatus() != null) {
                    bus.setCurrentStatus(busDetails.getCurrentStatus());
                }
                
                bus.setLastUpdated(LocalDateTime.now());
                return busRepository.save(bus);
            }
        } catch (NumberFormatException e) {
            return null;
        }
        return null;
    }
    
    // Update bus location
    public Bus updateBusLocation(String id, Double latitude, Double longitude) {
        try {
            Long busId = Long.parseLong(id);
            Optional<Bus> busOptional = busRepository.findById(busId);
            
            if (busOptional.isPresent()) {
                Bus bus = busOptional.get();
                bus.setLatitude(latitude);
                bus.setLongitude(longitude);
                bus.setLastUpdated(LocalDateTime.now());
                return busRepository.save(bus);
            }
        } catch (NumberFormatException e) {
            return null;
        }
        return null;
    }
    
    // Update bus status
    public Bus updateBusStatus(String id, String status) {
        try {
            Long busId = Long.parseLong(id);
            Optional<Bus> busOptional = busRepository.findById(busId);
            
            if (busOptional.isPresent()) {
                Bus bus = busOptional.get();
                bus.setCurrentStatus(status);
                bus.setLastUpdated(LocalDateTime.now());
                return busRepository.save(bus);
            }
        } catch (NumberFormatException e) {
            return null;
        }
        return null;
    }
    
    // Delete bus
    public boolean deleteBus(String id) {
        try {
            Long busId = Long.parseLong(id);
            if (busRepository.existsById(busId)) {
                busRepository.deleteById(busId);
                return true;
            }
        } catch (NumberFormatException e) {
            return false;
        }
        return false;
    }
    
    // Get active buses
    public List<Bus> getActiveBuses() {
        return busRepository.findByIsActiveTrue();
    }
    
    // Get active buses by school
    public List<Bus> getActiveBusesBySchool(String schoolId) {
        return busRepository.findBySchoolIdAndIsActiveTrue(schoolId);
    }
}

