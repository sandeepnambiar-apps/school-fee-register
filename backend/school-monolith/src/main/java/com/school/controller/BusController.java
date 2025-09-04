package com.school.controller;

import com.school.entity.Bus;
import com.school.service.BusService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/buses")
@CrossOrigin(origins = "*")
public class BusController {

    @Autowired
    private BusService busService;

    // Get all buses
    @GetMapping
    public ResponseEntity<List<Bus>> getAllBuses() {
        List<Bus> buses = busService.getAllBuses();
        return ResponseEntity.ok(buses);
    }

    // Get buses by school ID
    @GetMapping("/school/{schoolId}")
    public ResponseEntity<List<Bus>> getBusesBySchool(@PathVariable String schoolId) {
        List<Bus> buses = busService.getBusesBySchool(schoolId);
        return ResponseEntity.ok(buses);
    }

    // Get buses by student ID
    @GetMapping("/student/{studentId}")
    public ResponseEntity<List<Bus>> getBusesByStudent(@PathVariable String studentId) {
        List<Bus> buses = busService.getBusesByStudent(studentId);
        return ResponseEntity.ok(buses);
    }

    // Get bus by ID
    @GetMapping("/{id}")
    public ResponseEntity<Bus> getBusById(@PathVariable String id) {
        Bus bus = busService.getBusById(id);
        if (bus != null) {
            return ResponseEntity.ok(bus);
        }
        return ResponseEntity.notFound().build();
    }

    // Create new bus
    @PostMapping
    public ResponseEntity<Bus> createBus(@RequestBody Bus bus) {
        Bus createdBus = busService.createBus(bus);
        return ResponseEntity.ok(createdBus);
    }

    // Update bus
    @PutMapping("/{id}")
    public ResponseEntity<Bus> updateBus(@PathVariable String id, @RequestBody Bus bus) {
        Bus updatedBus = busService.updateBus(id, bus);
        if (updatedBus != null) {
            return ResponseEntity.ok(updatedBus);
        }
        return ResponseEntity.notFound().build();
    }

    // Update bus location
    @PostMapping("/{id}/location")
    public ResponseEntity<Bus> updateBusLocation(
            @PathVariable String id,
            @RequestBody Map<String, Object> locationData) {

        Double latitude = (Double) locationData.get("latitude");
        Double longitude = (Double) locationData.get("longitude");
        String timestamp = (String) locationData.get("timestamp");

        if (latitude == null || longitude == null) {
            return ResponseEntity.badRequest().build();
        }

        Bus updatedBus = busService.updateBusLocation(id, latitude, longitude);
        if (updatedBus != null) {
            return ResponseEntity.ok(updatedBus);
        }
        return ResponseEntity.notFound().build();
    }

    // Delete bus
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteBus(@PathVariable String id) {
        boolean deleted = busService.deleteBus(id);
        if (deleted) {
            return ResponseEntity.ok().build();
        }
        return ResponseEntity.notFound().build();
    }

    // Get active buses
    @GetMapping("/active")
    public ResponseEntity<List<Bus>> getActiveBuses() {
        List<Bus> activeBuses = busService.getActiveBuses();
        return ResponseEntity.ok(activeBuses);
    }

    // Update bus status
    @PostMapping("/{id}/status")
    public ResponseEntity<Bus> updateBusStatus(
            @PathVariable String id,
            @RequestBody Map<String, String> statusData) {

        String status = statusData.get("status");
        if (status == null) {
            return ResponseEntity.badRequest().build();
        }

        Bus updatedBus = busService.updateBusStatus(id, status);
        if (updatedBus != null) {
            return ResponseEntity.ok(updatedBus);
        }
        return ResponseEntity.notFound().build();
    }
}

