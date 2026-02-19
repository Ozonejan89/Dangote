-- ============================================================
-- DANGOTE TRUCK DELIVERY SERVICE — DATABASE SCHEMA & SEED DATA
-- ============================================================

-- REGIONS
CREATE TABLE IF NOT EXISTS regions (
    id INTEGER PRIMARY KEY,
    name TEXT NOT NULL,
    zone TEXT NOT NULL
);

INSERT INTO regions VALUES
(1,'South-West','Southern'),(2,'South-South','Southern'),
(3,'South-East','Southern'),(4,'North-Central','Northern'),
(5,'North-West','Northern'),(6,'North-East','Northern');

-- DEPOTS
CREATE TABLE IF NOT EXISTS depots (
    id INTEGER PRIMARY KEY,
    name TEXT NOT NULL,
    city TEXT NOT NULL,
    state TEXT NOT NULL,
    region_id INTEGER REFERENCES regions(id)
);

INSERT INTO depots VALUES
(1,'Ibese Cement Plant','Ibese','Ogun',1),
(2,'Obajana Cement Plant','Obajana','Kogi',4),
(3,'Gboko Cement Plant','Gboko','Benue',4),
(4,'Apapa Sugar Refinery','Lagos','Lagos',1),
(5,'Apapa Flour Mill','Lagos','Lagos',1),
(6,'Lekki Fertilizer Plant','Lagos','Lagos',1),
(7,'Kano Distribution Hub','Kano','Kano',5),
(8,'Abuja Distribution Hub','Abuja','FCT',4),
(9,'Port Harcourt Depot','Port Harcourt','Rivers',2),
(10,'Kaduna Depot','Kaduna','Kaduna',5);

-- PRODUCTS
CREATE TABLE IF NOT EXISTS products (
    id INTEGER PRIMARY KEY,
    name TEXT NOT NULL,
    category TEXT NOT NULL,
    unit TEXT NOT NULL,
    price_per_ton REAL NOT NULL
);

INSERT INTO products VALUES
(1,'Dangote 3X Cement','Cement','Tons',85000),
(2,'Dangote Falcon Cement','Cement','Tons',80000),
(3,'BlocMaster Cement','Cement','Tons',78000),
(4,'Dangote Sugar','Sugar','Tons',420000),
(5,'Dangote Salt','Salt','Tons',150000),
(6,'Dangote Flour','Flour','Tons',350000),
(7,'NPK Fertilizer','Fertilizer','Tons',280000),
(8,'Urea Fertilizer','Fertilizer','Tons',250000),
(9,'Dangote Pasta','Pasta','Tons',500000),
(10,'Dangote Rice','Rice','Tons',380000);

-- ROUTES
CREATE TABLE IF NOT EXISTS routes (
    id INTEGER PRIMARY KEY,
    route_code TEXT UNIQUE NOT NULL,
    origin TEXT NOT NULL,
    destination TEXT NOT NULL,
    distance_km REAL NOT NULL,
    estimated_hours REAL NOT NULL,
    toll_cost REAL DEFAULT 0,
    risk_level TEXT DEFAULT 'Low'
);

INSERT INTO routes VALUES
(1,'RT-001','Ibese','Lagos',120,3.0,2500,'Low'),
(2,'RT-002','Ibese','Ibadan',85,2.5,1500,'Low'),
(3,'RT-003','Obajana','Abuja',220,5.0,4000,'Medium'),
(4,'RT-004','Lagos','Abuja',750,12.0,15000,'Medium'),
(5,'RT-005','Lagos','Kano',1100,18.0,22000,'High'),
(6,'RT-006','Lagos','Port Harcourt',600,9.0,8000,'Medium'),
(7,'RT-007','Obajana','Kano',650,10.0,12000,'Medium'),
(8,'RT-008','Abuja','Kaduna',200,3.5,3000,'Low'),
(9,'RT-009','Lagos','Benin City',310,5.5,5000,'Medium'),
(10,'RT-010','Kano','Maiduguri',600,10.0,8000,'High'),
(11,'RT-011','Gboko','Enugu',250,5.0,4000,'Medium'),
(12,'RT-012','Lagos','Ilorin',300,5.0,4500,'Low'),
(13,'RT-013','Abuja','Jos',280,4.5,3500,'Medium'),
(14,'RT-014','Port Harcourt','Calabar',250,4.0,3000,'Low'),
(15,'RT-015','Kano','Sokoto',520,8.0,7000,'High');

