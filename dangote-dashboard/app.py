"""
Dangote Truck Delivery Service — Dashboard Backend
Flask app that initialises a SQLite DB, seeds realistic data, and serves API + dashboard.
"""

from flask import Flask, render_template, jsonify
import sqlite3
import random
import math
from datetime import datetime, timedelta
import os
import json

app = Flask(__name__)
DB_PATH = "dangote_delivery.db"
random.seed(42)

# ──────────────────────────── DATABASE HELPERS ────────────────────────────

def get_db():
    conn = sqlite3.connect(DB_PATH)
    conn.row_factory = sqlite3.Row
    return conn


def query_db(sql, args=(), one=False):
    conn = get_db()
    cur = conn.execute(sql, args)
    rv = [dict(row) for row in cur.fetchall()]
    conn.close()
    return (rv[0] if rv else None) if one else rv


# ──────────────────────────── DATA SEEDING ────────────────────────────

def init_db():
    if os.path.exists(DB_PATH):
        os.remove(DB_PATH)
    conn = sqlite3.connect(DB_PATH)
    conn.row_factory = sqlite3.Row
    with open("dangote_schema.sql", "r") as f:
        conn.executescript(f.read())
    seed_deliveries(conn)
    seed_maintenance(conn)
    seed_incidents(conn)
    seed_complaints(conn)
    conn.commit()
    conn.close()
    print("✅  Database initialised with seed data.")


def seed_deliveries(conn):
    cur = conn.cursor()
    routes = [dict(r) for r in conn.execute("SELECT * FROM routes").fetchall()]
    products = [dict(p) for p in conn.execute("SELECT * FROM products").fetchall()]

    # Weights: cement-heavy product mix
    product_weights = [1,1,1,1,1,2,2,3,4,4,4,5,6,7,7,8,9,10]

    did = 0
    for month_offset in range(12):  # Jan–Dec 2024
        base = 280 + month_offset * 8
        n = base + random.randint(-15, 15)
        for _ in range(n):
            did += 1
            d_id = f"DEL-2024-{did:05d}"
            truck = random.randint(1, 40)
            driver = random.randint(1, 29)  # skip #30 (suspended)
            customer = random.randint(1, 20)
            route = random.choice(routes)
            prod = products[random.choice(product_weights) - 1]

            cap_map = {"Trailer": 30, "Flatbed": 25, "Tipper": 20, "Tanker": 30, "Box Truck": 15}
            truck_row = conn.execute("SELECT type FROM trucks WHERE id=?", (truck,)).fetchone()
            truck_type = truck_row[0] if truck_row else "Trailer"
            capacity = cap_map.get(truck_type, 30)
            qty = round(random.uniform(capacity * 0.6, capacity), 1)

            revenue = round(qty * prod["price_per_ton"] * random.uniform(0.95, 1.08))
            km = route["distance_km"]
            fuel_rate = random.uniform(0.35, 0.45)  # litres per km heavy truck
            litres = round(km * fuel_rate, 1)
            fuel_price = random.uniform(650, 750)  # ₦ per litre
            fuel_cost = round(litres * fuel_price)
            toll = route["toll_cost"]
            allow = round(random.uniform(8000, 25000) * (km / 300))
            other = round(random.uniform(2000, 12000))

            dep_day = random.randint(1, 28)
            dep = datetime(2024, month_offset + 1, dep_day, random.randint(4, 10), 0)
            eta_hrs = route["estimated_hours"] * random.uniform(0.9, 1.3)
            arr = dep + timedelta(hours=eta_hrs)
            on_time = 1 if eta_hrs <= route["estimated_hours"] * 1.15 else 0
            rating = random.choices([3, 4, 5], weights=[10, 35, 55])[0]
            status_pick = random.choices(
                ["Completed", "Completed", "Completed", "In Transit", "Cancelled"],
                weights=[85, 8, 3, 3, 1],
            )[0]
            if month_offset < 11:
                status_pick = "Completed"

            cur.execute(
                """INSERT INTO deliveries
                (delivery_id,truck_id,driver_id,customer_id,route_id,product_id,
                 quantity_tons,revenue,fuel_cost,toll_cost,driver_allowance,other_cost,
                 departure_date,arrival_date,status,on_time,customer_rating)
                VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)""",
                (d_id, truck, driver, customer, route["id"], prod["id"],
                 qty, revenue, fuel_cost, toll, allow, other,
                 dep.strftime("%Y-%m-%d %H:%M"), arr.strftime("%Y-%m-%d %H:%M"),
                 status_pick, on_time, rating),
            )

            # Fuel log
            cur.execute(
                """INSERT INTO fuel_logs
                (truck_id,delivery_id,log_date,liters,cost_per_liter,total_cost,odometer_km)
                VALUES (?,?,?,?,?,?,?)""",
                (truck, did, dep.strftime("%Y-%m-%d"), litres, round(fuel_price, 1),
                 fuel_cost, round(km * random.uniform(0.98, 1.02), 1)),
            )


