-- Fix transport_routes table - Add missing capacity column
-- This script fixes the schema validation error for the TransportRoute entity

USE school_fee_register;

-- Check if transport_routes table exists
SET @table_exists = (SELECT COUNT(*) FROM information_schema.tables 
                     WHERE table_schema = 'school_fee_register' 
                     AND table_name = 'transport_routes');

-- If table doesn't exist, create it with all required columns
SET @sql = IF(@table_exists = 0,
    'CREATE TABLE transport_routes (
        id BIGINT AUTO_INCREMENT PRIMARY KEY,
        name VARCHAR(100) NOT NULL,
        code VARCHAR(20) NOT NULL UNIQUE,
        pickup_location VARCHAR(200) NOT NULL,
        drop_location VARCHAR(200) NOT NULL,
        distance_km DECIMAL(5,2),
        estimated_time_minutes INT,
        vehicle_number VARCHAR(20),
        driver_name VARCHAR(100),
        driver_phone VARCHAR(20),
        capacity INT DEFAULT 50,
        current_occupancy INT DEFAULT 0,
        monthly_fee DECIMAL(10,2),
        is_active BOOLEAN DEFAULT TRUE,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
        INDEX idx_route_code (code),
        INDEX idx_route_active (is_active),
        INDEX idx_pickup_location (pickup_location),
        INDEX idx_drop_location (drop_location)
    )',
    'SELECT "Table already exists" as message'
);

PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- If table exists, check if capacity column exists and add it if missing
SET @column_exists = (SELECT COUNT(*) FROM information_schema.columns 
                      WHERE table_schema = 'school_fee_register' 
                      AND table_name = 'transport_routes' 
                      AND column_name = 'capacity');

-- Add capacity column if it doesn't exist
SET @add_column_sql = IF(@column_exists = 0,
    'ALTER TABLE transport_routes ADD COLUMN capacity INT DEFAULT 50',
    'SELECT "Capacity column already exists" as message'
);

PREPARE stmt FROM @add_column_sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Check if current_occupancy column exists and add it if missing
SET @occupancy_exists = (SELECT COUNT(*) FROM information_schema.columns 
                         WHERE table_schema = 'school_fee_register' 
                         AND table_name = 'transport_routes' 
                         AND column_name = 'current_occupancy');

-- Add current_occupancy column if it doesn't exist
SET @add_occupancy_sql = IF(@occupancy_exists = 0,
    'ALTER TABLE transport_routes ADD COLUMN current_occupancy INT DEFAULT 0',
    'SELECT "Current occupancy column already exists" as message'
);

PREPARE stmt FROM @add_occupancy_sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Verify the table structure
DESCRIBE transport_routes;

-- Show success message
SELECT 'Transport routes table fixed successfully!' as status; 