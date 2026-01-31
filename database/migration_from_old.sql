-- Migration script from old schema to new schema
-- WARNING: BACKUP YOUR DATA FIRST!
-- This script helps migrate existing data to the new schema

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";

-- ========================================
-- STEP 1: Backup existing data
-- ========================================
-- Run these commands manually before migration:
-- mysqldump -u root abccampsite > backup_before_migration.sql

-- ========================================
-- STEP 2: Add email column to guests table
-- ========================================
-- Check if email column exists, if not add it
ALTER TABLE `guests` 
ADD COLUMN IF NOT EXISTS `email` varchar(100) DEFAULT NULL AFTER `phone`;

-- Set default emails for existing guests (TEMPORARY - users should update)
UPDATE `guests` 
SET `email` = CONCAT(LOWER(REPLACE(name, ' ', '.')), '@temp.com')
WHERE `email` IS NULL OR `email` = '';

-- Make email unique after setting default values
ALTER TABLE `guests` 
ADD CONSTRAINT UNIQUE KEY `email` (`email`);

-- ========================================
-- STEP 3: Create new tables if not exists
-- ========================================

-- Create admins table
CREATE TABLE IF NOT EXISTS `admins` (
  `admin_id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(50) NOT NULL,
  `password` varchar(255) NOT NULL,
  `full_name` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `role` enum('Admin','Staff') NOT NULL DEFAULT 'Staff',
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`admin_id`),
  UNIQUE KEY `username` (`username`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Create default admin account if not exists
-- Password: admin123 (plain text - as per requirements)
INSERT INTO `admins` (`username`, `password`, `full_name`, `email`, `role`, `is_active`)
SELECT 'admin', 'admin123', 'Administrator', 'admin@abccampsite.com', 'Admin', 1
WHERE NOT EXISTS (SELECT 1 FROM `admins` WHERE `username` = 'admin');

-- Create payments table
CREATE TABLE IF NOT EXISTS `payments` (
  `payment_id` int(11) NOT NULL AUTO_INCREMENT,
  `booking_id` varchar(20) NOT NULL,
  `payment_method` enum('Credit Card','Debit Card','Online Banking','E-Wallet') NOT NULL,
  `payment_date` timestamp NOT NULL DEFAULT current_timestamp(),
  `amount` decimal(10,2) NOT NULL,
  `transaction_id` varchar(100) DEFAULT NULL,
  `status` enum('Pending','Completed','Failed','Refunded') NOT NULL DEFAULT 'Pending',
  `receipt_path` varchar(255) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`payment_id`),
  KEY `booking_id` (`booking_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Create password_resets table
CREATE TABLE IF NOT EXISTS `password_resets` (
  `reset_id` int(11) NOT NULL AUTO_INCREMENT,
  `guest_id` int(11) NOT NULL,
  `reset_token` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `expires_at` timestamp NOT NULL,
  `used` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`reset_id`),
  KEY `guest_id` (`guest_id`),
  KEY `reset_token` (`reset_token`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Create booking_rooms junction table
CREATE TABLE IF NOT EXISTS `booking_rooms` (
  `booking_id` varchar(20) NOT NULL,
  `room_id` int(11) NOT NULL,
  `quantity` int(11) NOT NULL DEFAULT 1,
  PRIMARY KEY (`booking_id`, `room_id`),
  KEY `room_id` (`room_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ========================================
-- STEP 4: Modify bookings table
-- ========================================

-- Add guest_id column if not exists
ALTER TABLE `bookings` 
ADD COLUMN IF NOT EXISTS `guest_id` int(11) DEFAULT NULL AFTER `booking_id`;

-- Migrate data: Match bookings to guests using IC number
UPDATE `bookings` b
JOIN `guests` g ON b.ic = g.ic
SET b.guest_id = g.guest_id
WHERE b.guest_id IS NULL;

-- Update old status values to new enum values
UPDATE `bookings` SET `status` = 'Confirmed' WHERE `status` = 'Paid';
UPDATE `bookings` SET `status` = 'Pending' WHERE `status` NOT IN ('Confirmed', 'Ongoing', 'Completed', 'Cancelled');

-- Add payment_status column if not exists
ALTER TABLE `bookings`
ADD COLUMN IF NOT EXISTS `payment_status` enum('Unpaid','Paid','Refunded') NOT NULL DEFAULT 'Unpaid' AFTER `status`;

-- Set payment_status based on old status or payment_method
UPDATE `bookings` 
SET `payment_status` = 'Paid' 
WHERE `status` IN ('Confirmed', 'Ongoing', 'Completed') OR `payment_method` IS NOT NULL;

-- Add cancellation_reason and cancelled_at columns
ALTER TABLE `bookings`
ADD COLUMN IF NOT EXISTS `cancellation_reason` text DEFAULT NULL,
ADD COLUMN IF NOT EXISTS `cancelled_at` timestamp NULL DEFAULT NULL;

-- Migrate existing payment data to payments table
INSERT INTO `payments` (`booking_id`, `payment_method`, `amount`, `transaction_id`, `status`)
SELECT 
  `booking_id`,
  COALESCE(`payment_method`, 'Online Banking') as payment_method,
  `total_price`,
  CONCAT('TXN-', `booking_id`) as transaction_id,
  CASE 
    WHEN `status` = 'Cancelled' THEN 'Refunded'
    WHEN `payment_status` = 'Paid' THEN 'Completed'
    ELSE 'Pending'
  END as status
FROM `bookings`
WHERE NOT EXISTS (
  SELECT 1 FROM `payments` p WHERE p.booking_id = bookings.booking_id
);

-- Populate booking_rooms junction table from existing bookings
INSERT INTO `booking_rooms` (`booking_id`, `room_id`, `quantity`)
SELECT `booking_id`, `room_id`, 1
FROM `bookings`
WHERE `room_id` IS NOT NULL 
  AND NOT EXISTS (
    SELECT 1 FROM `booking_rooms` br WHERE br.booking_id = bookings.booking_id AND br.room_id = bookings.room_id
  );

-- ========================================
-- STEP 5: Drop old columns (CAREFUL!)
-- ========================================
-- Uncomment these lines ONLY after verifying data migration was successful

-- ALTER TABLE `bookings` DROP COLUMN IF EXISTS `guest_name`;
-- ALTER TABLE `bookings` DROP COLUMN IF EXISTS `phone`;
-- ALTER TABLE `bookings` DROP COLUMN IF EXISTS `ic`;
-- ALTER TABLE `bookings` DROP COLUMN IF EXISTS `address`;
-- ALTER TABLE `bookings` DROP COLUMN IF EXISTS `payment_method`;

-- ========================================
-- STEP 6: Add foreign key constraints
-- ========================================
-- Add foreign key for guest_id if not exists
-- First, make guest_id NOT NULL after migration
-- ALTER TABLE `bookings` MODIFY `guest_id` int(11) NOT NULL;

-- Then add foreign key constraint
-- ALTER TABLE `bookings` 
-- ADD CONSTRAINT `bookings_ibfk_1` FOREIGN KEY (`guest_id`) REFERENCES `guests` (`guest_id`) ON DELETE CASCADE;

-- Add other foreign keys if not exists
-- ALTER TABLE `payments` 
-- ADD CONSTRAINT `payments_ibfk_1` FOREIGN KEY (`booking_id`) REFERENCES `bookings` (`booking_id`) ON DELETE CASCADE;

-- ALTER TABLE `password_resets`
-- ADD CONSTRAINT `password_resets_ibfk_1` FOREIGN KEY (`guest_id`) REFERENCES `guests` (`guest_id`) ON DELETE CASCADE;

-- ALTER TABLE `booking_rooms`
-- ADD CONSTRAINT `booking_rooms_ibfk_1` FOREIGN KEY (`booking_id`) REFERENCES `bookings` (`booking_id`) ON DELETE CASCADE,
-- ADD CONSTRAINT `booking_rooms_ibfk_2` FOREIGN KEY (`room_id`) REFERENCES `available_rooms` (`room_id`) ON DELETE CASCADE;

-- ========================================
-- STEP 7: Remove customers table
-- ========================================
-- DROP TABLE IF EXISTS `customers`;

COMMIT;

-- ========================================
-- POST-MIGRATION VERIFICATION
-- ========================================
-- Run these queries to verify migration:
-- SELECT COUNT(*) as total_guests FROM guests;
-- SELECT COUNT(*) as total_bookings FROM bookings;
-- SELECT COUNT(*) as total_payments FROM payments;
-- SELECT COUNT(*) as bookings_with_guests FROM bookings WHERE guest_id IS NOT NULL;
-- SELECT * FROM bookings WHERE guest_id IS NULL; -- Should be empty

-- ========================================
-- NOTES
-- ========================================
-- 1. This migration script is designed to be run incrementally
-- 2. Always backup your database before running
-- 3. Test on a development environment first
-- 4. Uncomment foreign key and drop column statements only after verification
-- 5. Update application code to use new schema before removing old columns
