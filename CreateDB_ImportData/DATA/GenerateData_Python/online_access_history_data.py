import csv
import random
from datetime import datetime, timedelta
from faker import Faker

# Initialize Faker
faker = Faker()
Faker.seed(0)
random.seed(0)

# Helper function to randomize dates
def random_date(start_date, end_date):
    delta = end_date - start_date
    random_days = random.randint(0, delta.days)
    return start_date + timedelta(days=random_days)

# Helper function to randomize time
def random_time():
    hour = random.randint(5, 23)
    minute = random.randint(0, 55)
    return datetime.strptime(f"{hour}:{minute:02}", "%H:%M").time()

# Load data from input files
with open("customer_data.csv", "r", encoding="utf-8") as f:
    customer_reader = csv.DictReader(f)
    customers = list(customer_reader)
    customer_ids = [customer["CUSTOMER_ID"] for customer in customers]

with open("order_data.csv", "r", encoding="utf-8") as f:
    order_reader = csv.DictReader(f)
    orders = list(order_reader)

with open("employee_data.csv", "r", encoding="utf-8") as f:
    employee_reader = csv.DictReader(f)
    employees = list(employee_reader)

# Determine the earliest start date among employees
start_dates = [datetime.strptime(emp["START_DATE_WORK"], "%Y-%m-%d") for emp in employees]
earliest_start_date = min(start_dates)

# Organize orders by customer_id
orders_by_customer = {}
for order in orders:
    if order["ORDER_TYPE"] == "Online":
        customer_id = order["CUSTOMER_ID"]
        if customer_id not in orders_by_customer:
            orders_by_customer[customer_id] = []
        orders_by_customer[customer_id].append({
            "ORDER_DATE": datetime.strptime(order["ORDER_DATE"], "%Y-%m-%d"),
            "ORDER_TIME": datetime.strptime(order["ORDER_TIME"], "%H:%M:%S").time()
        })

# Generate online access history data
online_access_history = []
date_cutoff = datetime(2018, 1, 1)

for customer_id in set(customer_ids):
    customer_orders = orders_by_customer.get(customer_id, [])
    session_durations = [random.randint(60, 36000) for _ in range(5)]
    date_accessed_set = set()

    # Add online order access data
    for i, order in enumerate(customer_orders):
        if i >= 5:
            break
        session_duration = session_durations[i]
        time_accessed = (datetime.combine(datetime.today(), order["ORDER_TIME"]) - timedelta(seconds=session_duration)).time()
        online_access_history.append({
            "DATE_ACCESSED": order["ORDER_DATE"].strftime("%Y-%m-%d"),
            "TIME_ACCESSED": time_accessed.strftime("%H:%M:%S"),
            "CUSTOMER_ID": customer_id,
            "SESSION_DURATION": session_duration
        })
        date_accessed_set.add(order["ORDER_DATE"])

    # Add remaining data for customers with online orders
    while len(date_accessed_set) < 5:
        if random.random() <= 0.4:
            date_accessed = random_date(earliest_start_date, date_cutoff)
        else:
            date_accessed = random_date(date_cutoff + timedelta(days=1), datetime.today())

        if date_accessed not in date_accessed_set:
            session_duration = random.randint(60, 36000)
            time_accessed = random_time()
            online_access_history.append({
                "DATE_ACCESSED": date_accessed.strftime("%Y-%m-%d"),
                "TIME_ACCESSED": time_accessed.strftime("%H:%M:%S"),
                "CUSTOMER_ID": customer_id,
                "SESSION_DURATION": session_duration
            })
            date_accessed_set.add(date_accessed)

    # Add data for customers without online orders
    if not customer_orders:
        while len(date_accessed_set) < 5:
            if random.random() <= 0.4:
                date_accessed = random_date(earliest_start_date, date_cutoff)
            else:
                date_accessed = random_date(date_cutoff + timedelta(days=1), datetime.today())

            if date_accessed not in date_accessed_set:
                session_duration = random.randint(60, 36000)
                time_accessed = random_time()
                online_access_history.append({
                    "DATE_ACCESSED": date_accessed.strftime("%Y-%m-%d"),
                    "TIME_ACCESSED": time_accessed.strftime("%H:%M:%S"),
                    "CUSTOMER_ID": customer_id,
                    "SESSION_DURATION": session_duration
                })
                date_accessed_set.add(date_accessed)

# Write to CSV
with open("online_access_history_data.csv", "w", encoding="utf-8", newline="") as f:
    fieldnames = ["DATE_ACCESSED", "TIME_ACCESSED", "CUSTOMER_ID", "SESSION_DURATION"]
    writer = csv.DictWriter(f, fieldnames=fieldnames)
    writer.writeheader()
    writer.writerows(online_access_history)

print("Data generation complete. Check 'online_access_history_data.csv'.")
