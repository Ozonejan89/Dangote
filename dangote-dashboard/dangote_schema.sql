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
    truck_id INTEGER REFERENCES trucks(id),
    driver_id INTEGER REFERENCES drivers(id),
    customer_id INTEGER REFERENCES customers(id),
    route_id INTEGER REFERENCES routes(id),
    product_id INTEGER REFERENCES products(id),
    quantity_tons REAL NOT NULL,
    revenue REAL NOT NULL,
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

-- FUEL LOGS
CREATE TABLE IF NOT EXISTS fuel_logs (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    truck_id INTEGER REFERENCES trucks(id),
    delivery_id INTEGER REFERENCES deliveries(id),
    log_date TEXT NOT NULL,
    liters REAL NOT NULL,
    cost_per_liter REAL NOT NULL,
    total_cost REAL NOT NULL,
    odometer_km REAL
);

-- MAINTENANCE LOGS
CREATE TABLE IF NOT EXISTS maintenance_logs (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    truck_id INTEGER REFERENCES trucks(id),
    log_date TEXT NOT NULL,
    type TEXT NOT NULL,
    description TEXT,
    cost REAL NOT NULL,
    downtime_hours INTEGER DEFAULT 0,
    vendor TEXT
);

-- INCIDENTS
CREATE TABLE IF NOT EXISTS incidents (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    incident_date TEXT NOT NULL,
    truck_id INTEGER REFERENCES trucks(id),
    driver_id INTEGER REFERENCES drivers(id),
    type TEXT NOT NULL,
    severity TEXT NOT NULL,
    description TEXT,
    location TEXT,
    injuries INTEGER DEFAULT 0,
    damage_cost REAL DEFAULT 0,
    resolved INTEGER DEFAULT 1
);

-- COMPLAINTS
CREATE TABLE IF NOT EXISTS complaints (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    complaint_date TEXT NOT NULL,
    customer_id INTEGER REFERENCES customers(id),
    delivery_id INTEGER REFERENCES deliveries(id),
    category TEXT NOT NULL,
    description TEXT,
    severity TEXT DEFAULT 'Medium',
    resolved INTEGER DEFAULT 1,
    resolution_days INTEGER DEFAULT 2
);