def seed_maintenance(conn):
    cur = conn.cursor()
    types = [
        ("Routine Service", 120000, 350000),
        ("Tyre Replacement", 200000, 600000),
        ("Engine Repair", 500000, 1800000),
        ("Brake Overhaul", 150000, 400000),
        ("Transmission", 400000, 1200000),
        ("Electrical", 80000, 250000),
        ("Body Work", 100000, 500000),
    ]
    vendors = ["AutoFix Lagos", "Kano Motors", "Abuja Fleet Services",
               "PH Truck Repairs", "Ibadan Diesel Centre", "Kaduna Parts Ltd"]
    for _ in range(75):
        truck = random.randint(1, 40)
        m = random.randint(1, 12)
        d = random.randint(1, 28)
        t = random.choice(types)
        cur.execute(
            """INSERT INTO maintenance_logs (truck_id,log_date,type,description,cost,downtime_hours,vendor)
            VALUES (?,?,?,?,?,?,?)""",
            (truck, f"2024-{m:02d}-{d:02d}", t[0], f"{t[0]} for DGL-T{truck:03d}",
             round(random.uniform(t[1], t[2])), random.randint(4, 72), random.choice(vendors)),
        )


def seed_incidents(conn):
    cur = conn.cursor()
    types = [
        ("Road Accident", "High"), ("Tyre Burst", "Medium"), ("Cargo Damage", "Medium"),
        ("Road Robbery", "High"), ("Near Miss", "Low"), ("Brake Failure", "High"),
        ("Driver Fatigue", "Medium"), ("Overloading", "Low"),
    ]
    locations = ["Lagos-Ibadan Expressway", "Abuja-Lokoja Road", "Kano-Zaria Road",
                 "Benin-Ore Road", "Enugu-Onitsha Road", "PH-Aba Expressway",
                 "Kaduna-Abuja Highway", "Lagos-Abeokuta Road"]
    for _ in range(30):
        m = random.randint(1, 12)
        d = random.randint(1, 28)
        t = random.choice(types)
        cur.execute(
            """INSERT INTO incidents (incident_date,truck_id,driver_id,type,severity,
            description,location,injuries,damage_cost,resolved)
            VALUES (?,?,?,?,?,?,?,?,?,?)""",
            (f"2024-{m:02d}-{d:02d}", random.randint(1, 40), random.randint(1, 29),
             t[0], t[1], f"{t[0]} incident on route", random.choice(locations),
             random.randint(0, 2) if t[1] == "High" else 0,
             round(random.uniform(50000, 3000000)) if t[1] != "Low" else 0,
             random.choice([0, 1, 1, 1])),
        )


def seed_complaints(conn):
    cur = conn.cursor()
    cats = ["Late Delivery", "Damaged Goods", "Wrong Product", "Short Delivery",
            "Poor Communication", "Driver Behavior", "Billing Error"]
    for _ in range(50):
        m = random.randint(1, 12)
        d = random.randint(1, 28)
        cur.execute(
            """INSERT INTO complaints (complaint_date,customer_id,delivery_id,category,
            description,severity,resolved,resolution_days)
            VALUES (?,?,?,?,?,?,?,?)""",
            (f"2024-{m:02d}-{d:02d}", random.randint(1, 20), random.randint(1, 500),
             random.choice(cats), "Customer complaint", random.choice(["Low", "Medium", "High"]),
             random.choice([0, 1, 1, 1]), random.randint(1, 7)),
        )


