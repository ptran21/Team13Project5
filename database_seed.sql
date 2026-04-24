-- ============================================================
-- File Name: person1_database_seed.sql
-- Project: SE 4220 Class Project 5
-- Task: Database Design & Data Population
-- Description:
-- This SQL file creates the database tables and populates
-- the classified advertisement website with:
-- 5 sections
-- 25 categories
-- 75 listings total
-- ============================================================

DROP DATABASE IF EXISTS classified_ads_db;
CREATE DATABASE classified_ads_db;
USE classified_ads_db;

-- ============================================================
-- Table: sections
-- Stores the 5 main sections of the website
-- ============================================================

CREATE TABLE sections (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL
);

-- ============================================================
-- Table: categories
-- Stores categories under each section
-- ============================================================

CREATE TABLE categories (
    id INT AUTO_INCREMENT PRIMARY KEY,
    section_id INT NOT NULL,
    name VARCHAR(100) NOT NULL,
    FOREIGN KEY (section_id) REFERENCES sections(id)
);

-- ============================================================
-- Table: users
-- Stores sample registered users
-- Person 2 can later update this for authentication
-- ============================================================

CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL
);

-- ============================================================
-- Table: listings
-- Stores classified advertisement listings
-- Each item includes 8-10 attributes:
-- id, title, category_id, user_id, price, description,
-- city, phone, condition_status, posted_date
-- ============================================================

CREATE TABLE listings (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(150) NOT NULL,
    category_id INT NOT NULL,
    user_id INT,
    price DECIMAL(10,2),
    description TEXT NOT NULL,
    city VARCHAR(100) NOT NULL,
    phone VARCHAR(20) NOT NULL,
    condition_status VARCHAR(50) NOT NULL,
    posted_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (category_id) REFERENCES categories(id),
    FOREIGN KEY (user_id) REFERENCES users(id)
);

-- ============================================================
-- Insert 5 main sections
-- ============================================================

INSERT INTO sections (name) VALUES
('For Sale'),
('Housing'),
('Services'),
('Jobs'),
('Community');

-- ============================================================
-- Insert 25 categories
-- 5 categories per section
-- ============================================================

INSERT INTO categories (section_id, name) VALUES
-- For Sale
(1, 'Cars & Trucks'),
(1, 'Motorcycles'),
(1, 'Boats'),
(1, 'Books'),
(1, 'Furniture'),

-- Housing
(2, 'Apartments'),
(2, 'Houses for Rent'),
(2, 'Rooms for Rent'),
(2, 'Office Space'),
(2, 'Parking & Storage'),

-- Services
(3, 'Tutoring'),
(3, 'Cleaning'),
(3, 'Moving Help'),
(3, 'Lawn Care'),
(3, 'Computer Repair'),

-- Jobs
(4, 'Software Jobs'),
(4, 'Retail Jobs'),
(4, 'Restaurant Jobs'),
(4, 'General Labor'),
(4, 'Campus Jobs'),

-- Community
(5, 'Events'),
(5, 'Volunteer'),
(5, 'Lost & Found'),
(5, 'Activity Partners'),
(5, 'Local News');

-- ============================================================
-- Insert sample users
-- These users are used as owners of the sample listings
-- ============================================================

INSERT INTO users (username, email, password) VALUES
('alice', 'alice@example.com', 'password123'),
('bob', 'bob@example.com', 'password123'),
('charlie', 'charlie@example.com', 'password123');

-- ============================================================
-- Insert 75 listings
-- Each of the 25 categories has exactly 3 listings
-- City used: Ames
-- ============================================================

INSERT INTO listings (title, category_id, user_id, price, description, city, phone, condition_status) VALUES

-- Category 1: Cars & Trucks
('2018 Toyota Camry SE', 1, 1, 18500.00, 'Reliable sedan with clean interior and good gas mileage.', 'Ames', '515-111-1001', 'Used'),
('2015 Honda Civic LX', 1, 2, 13200.00, 'Compact car in good condition, perfect for commuting.', 'Ames', '515-111-1002', 'Good'),
('2020 Ford F-150 XLT', 1, 3, 28900.00, 'Pickup truck with strong engine and clean title.', 'Ames', '515-111-1003', 'Excellent'),