-- TRUCKS
CREATE TABLE IF NOT EXISTS trucks (
    id INTEGER PRIMARY KEY,
    truck_id TEXT UNIQUE NOT NULL,
    plate_number TEXT NOT NULL,
    type TEXT NOT NULL,
    capacity_tons REAL NOT NULL,
    year_acquired INTEGER NOT NULL,
    depot_id INTEGER REFERENCES depots(id),
    status TEXT DEFAULT 'Active',
    fuel_type TEXT DEFAULT 'Diesel',
    last_service_date TEXT
);

INSERT INTO trucks (truck_id, plate_number, type, capacity_tons, year_acquired, depot_id, status, last_service_date) VALUES
('DGL-T001','LAG-234AB','Trailer',30,2021,1,'Active','2024-09-15'),
('DGL-T002','LAG-567CD','Trailer',30,2022,1,'Active','2024-10-01'),
('DGL-T003','OGN-112EF','Trailer',30,2020,1,'Active','2024-08-20'),
('DGL-T004','OGN-345GH','Trailer',30,2023,1,'Active','2024-10-10'),
('DGL-T005','LAG-789IJ','Flatbed',25,2021,1,'Active','2024-09-05'),
('DGL-T006','OGN-901KL','Trailer',30,2022,1,'Maintenance','2024-10-18'),
('DGL-T007','OGN-223MN','Box Truck',15,2023,1,'Active','2024-09-28'),
('DGL-T008','LAG-456OP','Trailer',30,2021,1,'Active','2024-08-12'),
('DGL-T009','KOG-111QR','Trailer',30,2020,2,'Active','2024-09-22'),
('DGL-T010','KOG-333ST','Trailer',30,2021,2,'Active','2024-10-05'),
('DGL-T011','KOG-555UV','Flatbed',25,2022,2,'Active','2024-09-18'),
('DGL-T012','ABJ-777WX','Trailer',30,2023,2,'Active','2024-10-12'),
('DGL-T013','KOG-999YZ','Tipper',20,2021,2,'Maintenance','2024-10-15'),
('DGL-T014','ABJ-121AB','Box Truck',15,2022,2,'Active','2024-09-30'),
('DGL-T015','BEN-234CD','Trailer',30,2020,3,'Active','2024-08-25'),
('DGL-T016','BEN-456EF','Trailer',30,2021,3,'Active','2024-09-10'),
('DGL-T017','BEN-678GH','Flatbed',25,2022,3,'Active','2024-10-08'),
('DGL-T018','BEN-890IJ','Tipper',20,2023,3,'Out of Service','2024-07-20'),
('DGL-T019','LAG-143KL','Tanker',30,2021,4,'Active','2024-09-14'),
('DGL-T020','LAG-265MN','Tanker',30,2022,4,'Active','2024-10-02'),
('DGL-T021','LAG-387OP','Box Truck',15,2023,4,'Active','2024-09-25'),
('DGL-T022','LAG-409QR','Trailer',30,2021,4,'Active','2024-08-30'),
('DGL-T023','LAG-521ST','Flatbed',25,2020,5,'Active','2024-09-08'),
('DGL-T024','LAG-643UV','Box Truck',15,2022,5,'Active','2024-10-06'),
('DGL-T025','LAG-765WX','Trailer',30,2023,5,'Maintenance','2024-10-16'),
('DGL-T026','LAG-887YZ','Tanker',30,2021,6,'Active','2024-09-20'),
('DGL-T027','LAG-009AB','Tanker',30,2022,6,'Active','2024-10-03'),
('DGL-T028','LAG-131CD','Flatbed',25,2023,6,'Active','2024-09-12'),
('DGL-T029','LAG-253EF','Box Truck',15,2021,6,'Active','2024-08-28'),
('DGL-T030','KAN-375GH','Trailer',30,2020,7,'Active','2024-09-16'),
('DGL-T031','KAN-497IJ','Trailer',30,2021,7,'Active','2024-10-09'),
('DGL-T032','KAN-619KL','Flatbed',25,2022,7,'Active','2024-09-24'),
('DGL-T033','KAN-741MN','Tipper',20,2023,7,'Maintenance','2024-10-14'),
('DGL-T034','ABJ-863OP','Trailer',30,2021,8,'Active','2024-09-06'),
('DGL-T035','ABJ-985QR','Trailer',30,2022,8,'Active','2024-10-11'),
('DGL-T036','ABJ-107ST','Box Truck',15,2023,8,'Active','2024-09-29'),
('DGL-T037','ABJ-229UV','Flatbed',25,2021,8,'Active','2024-08-18'),
('DGL-T038','RIV-351WX','Trailer',30,2022,9,'Active','2024-09-21'),
('DGL-T039','RIV-473YZ','Tipper',20,2023,9,'Active','2024-10-07'),
('DGL-T040','KAD-595AB','Trailer',30,2021,10,'Active','2024-09-13');

