-- Sample Data for ABC Campsite System
-- Insert this data after running schema.sql

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";

-- --------------------------------------------------------
-- Sample Admins
-- --------------------------------------------------------
-- Password: admin123 (hashed with SHA-256)
-- Note: For actual implementation, ensure hashing matches PasswordUtil (currently SHA-256)
INSERT INTO `admins` (`admin_id`, `username`, `password`, `full_name`, `email`, `role`, `is_active`) VALUES
(1, 'admin', '240be518fabd2724ddb6f04eeb1da5967448d7e831c08c8fa822809f74c720a9', 'System Administrator', 'admin@abccampsite.com', 'Admin', 1),
(2, 'staff1', '240be518fabd2724ddb6f04eeb1da5967448d7e831c08c8fa822809f74c720a9', 'Staff Member One', 'staff1@abccampsite.com', 'Staff', 1);

-- --------------------------------------------------------
-- Sample Campsites
-- --------------------------------------------------------
INSERT INTO `campsites` (`campsite_id`, `name`, `location`, `description`, `image`, `is_active`) VALUES
(1, 'Mountain View Campsite', 'Cameron Highlands, Pahang', 'Experience breathtaking mountain views and cool weather. Perfect for families and nature lovers.', 'images/mountain-view.jpg', 1),
(2, 'Beachside Paradise', 'Pulau Perhentian, Terengganu', 'Relax by the crystal clear waters with white sandy beaches. Ideal for water sports enthusiasts.', 'images/beach-campsite.jpg', 1),
(3, 'Rainforest Retreat', 'Taman Negara, Pahang', 'Immerse yourself in the oldest rainforest in the world. Adventure and wildlife await!', 'images/rainforest.jpg', 1);

-- --------------------------------------------------------
-- Sample Rooms (2+ rooms per campsite)
-- --------------------------------------------------------
INSERT INTO `available_rooms` (`room_id`, `campsite_id`, `name`, `location`, `description`, `image`, `price_per_tent`, `quota`, `available_quota`, `is_active`) VALUES
-- Mountain View Campsite Rooms
(1, 1, 'Highland Terrace', 'Zone A', 'Spacious area with panoramic mountain views. Close to hiking trails.', 'images/highland-terrace.jpg', 50.00, 20, 20, 1),
(2, 1, 'Pine Valley', 'Zone B', 'Peaceful spot surrounded by pine trees. Perfect for quiet camping.', 'images/pine-valley.jpg', 45.00, 15, 15, 1),
(3, 1, 'Summit Ridge', 'Zone C', 'Premium location with best views. Limited spots available.', 'images/summit-ridge.jpg', 65.00, 10, 10, 1),

-- Beachside Paradise Rooms
(4, 2, 'Coral Bay', 'North Beach', 'Direct beach access with stunning sunrise views.', 'images/coral-bay.jpg', 60.00, 25, 25, 1),
(5, 2, 'Palm Grove', 'South Beach', 'Shaded area under coconut palms. Great for families.', 'images/palm-grove.jpg', 55.00, 20, 20, 1),

-- Rainforest Retreat Rooms
(6, 3, 'Canopy Camp', 'Deep Forest', 'Experience camping under the rainforest canopy. Adventure zone.', 'images/canopy-camp.jpg', 70.00, 15, 15, 1),
(7, 3, 'River Edge', 'Near River', 'Camp by the flowing river. Natural sounds for relaxation.', 'images/river-edge.jpg', 65.00, 18, 18, 1),
(8, 3, 'Wildlife Watch', 'Observation Point', 'Best spot for wildlife observation and bird watching.', 'images/wildlife-watch.jpg', 75.00, 12, 12, 1);