-- Category 2: Motorcycles
('2017 Yamaha MT-07', 2, 1, 6200.00, 'Sport motorcycle with low mileage and recent maintenance.', 'Ames', '515-111-1004', 'Good'),
('2014 Honda Shadow', 2, 2, 4800.00, 'Comfortable cruiser motorcycle, garage kept.', 'Ames', '515-111-1005', 'Used'),
('2021 Kawasaki Ninja 400', 2, 3, 5900.00, 'Beginner-friendly sport bike in excellent shape.', 'Ames', '515-111-1006', 'Excellent'),

-- Category 3: Boats
('2008 Bayliner 175', 3, 1, 9500.00, 'Small recreational boat with trailer included.', 'Ames', '515-111-1007', 'Used'),
('2012 Tracker Fishing Boat', 3, 2, 8700.00, 'Fishing boat with trolling motor and storage compartments.', 'Ames', '515-111-1008', 'Good'),
('2016 Sea Ray 190', 3, 3, 17500.00, 'Family boat in excellent condition with clean seats.', 'Ames', '515-111-1009', 'Excellent'),

-- Category 4: Books
('Organic Chemistry Textbook', 4, 1, 45.00, 'Used textbook with minimal highlighting.', 'Ames', '515-111-1010', 'Good'),
('Calculus Early Transcendentals', 4, 2, 35.00, 'Calculus textbook with practice problems.', 'Ames', '515-111-1011', 'Used'),
('Data Structures Book', 4, 3, 28.00, 'Computer science textbook for algorithms and data structures.', 'Ames', '515-111-1012', 'Good'),

-- Category 5: Furniture
('Wooden Dining Table', 5, 1, 180.00, 'Solid wood dining table with four chairs.', 'Ames', '515-111-1013', 'Good'),
('Gray Sofa', 5, 2, 250.00, 'Comfortable three-seat sofa from a smoke-free home.', 'Ames', '515-111-1014', 'Used'),
('Queen Bed Frame', 5, 3, 120.00, 'Metal queen bed frame, easy to assemble.', 'Ames', '515-111-1015', 'Good'),

-- Category 6: Apartments
('One-Bedroom Apartment Near Campus', 6, 1, 850.00, 'One-bedroom apartment close to Iowa State campus.', 'Ames', '515-111-1016', 'Available'),
('Two-Bedroom Downtown Apartment', 6, 2, 1200.00, 'Spacious two-bedroom apartment near downtown Ames.', 'Ames', '515-111-1017', 'Available'),
('Studio Apartment', 6, 3, 700.00, 'Affordable studio apartment with utilities included.', 'Ames', '515-111-1018', 'Available'),

-- Category 7: Houses for Rent
('Three-Bedroom House', 7, 1, 1600.00, 'Three-bedroom house with garage and backyard.', 'Ames', '515-111-1019', 'Available'),
('Four-Bedroom Student House', 7, 2, 2100.00, 'Large student rental house close to campus bus route.', 'Ames', '515-111-1020', 'Available'),
('Two-Bedroom Small House', 7, 3, 1300.00, 'Cozy two-bedroom house in a quiet neighborhood.', 'Ames', '515-111-1021', 'Available'),

-- Category 8: Rooms for Rent
('Private Room Near Campus', 8, 1, 500.00, 'Private room in shared apartment, utilities included.', 'Ames', '515-111-1022', 'Available'),
('Furnished Room', 8, 2, 550.00, 'Furnished room with desk, bed, and closet.', 'Ames', '515-111-1023', 'Available'),
('Basement Room Rental', 8, 3, 475.00, 'Basement room available in shared house.', 'Ames', '515-111-1024', 'Available'),

-- Category 9: Office Space
('Small Office Suite', 9, 1, 900.00, 'Office suite suitable for small business or startup.', 'Ames', '515-111-1025', 'Available'),
('Downtown Office Room', 9, 2, 650.00, 'Private office room in downtown Ames building.', 'Ames', '515-111-1026', 'Available'),
('Shared Workspace Desk', 9, 3, 250.00, 'Desk space available in shared office environment.', 'Ames', '515-111-1027', 'Available'),

-- Category 10: Parking & Storage
('Covered Parking Spot', 10, 1, 75.00, 'Covered parking spot near campus.', 'Ames', '515-111-1028', 'Available'),
('Small Storage Unit', 10, 2, 90.00, 'Clean storage unit for household items.', 'Ames', '515-111-1029', 'Available'),
('Garage Space Rental', 10, 3, 150.00, 'Garage space available for parking or storage.', 'Ames', '515-111-1030', 'Available'),