-- DRIVERS
CREATE TABLE IF NOT EXISTS drivers (
    id INTEGER PRIMARY KEY,
    driver_id TEXT UNIQUE NOT NULL,
    full_name TEXT NOT NULL,
    phone TEXT,
    license_class TEXT,
    license_expiry TEXT,
    depot_id INTEGER REFERENCES depots(id),
    hire_date TEXT,
    status TEXT DEFAULT 'Active',
    safety_score REAL DEFAULT 95.0
);

INSERT INTO drivers (driver_id, full_name, phone, license_class, license_expiry, depot_id, hire_date, status, safety_score) VALUES
('DRV-001','Adebayo Ogunlade','08031234567','Class E','2025-06-15',1,'2019-03-10','Active',97),
('DRV-002','Chukwuma Okafor','08052345678','Class E','2025-09-20',1,'2020-01-15','Active',94),
('DRV-003','Ibrahim Musa','08063456789','Class E','2025-03-12',2,'2018-07-01','Active',98),
('DRV-004','Oluwaseun Adeyemi','08074567890','Class E','2026-01-30',1,'2021-05-20','Active',91),
('DRV-005','Yakubu Suleiman','08085678901','Class E','2025-11-08',7,'2019-11-12','Active',96),
('DRV-006','Emeka Nwosu','08096789012','Class D','2025-04-22',9,'2020-06-18','Active',89),
('DRV-007','Abdullahi Bello','08107890123','Class E','2025-08-14',2,'2017-09-05','Active',99),
('DRV-008','Olumide Bakare','08118901234','Class E','2025-12-01',4,'2021-02-28','Active',93),
('DRV-009','Usman Garba','08129012345','Class E','2025-05-19',8,'2019-08-22','Active',95),
('DRV-010','Ikechukwu Eze','08130123456','Class D','2025-07-07',3,'2020-04-14','Active',88),
('DRV-011','Tunde Afolabi','08141234567','Class E','2026-02-28',1,'2022-01-10','Active',92),
('DRV-012','Aminu Yusuf','08152345678','Class E','2025-10-15',7,'2018-12-03','Active',97),
('DRV-013','Chijioke Nnadi','08163456789','Class D','2025-06-30',3,'2020-09-25','Active',86),
('DRV-014','Segun Oladipo','08174567890','Class E','2025-04-11',5,'2019-05-17','Active',94),
('DRV-015','Murtala Abubakar','08185678901','Class E','2024-12-20',8,'2017-11-08','Active',96),
('DRV-016','Obinna Chukwu','08196789012','Class E','2025-09-05',9,'2021-07-14','Active',90),
('DRV-017','Kabiru Danjuma','08207890123','Class E','2025-11-22',10,'2020-03-30','Active',93),
('DRV-018','Femi Oyelaran','08218901234','Class D','2025-08-18',4,'2019-10-02','Active',87),
('DRV-019','Hassan Lawal','08229012345','Class E','2026-01-14',2,'2022-04-19','Active',95),
('DRV-020','Nnamdi Okeke','08230123456','Class E','2025-03-27',6,'2018-06-11','Active',91),
('DRV-021','Taiwo Adeniyi','08241234567','Class E','2025-07-09',1,'2020-08-06','Active',94),
('DRV-022','Bashir Mohammed','08252345678','Class E','2025-12-16',7,'2019-01-23','Active',98),
('DRV-023','Sunday Okonkwo','08263456789','Class D','2025-05-04',6,'2021-09-13','Active',85),
('DRV-024','Ahmed Bala','08274567890','Class E','2025-10-28',5,'2018-04-07','Active',96),
('DRV-025','Gbenga Ajayi','08285678901','Class E','2025-02-13',8,'2020-11-20','Active',92),
('DRV-026','Yusuf Abdulrazaq','08296789012','Class E','2025-06-25',10,'2019-07-15','On Leave',94),
('DRV-027','Emmanuel Udoh','08307890123','Class D','2025-09-11',9,'2022-02-08','Active',88),
('DRV-028','Aliyu Waziri','08318901234','Class E','2025-04-30',7,'2017-12-19','Active',97),
('DRV-029','Jide Alabi','08329012345','Class E','2025-11-06',4,'2021-06-24','Active',90),
('DRV-030','Sani Abubakar','08330123456','Class E','2025-08-22',2,'2020-10-31','Suspended',72);

