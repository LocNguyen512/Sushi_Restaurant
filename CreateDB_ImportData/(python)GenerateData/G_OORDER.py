import csv
import random
from datetime import datetime, timedelta

# Hàm đọc dữ liệu từ file CSV
def read_csv(file_path):
    with open(file_path, mode='r', encoding='utf-8') as file:  # Dùng utf-8-sig để xử lý BOM
        reader = csv.DictReader(file)
        return list(reader)

# Hàm ghi dữ liệu vào file CSV
def write_csv(file_path, fieldnames, data):
    with open(file_path, mode='w', encoding='utf-8', newline='') as file:
        writer = csv.DictWriter(file, fieldnames=fieldnames)
        writer.writeheader()
        writer.writerows(data)

# Random thời gian trong khoảng
def random_time(start, end):
    delta = timedelta(seconds=random.randint(0, int((end - start).total_seconds())))
    return (start + delta).time()

# Random ngày trong khoảng
def random_date(start, days):
    return start + timedelta(days=random.randint(0, days))

# Đọc dữ liệu từ file CSV
try:
    order_data = read_csv('order_data.csv')
    table_data = read_csv('table_data.csv')
    branch_data = read_csv('restaurant_branch_data.csv')
except FileNotFoundError as e:
    print(f"Lỗi: {e}")
    exit()

# Kiểm tra các cột bắt buộc
required_table_columns = ['TABLE_NUM', 'BRANCH_ID']
if not all(col in table_data[0] for col in required_table_columns):
    print("File table_data.csv thiếu các cột bắt buộc.")
    exit()

required_order_columns = ['ORDER_ID', 'ORDER_DATE', 'ORDER_TYPE']
if not all(col in order_data[0] for col in required_order_columns):
    print("File order_data.csv thiếu các cột bắt buộc.")
    exit()

required_branch_columns = ['BRANCH_ID', 'OPEN_TIME', 'CLOSE_TIME']
if not all(col in branch_data[0] for col in required_branch_columns):
    print("File restaurant_branch_data.csv thiếu các cột bắt buộc.")
    exit()

# Lọc các order có ORDER_TYPE là 'ONLINE'
online_orders = [order for order in order_data if order['ORDER_TYPE'] == 'ONLINE']

# Tạo dictionary để tra cứu thời gian mở và đóng của các chi nhánh
branch_hours = {
    branch['BRANCH_ID']: (
        datetime.strptime(branch['OPEN_TIME'], '%H:%M:%S').time(),
        datetime.strptime(branch['CLOSE_TIME'], '%H:%M:%S').time()
    )
    for branch in branch_data
}

# Tạo danh sách các cặp TABLE_NUMBER và BRANCH_ID
table_pairs = [
    (int(table['TABLE_NUM']), table['BRANCH_ID'])
    for table in table_data
]

# Khởi tạo dữ liệu bảng ONLINE_ORDER
online_order_data = []
used_dates = {}

for online_order in online_orders:
    oorder_id = online_order['ORDER_ID']
    order_date = datetime.strptime(online_order['ORDER_DATE'], '%Y-%m-%d').date()

    # Chọn ngẫu nhiên cặp TABLE_NUMBER và BRANCH_ID
    table_number, branch_id = random.choice(table_pairs)

    # Random ARRIVAL_DATE trong khoảng từ ORDER_DATE đến ORDER_DATE + 7 ngày
    arrival_date = random_date(order_date, 7)

    # Random ARRIVAL_TIME trong khoảng giờ mở cửa và đóng cửa
    open_time, close_time = branch_hours[branch_id]
    arrival_time = random_time(datetime.combine(arrival_date, open_time), datetime.combine(arrival_date, close_time))

    # Random CUSTOMER_QUANTITY theo TABLE_NUMBER
    if 1 <= table_number <= 25:
        customer_quantity = random.randint(1, 5)
    elif 26 <= table_number <= 50:
        customer_quantity = random.randint(6, 10)
    else:
        customer_quantity = random.randint(1, 10)

    # Đảm bảo không trùng ARRIVAL_DATE và ARRIVAL_TIME cho cùng TABLE_NUMBER và BRANCH_ID
    while (branch_id, table_number, arrival_date, arrival_time) in used_dates:
        arrival_date = random_date(order_date, 7)
        arrival_time = random_time(datetime.combine(arrival_date, open_time), datetime.combine(arrival_date, close_time))

    used_dates[(branch_id, table_number, arrival_date, arrival_time)] = True

    # Thêm bản ghi vào bảng ONLINE_ORDER
    online_order_data.append({
        'OORDER_ID': oorder_id,
        'ARRIVAL_DATE': arrival_date.strftime('%Y-%m-%d'),
        'ARRIVAL_TIME': arrival_time.strftime('%H:%M:%S'),
        'TABLE_NUMBER': table_number,
        'CUSTOMER_QUANTITY': customer_quantity,
        'BRANCH_ID': branch_id
    })

# Ghi dữ liệu vào file CSV
write_csv('oorder_data.csv', [
    'OORDER_ID', 'ARRIVAL_DATE', 'ARRIVAL_TIME', 'TABLE_NUMBER', 'CUSTOMER_QUANTITY', 'BRANCH_ID'
], online_order_data)

print("Dữ liệu cho bảng ONLINE_ORDER đã được tạo thành công.")
