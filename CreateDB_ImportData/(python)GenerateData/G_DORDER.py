import csv
import random
from datetime import datetime, timedelta

# Hàm đọc dữ liệu từ file CSV
def read_csv(file_path):
    data = []
    with open(file_path, mode='r', encoding='utf-8') as file:
        reader = csv.DictReader(file)
        for row in reader:
            data.append(row)
    return data

# Hàm ghi dữ liệu vào file CSV
def write_csv(file_path, data, fieldnames):
    with open(file_path, mode='w', encoding='utf-8', newline='') as file:
        writer = csv.DictWriter(file, fieldnames=fieldnames)
        writer.writeheader()
        writer.writerows(data)

# Hàm tạo dữ liệu DATE_DELIVERY hợp lệ
def generate_date_delivery(order_date):
    order_date = datetime.strptime(order_date, "%Y-%m-%d")
    max_date = order_date + timedelta(days=7)
    return (order_date + timedelta(days=random.randint(0, 7))).strftime("%Y-%m-%d")

# Hàm tạo dữ liệu TIME_DELIVERY hợp lệ
def generate_time_delivery(open_time, close_time):
    open_time = datetime.strptime(open_time, "%H:%M:%S")
    close_time = datetime.strptime(close_time, "%H:%M:%S")
    delta = close_time - open_time
    random_seconds = random.randint(1, delta.seconds - 1)
    delivery_time = open_time + timedelta(seconds=random_seconds)
    return delivery_time.strftime("%H:%M:%S")

# Hàm xử lý tạo file CSV cho bảng DELIVERY_ORDER
def generate_delivery_order(order_file, branch_file, output_file):
    # Đọc dữ liệu từ file ORDER và RESTAURANT_BRANCH
    orders = read_csv(order_file)
    branches = read_csv(branch_file)

    # Tạo dictionary để tra cứu thời gian mở cửa/đóng cửa của chi nhánh
    branch_times = {
        branch['BRANCH_ID']: {
            'OPEN_TIME': branch['OPEN_TIME'],
            'CLOSE_TIME': branch['CLOSE_TIME']
        }
        for branch in branches
    }

    # Tạo dữ liệu cho bảng DELIVERY_ORDER
    delivery_orders = []
    for order in orders:
        if order['ORDER_TYPE'] == 'DELIVERY':
            branch_id = order['BRANCH_ID']
            if branch_id in branch_times:
                date_delivery = generate_date_delivery(order['ORDER_DATE'])
                time_delivery = generate_time_delivery(
                    branch_times[branch_id]['OPEN_TIME'],
                    branch_times[branch_id]['CLOSE_TIME']
                )
                delivery_orders.append({
                    'DORDER_ID': order['ORDER_ID'],
                    'DATE_DELIVERY': date_delivery,
                    'TIME_DELIVERY': time_delivery
                })

    # Ghi dữ liệu ra file CSV
    fieldnames = ['DORDER_ID', 'DATE_DELIVERY', 'TIME_DELIVERY']
    write_csv(output_file, delivery_orders, fieldnames)

# Đường dẫn file CSV
order_file = 'order_data.csv'  # File chứa thông tin của bảng ORDER
branch_file = 'restaurant_branch_data.csv'  # File chứa thông tin của bảng RESTAURANT_BRANCH
output_file = 'dorder_data.csv'  # File xuất dữ liệu cho bảng DELIVERY_ORDER

# Gọi hàm tạo file CSV
generate_delivery_order(order_file, branch_file, output_file)