-- CUSTOMERS
CREATE TABLE IF NOT EXISTS customers (
    id INTEGER PRIMARY KEY,
    name TEXT NOT NULL,
    customer_type TEXT NOT NULL,
    city TEXT NOT NULL,
    state TEXT NOT NULL,
    region_id INTEGER REFERENCES regions(id),
    contact_person TEXT,
    phone TEXT,
    status TEXT DEFAULT 'Active'
);

INSERT INTO customers VALUES
(1,'JBI Construction Ltd','Construction','Lagos','Lagos',1,'Ade Johnson','08011111111','Active'),
(2,'Niger State Housing Corp','Government','Minna','Niger',4,'Salihu Bala','08022222222','Active'),
(3,'Abuja Metro Builders','Construction','Abuja','FCT',4,'Frank Ojo','08033333333','Active'),
(4,'Kano Building Supplies','Distributor','Kano','Kano',5,'Musa Dantata','08044444444','Active'),
(5,'Lagos Materials Hub','Distributor','Lagos','Lagos',1,'Shade Oni','08055555555','Active'),
(6,'PH Builders Depot','Distributor','Port Harcourt','Rivers',2,'Emeka Obi','08066666666','Active'),
(7,'Onitsha Wholesale Market','Wholesale','Onitsha','Anambra',3,'Chidi Nnamdi','08077777777','Active'),
(8,'Ibadan Cement Depot','Distributor','Ibadan','Oyo',1,'Kunle Bello','08088888888','Active'),
(9,'Kaduna Agro Supplies','Agriculture','Kaduna','Kaduna',5,'Isa Yusuf','08099999999','Active'),
(10,'Enugu Building Corp','Construction','Enugu','Enugu',3,'Nneka Ofor','08010101010','Active'),
(11,'Benin Hardware Central','Retail','Benin City','Edo',2,'Pat Osagie','08020202020','Active'),
(12,'Maiduguri Supply Chain','Distributor','Maiduguri','Borno',6,'Abubakar Shettima','08030303030','Active'),
(13,'Jos Plateau Distributors','Distributor','Jos','Plateau',4,'Daniel Pam','08040404040','Active'),
(14,'Ilorin Trading Company','Wholesale','Ilorin','Kwara',4,'Abdulahi Lawal','08050505050','Active'),
(15,'Sokoto Farms & Feeds','Agriculture','Sokoto','Sokoto',5,'Usman Kebbi','08060606060','Active'),
(16,'Warri Industrial Supplies','Industrial','Warri','Delta',2,'Ovie Mukoro','08070707070','Active'),
(17,'Abeokuta Cement Depot','Distributor','Abeokuta','Ogun',1,'Bisi Akande','08080808080','Active'),
(18,'Calabar Port Services','Logistics','Calabar','Cross River',2,'Edet Bassey','08090909090','Active'),
(19,'Owerri Metro Supplies','Distributor','Owerri','Imo',3,'Kelechi Ibe','08001010101','Active'),
(20,'Bauchi General Trading','Wholesale','Bauchi','Bauchi',6,'Bala Muhd','08002020202','Active');

