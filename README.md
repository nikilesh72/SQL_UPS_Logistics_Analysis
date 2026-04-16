# 📦 UPS Logistics: Delivery Performance & Bottleneck Analysis

A data-driven Business Analyst portfolio project analyzing UPS logistics operations to uncover delivery delays, route inefficiencies, and agent performance gaps. 

**Goal:** Provide actionable operational insights to optimize high-volume delivery speed and improve on-time percentage (OTP).

---

## 🛠 Tech Stack & Skills Demonstrated
* **Database:** MySQL
* **Techniques:** Window Functions (`RANK() OVER`), Common Table Expressions (CTEs), Conditional Aggregation, Multi-table Joins, Date/Time Analytics.
* **Business Skills:** Root Cause Analysis, KPI Dashboarding, Process Optimization.

---

## 🚀 Executive Summary & Business Impact
Through structured SQL analytics, this project identified three major operational bottlenecks:
1. **Traffic-Driven Delays:** Route R014 experiences an average of 58 minutes of traffic delay, making it the highest-friction path in the network.
2. **Agent Performance Discrepancy:** The Top 5 delivery agents average a speed of **60 KM/HR**, while the Bottom 5 average only **36.8 KM/HR**, indicating a need for targeted route reassignment and training.
3. **Warehouse Processing:** Warehouse W002 processing times are significantly lagging compared to top-performing hubs like W008, causing downstream delivery failures.

**Strategic Recommendation:** Implement traffic-aware dynamic routing for the R014 corridor and audit the processing pipeline at Warehouse W002 to immediately lift overall On-Time Delivery percentages.

---

## 📂 Repository Structure

```text
SQL-UPS-Logistics-Analysis
│
├── screenshots/                                  # Dashboard & Query result visualizations
│   ├── delivery_agent_performance.png
│   ├── top_vs_bottom_agents_speed.png
│   ├── agent_ranking_per_route.png
│   ├── shipment_tracking_dashboard.png
│   ├── last_checkpoint_per_order.png
│   ├── orders_multiple_delay_checkpoints.png
│   ├── most_common_delay_reasons.png
│   ├── warehouse_on_time_ranking.png
│   ├── average_traffic_delay_route.png
│   ├── average_delivery_delay_region.png
│   ├── logistics_kpi_dashboard.png
│   ├── business_strategy_recommendations.png
│   └── project_conclusion.png
│
├── README.md                                     # Project documentation
└── UPS_Logistics_Portfolio_Project.sql           # Complete SQL script with mock data