-- Category 11: Tutoring
('Math Tutoring', 11, 1, 25.00, 'Tutoring available for algebra, calculus, and statistics.', 'Ames', '515-111-1031', 'Available'),
('Chemistry Tutoring', 11, 2, 30.00, 'General and organic chemistry tutoring for students.', 'Ames', '515-111-1032', 'Available'),
('Programming Tutoring', 11, 3, 35.00, 'Java, Python, and web development tutoring.', 'Ames', '515-111-1033', 'Available'),

-- Category 12: Cleaning
('Apartment Cleaning Service', 12, 1, 80.00, 'Standard apartment cleaning for students and renters.', 'Ames', '515-111-1034', 'Available'),
('Move-Out Cleaning', 12, 2, 150.00, 'Deep cleaning service for move-out inspections.', 'Ames', '515-111-1035', 'Available'),
('Weekly House Cleaning', 12, 3, 100.00, 'Weekly cleaning service for homes and apartments.', 'Ames', '515-111-1036', 'Available'),

-- Category 13: Moving Help
('Local Moving Help', 13, 1, 120.00, 'Help loading and unloading furniture locally.', 'Ames', '515-111-1037', 'Available'),
('Truck and Moving Assistance', 13, 2, 180.00, 'Moving help with pickup truck included.', 'Ames', '515-111-1038', 'Available'),
('Dorm Move-In Help', 13, 3, 60.00, 'Assistance moving into dorms or apartments.', 'Ames', '515-111-1039', 'Available'),

-- Category 14: Lawn Care
('Lawn Mowing Service', 14, 1, 45.00, 'Affordable lawn mowing for small and medium yards.', 'Ames', '515-111-1040', 'Available'),
('Leaf Removal', 14, 2, 70.00, 'Seasonal leaf cleanup and bagging service.', 'Ames', '515-111-1041', 'Available'),
('Snow Removal', 14, 3, 50.00, 'Driveway and sidewalk snow removal.', 'Ames', '515-111-1042', 'Available'),

-- Category 15: Computer Repair
('Laptop Repair', 15, 1, 75.00, 'Diagnosis and repair for common laptop problems.', 'Ames', '515-111-1043', 'Available'),
('Virus Removal', 15, 2, 60.00, 'Computer cleanup and malware removal service.', 'Ames', '515-111-1044', 'Available'),
('Custom PC Build Help', 15, 3, 100.00, 'Assistance building or upgrading desktop computers.', 'Ames', '515-111-1045', 'Available'),

-- Category 16: Software Jobs
('Junior Web Developer', 16, 1, 25.00, 'Part-time web developer position for local business.', 'Ames', '515-111-1046', 'Open'),
('Software Testing Intern', 16, 2, 22.00, 'Internship focused on software testing and documentation.', 'Ames', '515-111-1047', 'Open'),
('Mobile App Assistant', 16, 3, 24.00, 'Help needed for basic mobile app development tasks.', 'Ames', '515-111-1048', 'Open'),

-- Category 17: Retail Jobs
('Cashier Position', 17, 1, 14.00, 'Part-time cashier needed for local store.', 'Ames', '515-111-1049', 'Open'),
('Sales Associate', 17, 2, 15.00, 'Retail sales associate position with flexible hours.', 'Ames', '515-111-1050', 'Open'),
('Stockroom Assistant', 17, 3, 14.50, 'Assist with inventory and stocking shelves.', 'Ames', '515-111-1051', 'Open'),

-- Category 18: Restaurant Jobs
('Server Position', 18, 1, 12.00, 'Restaurant server position with evening shifts.', 'Ames', '515-111-1052', 'Open'),
('Kitchen Helper', 18, 2, 15.00, 'Kitchen assistant needed for food prep and cleaning.', 'Ames', '515-111-1053', 'Open'),
('Barista', 18, 3, 13.50, 'Coffee shop barista position with flexible schedule.', 'Ames', '515-111-1054', 'Open'),