-- DELIVERIES
CREATE TABLE IF NOT EXISTS deliveries (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    delivery_id TEXT UNIQUE NOT NULL,
    truck_id INTEGER NOT NULL REFERENCES trucks(id),
    driver_id INTEGER NOT NULL REFERENCES drivers(id),
    customer_id INTEGER NOT NULL REFERENCES customers(id),
    route_id INTEGER NOT NULL REFERENCES routes(id),
    product_id INTEGER NOT NULL REFERENCES products(id),
    quantity_tons REAL NOT NULL CHECK(quantity_tons > 0),
    revenue REAL NOT NULL CHECK(revenue > 0),
    fuel_cost REAL NOT NULL,
    toll_cost REAL NOT NULL,
    driver_allowance REAL NOT NULL,
    other_cost REAL DEFAULT 0,
    departure_date TEXT NOT NULL,
    arrival_date TEXT,
    status TEXT DEFAULT 'Completed',
    on_time INTEGER DEFAULT 1,
    customer_rating INTEGER DEFAULT 4
);

INSERT INTO deliveries (delivery_id, truck_id, driver_id, customer_id, route_id, product_id, quantity_tons, revenue, fuel_cost, toll_cost, driver_allowance, other_cost, departure_date, arrival_date, status, on_time, customer_rating) VALUES
('DEL-2024-001', 1, 1, 1, 1, 1, 28, 2380000, 45000, 2500, 15000, 2000, '2024-10-01', '2024-10-01', 'Completed', 1, 5),
('DEL-2024-002', 2, 2, 5, 4, 4, 15, 6300000, 120000, 15000, 25000, 5000, '2024-10-02', '2024-10-03', 'Completed', 1, 4),
('DEL-2024-003', 3, 3, 3, 3, 2, 25, 2000000, 85000, 4000, 20000, 3000, '2024-10-02', '2024-10-03', 'Completed', 0, 3),
('DEL-2024-004', 4, 4, 8, 2, 1, 30, 2550000, 55000, 1500, 18000, 2500, '2024-10-03', '2024-10-03', 'Completed', 1, 5),
('DEL-2024-005', 5, 5, 4, 7, 7, 20, 5600000, 110000, 12000, 22000, 4000, '2024-10-03', '2024-10-04', 'Completed', 1, 4),
('DEL-2024-006', 9, 7, 13, 13, 3, 22, 1716000, 65000, 3500, 18000, 2500, '2024-10-04', '2024-10-04', 'Completed', 1, 4),
('DEL-2024-007', 10, 19, 2, 8, 1, 28, 2380000, 48000, 3000, 16000, 2000, '2024-10-04', '2024-10-05', 'Completed', 0, 3),
('DEL-2024-008', 15, 10, 10, 11, 2, 20, 1600000, 55000, 4000, 17000, 3000, '2024-10-05', '2024-10-05', 'Completed', 1, 4),
('DEL-2024-009', 16, 13, 19, 11, 3, 18, 1404000, 50000, 4000, 16000, 2500, '2024-10-05', '2024-10-06', 'Completed', 1, 5),
('DEL-2024-010', 19, 8, 5, 4, 4, 25, 10500000, 180000, 15000, 30000, 6000, '2024-10-06', '2024-10-07', 'Completed', 1, 5),
('DEL-2024-011', 20, 18, 16, 9, 5, 20, 3000000, 75000, 5000, 20000, 3500, '2024-10-06', '2024-10-07', 'Completed', 0, 3),
('DEL-2024-012', 23, 14, 17, 2, 1, 24, 2040000, 50000, 1500, 15000, 2000, '2024-10-07', '2024-10-07', 'Completed', 1, 4),
('DEL-2024-013', 26, 20, 15, 15, 8, 22, 5500000, 145000, 7000, 25000, 5000, '2024-10-07', '2024-10-08', 'Completed', 1, 4),
('DEL-2024-014', 27, 23, 9, 8, 7, 18, 5040000, 60000, 3000, 18000, 3000, '2024-10-08', '2024-10-08', 'Completed', 1, 5),
('DEL-2024-015', 30, 5, 12, 10, 8, 20, 5000000, 125000, 8000, 22000, 4500, '2024-10-08', '2024-10-09', 'Completed', 0, 3);

