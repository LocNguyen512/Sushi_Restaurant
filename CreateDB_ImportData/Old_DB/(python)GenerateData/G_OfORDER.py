import csv
import random
from datetime import datetime


def read_csv(file_path):
    """Read a CSV file and return its content as a list of dictionaries."""
    with open(file_path, mode='r', encoding='utf-8') as file:
        reader = csv.DictReader(file)
        return [row for row in reader]


def generate_employee_rating(total_records):
    """Generate a list of employee ratings based on the given percentage rules."""
    ratings = [5] * int(total_records * 0.6) + \
              [4] * int(total_records * 0.1) + \
              [3] * int(total_records * 0.1) + \
              [2] * int(total_records * 0.1) + \
              [1] * int(total_records * 0.1)
    random.shuffle(ratings)
    return ratings


def find_valid_employee(order_date, branch_id, work_history):
    """Find employees working at a branch during a given date."""
    today = datetime.today()
    valid_employees = []
    for wh in work_history:
        if wh['BRANCH_ID'] == branch_id:
            branch_start_date = datetime.strptime(wh['BRANCH_START_DATE'], '%Y-%m-%d')
            branch_end_date = (
                today if not wh['BRANCH_END_DATE']
                else datetime.strptime(wh['BRANCH_END_DATE'], '%Y-%m-%d')
            )
            if branch_start_date <= order_date <= branch_end_date:
                valid_employees.append(wh['EMPLOYEE_ID'])
    return valid_employees


def create_offline_order_csv(order_file, table_file, online_order_file, work_history_file, output_file):
    """Generate the OFFLINE_ORDER CSV file."""
    # Read CSV files
    orders = read_csv(order_file)
    tables = read_csv(table_file)
    online_orders = read_csv(online_order_file)
    work_history = read_csv(work_history_file)

    # Filter offline orders
    offline_orders = [order for order in orders if order['ORDER_TYPE'] == 'OFFLINE']
    total_records = len(offline_orders)

    # Generate employee ratings
    ratings = generate_employee_rating(total_records)

    # Prepare data for OFFLINE_ORDER
    offline_order_data = []
    used_tables = set()
    rating_index = 0

    for order in offline_orders:
        order_date = datetime.strptime(order['ORDER_DATE'], '%Y-%m-%d')
        order_time = datetime.strptime(order['ORDER_TIME'], '%H:%M:%S').time()
        branch_id = order['BRANCH_ID']

        # Find valid employees for the branch and date
        valid_employees = find_valid_employee(order_date, branch_id, work_history)
        if not valid_employees:
            continue  # Skip if no valid employees found

        # Filter available tables for the branch
        branch_tables = [table['TABLE_NUM'] for table in tables if table['BRANCH_ID'] == branch_id]
        if not branch_tables:
            continue

        # Ensure the table does not conflict with online orders
        valid_tables = branch_tables[:]
        for online_order in online_orders:
            if (online_order['ARRIVAL_DATE'] == order['ORDER_DATE'] and
                    online_order['BRANCH_ID'] == branch_id and
                    datetime.strptime(online_order['ARRIVAL_TIME'], '%H:%M:%S') <= datetime.strptime(order['ORDER_TIME'], '%H:%M:%S')):
                if online_order['TABLE_NUMBER'] in valid_tables:
                    valid_tables.remove(online_order['TABLE_NUMBER'])

        if not valid_tables:
            continue  # Skip if no valid tables are available

        # Randomly pick an employee and a table
        employee_id = random.choice(valid_employees)
        table_num = random.choice(valid_tables)

        # Ensure no duplicate table usage at the same time and branch
        if (table_num, branch_id, order_date, order_time) in used_tables:
            continue
        used_tables.add((table_num, branch_id, order_date, order_time))

        # Check if the rating index exceeds the length of ratings list
        if rating_index >= len(ratings):
            break  # Prevent accessing an invalid index

        # Add data to offline_order_data
        offline_order_data.append({
            'OFORDER_ID': order['ORDER_ID'],  # Keep OFORDER_ID as ORDER_ID for OFFLINE orders
            'TABLE_NUMBER': table_num,
            'EMPLOYEE_ID': employee_id,
            'EMPLOYEE_RATING': ratings[rating_index],
            'BRANCH_ID': branch_id,
        })

        # Increment the rating index
        rating_index += 1

    # Write to CSV
    with open(output_file, mode='w', newline='', encoding='utf-8') as file:
        writer = csv.DictWriter(file, fieldnames=['OFORDER_ID', 'TABLE_NUMBER', 'EMPLOYEE_ID', 'EMPLOYEE_RATING', 'BRANCH_ID'])
        writer.writeheader()
        writer.writerows(offline_order_data)


# File paths (replace these with your file paths)
order_file_path = 'order_data.csv'  # Replace with your ORDER table file path
table_file_path = 'table_data.csv'  # Replace with your TABLE table file path
online_order_file_path = 'oorder_data.csv'  # Replace with your ONLINE_ORDER table file path
work_history_file_path = 'work_history_data.csv'  # Replace with your WORK_HISTORY table file path
output_file_path = 'oforder_data.csv'  # Path to save the output file

# Generate the OFFLINE_ORDER CSV
create_offline_order_csv(order_file_path, table_file_path, online_order_file_path, work_history_file_path, output_file_path)

print(f"Offline orders have been written to: {output_file_path}")