-- Category 19: General Labor
('Warehouse Worker', 19, 1, 17.00, 'General warehouse work including lifting and sorting.', 'Ames', '515-111-1055', 'Open'),
('Painting Assistant', 19, 2, 18.00, 'Help needed for residential painting projects.', 'Ames', '515-111-1056', 'Open'),
('Event Setup Crew', 19, 3, 16.00, 'Temporary event setup and cleanup crew needed.', 'Ames', '515-111-1057', 'Open'),

-- Category 20: Campus Jobs
('Library Desk Assistant', 20, 1, 13.00, 'Student worker needed at library front desk.', 'Ames', '515-111-1058', 'Open'),
('Research Lab Assistant', 20, 2, 15.00, 'Campus research lab assistant position.', 'Ames', '515-111-1059', 'Open'),
('Dining Hall Worker', 20, 3, 14.00, 'Dining hall student worker with flexible shifts.', 'Ames', '515-111-1060', 'Open'),

-- Category 21: Events
('Community Picnic', 21, 1, 0.00, 'Free community picnic at local park this weekend.', 'Ames', '515-111-1061', 'Upcoming'),
('Local Art Fair', 21, 2, 5.00, 'Art fair featuring local artists and vendors.', 'Ames', '515-111-1062', 'Upcoming'),
('Student Music Night', 21, 3, 10.00, 'Live music event featuring student performers.', 'Ames', '515-111-1063', 'Upcoming'),

-- Category 22: Volunteer
('Food Pantry Volunteer', 22, 1, 0.00, 'Volunteers needed to organize and distribute food.', 'Ames', '515-111-1064', 'Open'),
('Park Cleanup Volunteer', 22, 2, 0.00, 'Help clean up local parks and walking trails.', 'Ames', '515-111-1065', 'Open'),
('Animal Shelter Helper', 22, 3, 0.00, 'Volunteer opportunity at local animal shelter.', 'Ames', '515-111-1066', 'Open'),

-- Category 23: Lost & Found
('Lost Black Backpack', 23, 1, 0.00, 'Black backpack lost near campus bus stop.', 'Ames', '515-111-1067', 'Lost'),
('Found Set of Keys', 23, 2, 0.00, 'Set of keys found near downtown Ames.', 'Ames', '515-111-1068', 'Found'),
('Lost Student ID Card', 23, 3, 0.00, 'Student ID card lost near library area.', 'Ames', '515-111-1069', 'Lost'),

-- Category 24: Activity Partners
('Tennis Partner Wanted', 24, 1, 0.00, 'Looking for a tennis partner for weekend practice.', 'Ames', '515-111-1070', 'Open'),
('Study Group for Chemistry', 24, 2, 0.00, 'Looking for students to form a chemistry study group.', 'Ames', '515-111-1071', 'Open'),
('Running Group', 24, 3, 0.00, 'Seeking people interested in weekly group runs.', 'Ames', '515-111-1072', 'Open'),

-- Category 25: Local News
('Road Construction Notice', 25, 1, 0.00, 'Road construction will affect traffic near downtown.', 'Ames', '515-111-1073', 'Informational'),
('Library Extended Hours', 25, 2, 0.00, 'Local library will extend hours during finals week.', 'Ames', '515-111-1074', 'Informational'),
('Community Center Update', 25, 3, 0.00, 'Community center announces new spring programs.', 'Ames', '515-111-1075', 'Informational');

-- ============================================================
-- Verification Queries
-- Run these after importing the database
-- ============================================================

-- Should return 5
SELECT COUNT(*) AS total_sections FROM sections;

-- Should return 25
SELECT COUNT(*) AS total_categories FROM categories;

-- Should return 75
SELECT COUNT(*) AS total_listings FROM listings;

-- Should show 3 listings for each category
SELECT 
    categories.id AS category_id,
    categories.name AS category_name,
    COUNT(listings.id) AS total_items
FROM categories
LEFT JOIN listings ON categories.id = listings.category_id
GROUP BY categories.id, categories.name
ORDER BY categories.id;

-- Full joined view for backend/frontend testing
SELECT
    listings.id,
    listings.title,
    sections.name AS section_name,
    categories.name AS category_name,
    listings.price,
    listings.city,
    listings.phone,
    listings.condition_status
FROM listings
JOIN categories ON listings.category_id = categories.id
JOIN sections ON categories.section_id = sections.id
ORDER BY sections.id, categories.id, listings.id;