-- FUEL LOGS
CREATE TABLE IF NOT EXISTS fuel_logs (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    truck_id INTEGER NOT NULL REFERENCES trucks(id),
    delivery_id INTEGER REFERENCES deliveries(id),
    log_date TEXT NOT NULL,
    liters REAL NOT NULL CHECK(liters > 0),
    cost_per_liter REAL NOT NULL CHECK(cost_per_liter > 0),
    total_cost REAL NOT NULL CHECK(total_cost > 0),
    odometer_km REAL
);

INSERT INTO fuel_logs (truck_id, delivery_id, log_date, liters, cost_per_liter, total_cost, odometer_km) VALUES
(1, 1, '2024-10-01', 150, 1200, 180000, 45000),
(2, 2, '2024-10-02', 400, 1250, 500000, 78000),
(3, 3, '2024-10-02', 280, 1200, 336000, 62000),
(4, 4, '2024-10-03', 180, 1220, 219600, 35000),
(5, 5, '2024-10-03', 360, 1240, 446400, 89000),
(9, 6, '2024-10-04', 220, 1210, 266200, 42000),
(10, 7, '2024-10-04', 160, 1230, 196800, 38000),
(15, 8, '2024-10-05', 185, 1200, 222000, 55000),
(16, 9, '2024-10-05', 170, 1220, 207400, 48000),
(19, 10, '2024-10-06', 600, 1250, 750000, 102000),
(20, 11, '2024-10-06', 250, 1210, 302500, 67000),
(23, 12, '2024-10-07', 165, 1200, 198000, 29000),
(26, 13, '2024-10-07', 480, 1240, 595200, 115000),
(27, 14, '2024-10-08', 200, 1230, 246000, 43000),
(30, 15, '2024-10-08', 420, 1250, 525000, 98000);

-- MAINTENANCE LOGS
CREATE TABLE IF NOT EXISTS maintenance_logs (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    truck_id INTEGER NOT NULL REFERENCES trucks(id),
    log_date TEXT NOT NULL,
    type TEXT NOT NULL,
    description TEXT,
    cost REAL NOT NULL CHECK(cost >= 0),
    downtime_hours INTEGER DEFAULT 0,
    vendor TEXT
);

INSERT INTO maintenance_logs (truck_id, log_date, type, description, cost, downtime_hours, vendor) VALUES
(7, '2024-10-15', 'Preventive', 'Oil change and filter replacement', 45000, 4, 'Dangote Workshop'),
(13, '2024-10-14', 'Repair', 'Brake pad replacement', 75000, 6, 'Apex Auto Services'),
(6, '2024-10-10', 'Preventive', 'Engine tuning and oil change', 55000, 5, 'Dangote Workshop'),
(18, '2024-10-05', 'Repair', 'Transmission repair', 120000, 12, 'Transmission Experts Ltd'),
(25, '2024-10-12', 'Preventive', 'Tire rotation and balancing', 35000, 3, 'Tire Masters'),
(33, '2024-10-08', 'Repair', 'AC system repair', 40000, 4, 'Auto Cool Services'),
(38, '2024-10-09', 'Preventive', 'Brake inspection and fluid change', 25000, 2, 'Dangote Workshop'),
(40, '2024-10-11', 'Repair', 'Electrical system diagnosis', 30000, 3, 'Electro Auto Services'),
(11, '2024-10-13', 'Preventive', 'Suspension check and lubrication', 28000, 3, 'Dangote Workshop'),
(22, '2024-10-07', 'Repair', 'Clutch replacement', 95000, 8, 'Transmission Experts Ltd');

-- INCIDENTS
CREATE TABLE IF NOT EXISTS incidents (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    incident_date TEXT NOT NULL,
    truck_id INTEGER NOT NULL REFERENCES trucks(id),
    driver_id INTEGER NOT NULL REFERENCES drivers(id),
    type TEXT NOT NULL,
    severity TEXT NOT NULL,
    description TEXT,
    location TEXT,
    injuries INTEGER DEFAULT 0 CHECK(injuries >= 0),
    damage_cost REAL DEFAULT 0 CHECK(damage_cost >= 0),
    resolved INTEGER DEFAULT 1
);

