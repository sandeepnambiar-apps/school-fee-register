package com.school.config;

import com.school.entity.Bus;
import com.school.repository.BusRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Component;

import java.util.Arrays;
import java.util.List;

@Component
public class BusDataInitializer implements CommandLineRunner {
    
    @Autowired
    private BusRepository busRepository;
    
    @Override
    public void run(String... args) throws Exception {
        // Only initialize if no buses exist
        if (busRepository.count() == 0) {
            initializeSampleBuses();
        }
    }
    
    private void initializeSampleBuses() {
        // Sample bus for BOON E.M School
        Bus bus1 = new Bus(
            "BUS001",
            "John Driver",
            "+91-9876543210",
            "Route A - City Center",
            "school1", // This should match your school ID
            12.9716, // Bangalore coordinates
            77.5946,
            Arrays.asList("student1", "student2", "student3")
        );
        
        Bus bus2 = new Bus(
            "BUS002",
            "Mary Driver",
            "+91-9876543211",
            "Route B - Suburban Area",
            "school1", // This should match your school ID
            12.9716, // Bangalore coordinates
            77.5946,
            Arrays.asList("student4", "student5")
        );
        
        Bus bus3 = new Bus(
            "BUS003",
            "Peter Driver",
            "+91-9876543212",
            "Route C - Industrial Zone",
            "school1", // This should match your school ID
            12.9716, // Bangalore coordinates
            77.5946,
            Arrays.asList("student6", "student7", "student8")
        );
        
        // Save all buses
        List<Bus> buses = Arrays.asList(bus1, bus2, bus3);
        busRepository.saveAll(buses);
        
        System.out.println("Sample bus data initialized successfully in monolith!");
    }
}