# ──────────────────────────── DASHBOARD QUERIES ────────────────────────────

def get_dashboard_data():
    data = {}

    # ── Overview KPIs ──
    row = query_db("""
        SELECT COUNT(*) as total_deliveries,
               SUM(revenue) as total_revenue,
               SUM(fuel_cost + toll_cost + driver_allowance + other_cost) as total_cost,
               AVG(on_time)*100 as otd_rate,
               AVG(customer_rating) as avg_rating,
               SUM(quantity_tons) as total_tons
        FROM deliveries WHERE status='Completed'
    """, one=True)
    data["kpis"] = row

    fleet = query_db("""
        SELECT status, COUNT(*) as cnt FROM trucks GROUP BY status
    """)
    data["fleet_status"] = {r["status"]: r["cnt"] for r in fleet}
    data["fleet_total"] = sum(r["cnt"] for r in fleet)

    # ── Monthly Revenue & Delivery Trends ──
    data["monthly_trend"] = query_db("""
        SELECT strftime('%m', departure_date) as month,
               COUNT(*) as deliveries,
               SUM(revenue) as revenue,
               SUM(fuel_cost) as fuel_cost,
               SUM(toll_cost) as toll_cost,
               SUM(driver_allowance) as driver_cost,
               SUM(other_cost) as other_cost,
               SUM(fuel_cost+toll_cost+driver_allowance+other_cost) as total_cost,
               AVG(on_time)*100 as otd_rate,
               SUM(quantity_tons) as tons
        FROM deliveries WHERE status='Completed'
        GROUP BY month ORDER BY month
    """)

    # ── Revenue by Region ──
    data["revenue_by_region"] = query_db("""
        SELECT r.name as region, SUM(d.revenue) as revenue, COUNT(*) as trips
        FROM deliveries d
        JOIN customers c ON d.customer_id = c.id
        JOIN regions r ON c.region_id = r.id
        WHERE d.status='Completed'
        GROUP BY r.name ORDER BY revenue DESC
    """)

    # ── Revenue by Product ──
    data["revenue_by_product"] = query_db("""
        SELECT p.name as product, p.category, SUM(d.revenue) as revenue,
               COUNT(*) as trips, SUM(d.quantity_tons) as tons
        FROM deliveries d JOIN products p ON d.product_id = p.id
        WHERE d.status='Completed'
        GROUP BY p.id ORDER BY revenue DESC
    """)

    # ── Top Customers ──
    data["top_customers"] = query_db("""
        SELECT c.name, c.city, c.customer_type,
               SUM(d.revenue) as revenue, COUNT(*) as trips,
               AVG(d.on_time)*100 as otd, AVG(d.customer_rating) as rating
        FROM deliveries d JOIN customers c ON d.customer_id = c.id
        WHERE d.status='Completed'
        GROUP BY c.id ORDER BY revenue DESC LIMIT 10
    """)

    # ── Top Routes ──
    data["top_routes"] = query_db("""
        SELECT rt.origin||' → '||rt.destination as route, rt.distance_km,
               SUM(d.revenue) as revenue, COUNT(*) as trips,
               AVG(d.on_time)*100 as otd
        FROM deliveries d JOIN routes rt ON d.route_id = rt.id
        WHERE d.status='Completed'
        GROUP BY rt.id ORDER BY revenue DESC LIMIT 10
    """)

    # ── Driver Leaderboard ──
    data["driver_board"] = query_db("""
        SELECT dr.driver_id, dr.full_name, dr.safety_score,
               dep.city as depot_city,
               COUNT(d.id) as trips, SUM(d.revenue) as revenue,
               AVG(d.on_time)*100 as otd, AVG(d.customer_rating) as rating
        FROM deliveries d
        JOIN drivers dr ON d.driver_id = dr.id
        JOIN depots dep ON dr.depot_id = dep.id
        WHERE d.status='Completed' AND dr.status='Active'
        GROUP BY dr.id ORDER BY (AVG(d.on_time)*50 + dr.safety_score*0.3 + AVG(d.customer_rating)*4) DESC
        LIMIT 12
    """)

    # ── Fleet Detail ──
    data["truck_detail"] = query_db("""
        SELECT t.truck_id, t.type, t.status, t.capacity_tons, t.year_acquired,
               dep.city as depot,
               COUNT(d.id) as trips, COALESCE(SUM(d.revenue),0) as revenue,
               COALESCE(SUM(fl.liters),0) as total_fuel_l,
               COALESCE(SUM(fl.odometer_km),0) as total_km
        FROM trucks t
        LEFT JOIN depots dep ON t.depot_id = dep.id
        LEFT JOIN deliveries d ON d.truck_id = t.id AND d.status='Completed'
        LEFT JOIN fuel_logs fl ON fl.truck_id = t.id
        GROUP BY t.id ORDER BY revenue DESC LIMIT 12
    """)

    # ── Safety ──
    data["incidents_by_type"] = query_db("""
        SELECT type, COUNT(*) as cnt, SUM(damage_cost) as cost
        FROM incidents GROUP BY type ORDER BY cnt DESC
    """)

    data["incidents_monthly"] = query_db("""
        SELECT strftime('%m', incident_date) as month,
               COUNT(*) as total,
               SUM(CASE WHEN severity='High' THEN 1 ELSE 0 END) as high,
               SUM(CASE WHEN severity='Medium' THEN 1 ELSE 0 END) as medium,
               SUM(CASE WHEN severity='Low' THEN 1 ELSE 0 END) as low
        FROM incidents GROUP BY month ORDER BY month
    """)

    data["safety_kpis"] = query_db("""
        SELECT COUNT(*) as total_incidents,
               SUM(injuries) as total_injuries,
               SUM(damage_cost) as total_damage,
               SUM(CASE WHEN resolved=1 THEN 1 ELSE 0 END) as resolved
        FROM incidents
    """, one=True)

    # ── Maintenance ──
    data["maintenance_summary"] = query_db("""
        SELECT type, COUNT(*) as cnt, SUM(cost) as total_cost,
               AVG(cost) as avg_cost, SUM(downtime_hours) as downtime
        FROM maintenance_logs GROUP BY type ORDER BY total_cost DESC
    """)

    data["maintenance_monthly"] = query_db("""
        SELECT strftime('%m', log_date) as month,
               COUNT(*) as jobs, SUM(cost) as cost
        FROM maintenance_logs GROUP BY month ORDER BY month
    """)

    # ── Complaints ──
    data["complaints_by_cat"] = query_db("""
        SELECT category, COUNT(*) as cnt,
               SUM(CASE WHEN resolved=1 THEN 1 ELSE 0 END) as resolved
        FROM complaints GROUP BY category ORDER BY cnt DESC
    """)

    data["complaints_monthly"] = query_db("""
        SELECT strftime('%m', complaint_date) as month, COUNT(*) as cnt
        FROM complaints GROUP BY month ORDER BY month
    """)

    # ── Cost breakdown totals ──
    data["cost_totals"] = query_db("""
        SELECT SUM(fuel_cost) as fuel, SUM(toll_cost) as tolls,
               SUM(driver_allowance) as driver, SUM(other_cost) as other
        FROM deliveries WHERE status='Completed'
    """, one=True)

    maint_total = query_db("SELECT COALESCE(SUM(cost),0) as t FROM maintenance_logs", one=True)
    data["cost_totals"]["maintenance"] = maint_total["t"]

    return data


# ──────────────────────────── ROUTES ────────────────────────────

@app.route("/")
def dashboard():
    data = get_dashboard_data()
    return render_template("dashboard.html", data=json.dumps(data, default=str))


@app.route("/api/data")
def api_data():
    return jsonify(get_dashboard_data())


# ──────────────────────────── MAIN ────────────────────────────

if __name__ == "__main__":
    init_db()
    print("🚛  Dangote Delivery Dashboard running at http://127.0.0.1:5000")
    app.run(debug=True, port=5000)