INSERT INTO incidents (incident_date, truck_id, driver_id, type, severity, description, location, injuries, damage_cost, resolved) VALUES
('2024-09-15', 18, 10, 'Accident', 'High', 'Collision with another truck', 'Lagos-Ibadan Expressway', 0, 250000, 1),
('2024-09-22', 25, 14, 'Breakdown', 'Medium', 'Engine overheating', 'Abuja-Kaduna road', 0, 45000, 1),
('2024-09-28', 33, 22, 'Theft', 'High', 'Fuel theft during night parking', 'Kano', 0, 120000, 1),
('2024-10-02', 7, 11, 'Accident', 'Medium', 'Minor collision with barrier', 'Ibese plant gate', 0, 35000, 1),
('2024-10-05', 13, 3, 'Breakdown', 'Low', 'Flat tire', 'Obajana', 0, 15000, 1),
('2024-10-08', 30, 5, 'Accident', 'Medium', 'Rear-ended at traffic light', 'Kano city', 1, 180000, 0),
('2024-10-10', 38, 16, 'Cargo Issue', 'Medium', 'Partial cargo spillage', 'Port Harcourt', 0, 75000, 1),
('2024-10-12', 40, 17, 'Breakdown', 'Low', 'Battery failure', 'Kaduna', 0, 25000, 1);

-- COMPLAINTS
CREATE TABLE IF NOT EXISTS complaints (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    complaint_date TEXT NOT NULL,
    customer_id INTEGER NOT NULL REFERENCES customers(id),
    delivery_id INTEGER NOT NULL REFERENCES deliveries(id),
    category TEXT NOT NULL,
    description TEXT,
    severity TEXT DEFAULT 'Medium',
    resolved INTEGER DEFAULT 1,
    resolution_days INTEGER DEFAULT 2
);

INSERT INTO complaints (complaint_date, customer_id, delivery_id, category, description, severity, resolved, resolution_days) VALUES
('2024-10-04', 3, 3, 'Late Delivery', 'Delivery arrived 1 day late', 'Medium', 1, 2),
('2024-10-05', 4, 5, 'Product Quality', 'Fertilizer bags slightly damaged', 'High', 1, 3),
('2024-10-06', 2, 7, 'Late Delivery', 'Delayed by 1 day', 'Medium', 1, 1),
('2024-10-07', 16, 11, 'Driver Conduct', 'Driver was rude at delivery point', 'Low', 1, 2),
('2024-10-08', 5, 2, 'Billing', 'Incorrect invoice amount', 'Medium', 1, 2),
('2024-10-09', 12, 15, 'Late Delivery', 'Arrived 2 days late', 'High', 0, 0),
('2024-10-09', 8, 4, 'Product Shortage', 'Short by 2 tons', 'High', 1, 2),
('2024-10-10', 19, 9, 'Documentation', 'Missing waybill', 'Medium', 1, 1);

-- Add indexes for better performance
CREATE INDEX idx_deliveries_truck_id ON deliveries(truck_id);
CREATE INDEX idx_deliveries_driver_id ON deliveries(driver_id);
CREATE INDEX idx_deliveries_customer_id ON deliveries(customer_id);
CREATE INDEX idx_deliveries_departure_date ON deliveries(departure_date);
CREATE INDEX idx_fuel_logs_truck_id ON fuel_logs(truck_id);
CREATE INDEX idx_maintenance_logs_truck_id ON maintenance_logs(truck_id);
CREATE INDEX idx_incidents_truck_id ON incidents(truck_id);
CREATE INDEX idx_incidents_driver_id ON incidents(driver_id);
CREATE INDEX idx_complaints_delivery_id ON complaints(delivery_id);

-- Verification queries (optional - run these to verify data)
SELECT 'Trucks Count: ' || COUNT(*) FROM trucks;
SELECT 'Drivers Count: ' || COUNT(*) FROM drivers;
SELECT 'Deliveries Count: ' || COUNT(*) FROM deliveries;
SELECT 'Fuel Logs Count: ' || COUNT(*) FROM fuel_logs;
SELECT 'Maintenance Logs Count: ' || COUNT(*) FROM maintenance_logs;
SELECT 'Incidents Count: ' || COUNT(*) FROM incidents;
SELECT 'Complaints Count: ' || COUNT(*) FROM complaints;