-- --------------------------------------------------------
-- Sample Guests
-- --------------------------------------------------------
-- Password: password123 (should be hashed in real implementation)
INSERT INTO `guests` (`guest_id`, `name`, `ic`, `password`, `phone`, `email`, `address`, `dob`) VALUES
(1, 'Ahmad Bin Abdullah', '900101-01-1234', 'password123', '012-3456789', 'ahmad@example.com', '123 Jalan Merdeka, Kuala Lumpur', '1990-01-01'),
(2, 'Siti Nurhaliza', '920505-05-5678', 'password123', '013-9876543', 'siti@example.com', '456 Jalan Raja, Petaling Jaya', '1992-05-05'),
(3, 'Tan Wei Ming', '880808-08-9012', 'password123', '014-5551234', 'wei.ming@example.com', '789 Jalan Ipoh, Ipoh', '1988-08-08'),
(4, 'Kumar Raj', '950303-03-3456', 'password123', '016-7778888', 'kumar@example.com', '321 Jalan Gombak, Selangor', '1995-03-03');

-- --------------------------------------------------------
-- Sample Bookings (Various Statuses)
-- --------------------------------------------------------
INSERT INTO `bookings` (`booking_id`, `guest_id`, `campsite_id`, `room_id`, `booking_date`, `checkout_date`, `num_tents`, `total_price`, `status`, `payment_status`) VALUES
-- Confirmed upcoming bookings
('BKG-20260201-0001', 1, 1, 1, '2026-02-15', '2026-02-17', 2, 100.00, 'Confirmed', 'Paid'),
('BKG-20260201-0002', 2, 2, 4, '2026-02-20', '2026-02-22', 3, 180.00, 'Confirmed', 'Paid'),

-- Pending bookings (awaiting payment)
('BKG-20260201-0003', 3, 3, 6, '2026-03-10', '2026-03-12', 2, 140.00, 'Pending', 'Unpaid'),

-- Ongoing booking
('BKG-20260130-0001', 1, 1, 2, '2026-01-29', '2026-01-31', 1, 45.00, 'Ongoing', 'Paid'),

-- Completed bookings
('BKG-20260115-0001', 2, 2, 5, '2026-01-15', '2026-01-17', 2, 110.00, 'Completed', 'Paid'),
('BKG-20260110-0001', 4, 3, 7, '2026-01-10', '2026-01-12', 3, 195.00, 'Completed', 'Paid'),

-- Cancelled booking
('BKG-20260120-0001', 3, 1, 3, '2026-02-05', '2026-02-07', 1, 65.00, 'Cancelled', 'Refunded');

-- --------------------------------------------------------
-- Sample Payments
-- --------------------------------------------------------
INSERT INTO `payments` (`payment_id`, `booking_id`, `payment_method`, `amount`, `transaction_id`, `status`) VALUES
(1, 'BKG-20260201-0001', 'Credit Card', 100.00, 'TXN-CC-20260201-001', 'Completed'),
(2, 'BKG-20260201-0002', 'Online Banking', 180.00, 'TXN-OB-20260201-002', 'Completed'),
(3, 'BKG-20260130-0001', 'Debit Card', 45.00, 'TXN-DC-20260130-001', 'Completed'),
(4, 'BKG-20260115-0001', 'E-Wallet', 110.00, 'TXN-EW-20260115-001', 'Completed'),
(5, 'BKG-20260110-0001', 'Credit Card', 195.00, 'TXN-CC-20260110-001', 'Completed'),
(6, 'BKG-20260120-0001', 'Online Banking', 65.00, 'TXN-OB-20260120-001', 'Refunded');

-- --------------------------------------------------------
-- Sample Booking Rooms (Junction table)
-- --------------------------------------------------------
INSERT INTO `booking_rooms` (`booking_id`, `room_id`, `quantity`) VALUES
('BKG-20260201-0001', 1, 1),
('BKG-20260201-0002', 4, 1),
('BKG-20260201-0003', 6, 1),
('BKG-20260130-0001', 2, 1),
('BKG-20260115-0001', 5, 1),
('BKG-20260110-0001', 7, 1),
('BKG-20260120-0001', 3, 1);

COMMIT;

-- --------------------------------------------------------
-- Summary
-- --------------------------------------------------------
-- This sample data provides:
-- - 2 admin accounts (admin/staff)
-- - 3 campsites
-- - 8 rooms across different campsites (multiple rooms per campsite)
-- - 4 sample guests
-- - 7 bookings with various statuses (Pending, Confirmed, Ongoing, Completed, Cancelled)
-- - 6 payment records
-- - Junction table entries for booking-room relationships
