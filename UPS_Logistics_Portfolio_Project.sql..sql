/*
=============================================================================
PROJECT: UPS Logistics Delivery Performance Analysis
AUTHOR: [Nikilesh yadav]
GOAL: Identify delivery bottlenecks, route inefficiencies, and agent performance 
      gaps using SQL window functions, CTEs, and aggregations.
=============================================================================
*/

-- ==========================================
-- PART 1: DATABASE SETUP & MOCK DATA
-- ==========================================
DROP DATABASE IF EXISTS ups_logistics;
CREATE DATABASE ups_logistics;
USE ups_logistics;

CREATE TABLE routes (
    Route_ID VARCHAR(10) PRIMARY KEY,
    Start_Location VARCHAR(50),
    Distance_KM DECIMAL(5,2),
    Average_Travel_Time_Min INT,
    Traffic_Delay_Min INT
);
INSERT INTO routes VALUES 
('R014', 'West Calvinview', 15.5, 45, 58), ('R007', 'Juliestad', 22.0, 60, 51),
('R009', 'Port Tammybury', 8.0, 25, 46), ('R006', 'South Jenniferfurt', 35.0, 90, 42),
('R010', 'New Jessica', 28.5, 70, 40), ('R013', 'Ramosside', 12.0, 30, 38);

CREATE TABLE deliveryagents (
    Agent_ID VARCHAR(10) PRIMARY KEY,
    Route_ID VARCHAR(10),
    On_Time_Percentage DECIMAL(5,2),
    Avg_Speed_KM_HR DECIMAL(5,2)
);
-- Top 5 Agents (Avg Speed ~60) and Bottom 5 (Avg Speed ~36.8) to match your screenshots
INSERT INTO deliveryagents VALUES
('A001', 'R014', 99.00, 62.00), ('A002', 'R007', 98.00, 61.00), ('A003', 'R009', 97.00, 60.00), 
('A004', 'R006', 96.00, 59.00), ('A005', 'R010', 95.00, 58.00), -- Top 5 Average = 60.00
('A006', 'R014', 70.00, 38.00), ('A007', 'R007', 69.00, 37.00), ('A008', 'R009', 68.00, 37.00), 
('A009', 'R006', 67.00, 36.00), ('A010', 'R010', 66.00, 36.00); -- Bottom 5 Average = 36.80

CREATE TABLE warehouses (
    Warehouse_ID VARCHAR(10) PRIMARY KEY,
    Processing_Time_Min INT
);
INSERT INTO warehouses VALUES ('W008', 30), ('W006', 45), ('W002', 120), ('W004', 50);

CREATE TABLE orders (
    Order_ID VARCHAR(10) PRIMARY KEY,
    Route_ID VARCHAR(10),
    Warehouse_ID VARCHAR(10),
    Order_Date DATE,
    Expected_Delivery_Date DATE,
    Actual_Delivery_Date DATE
);
INSERT INTO orders VALUES
('00001', 'R014', 'W008', '2025-06-01', '2025-06-03', '2025-06-03'),
('00002', 'R007', 'W008', '2025-06-01', '2025-06-03', '2025-06-05'),
('00003', 'R009', 'W006', '2025-06-02', '2025-06-04', '2025-06-04'),
('00004', 'R006', 'W006', '2025-06-02', '2025-06-03', '2025-06-06');

CREATE TABLE `shipment tracking table` (
    Tracking_ID INT PRIMARY KEY AUTO_INCREMENT,
    Order_ID VARCHAR(10),
    Checkpoint VARCHAR(100),
    Checkpoint_Time DATE,
    Delay_Reason VARCHAR(100)
);
-- Inserting specific delays so the 'Most Common Delay Reasons' query works
INSERT INTO `shipment tracking table` (Order_ID, Checkpoint, Checkpoint_Time, Delay_Reason) VALUES
('00002', 'Hub', '2025-06-20', 'Sorting Delay'), ('00002', 'Transit', '2025-06-21', 'Sorting Delay'),
('00003', 'Hub', '2025-06-02', 'Weather'), ('00004', 'Transit', '2025-06-25', 'Traffic');

-- ==========================================
-- PART 2: ANALYTICAL QUERIES 
-- ==========================================

-- 1. Average Traffic Delay per Route
SELECT Route_ID, AVG(Traffic_Delay_Min) AS Avg_Traffic_Delay_Min
FROM routes
GROUP BY Route_ID
ORDER BY Avg_Traffic_Delay_Min DESC;

-- 2. Rank Agents (Per Route) by On-Time %
SELECT Agent_ID, Route_ID, On_Time_Percentage,
RANK() OVER (PARTITION BY Route_ID ORDER BY On_Time_Percentage DESC) AS Agent_Rank
FROM deliveryagents;

-- 3. Compare Average Speed of Top 5 vs Bottom 5 Agents
SELECT AVG(Avg_Speed_KM_HR) AS Avg_Speed_Top5 
FROM (
    SELECT Avg_Speed_KM_HR FROM deliveryagents 
    ORDER BY On_Time_Percentage DESC LIMIT 5
) AS top_agents;

SELECT AVG(Avg_Speed_KM_HR) AS Avg_Speed_Bottom5 
FROM (
    SELECT Avg_Speed_KM_HR FROM deliveryagents 
    ORDER BY On_Time_Percentage ASC LIMIT 5
) AS bottom_agents;

-- 4. Most Common Delay Reasons (Excluding 'None')
SELECT Delay_Reason, COUNT(*) AS Occurrences
FROM `shipment tracking table`
WHERE Delay_Reason IS NOT NULL AND Delay_Reason <> 'None'
GROUP BY Delay_Reason
ORDER BY Occurrences DESC;

-- 5. Orders with More Than 2 Delayed Checkpoints
SELECT Order_ID, COUNT(*) AS Delayed_Checkpoints
FROM `shipment tracking table`
WHERE Delay_Reason IS NOT NULL AND Delay_Reason <> 'None'
GROUP BY Order_ID
HAVING COUNT(*) >= 2;