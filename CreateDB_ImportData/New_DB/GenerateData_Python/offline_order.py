import csv
import random
from faker import Faker
from datetime import datetime

# Khởi tạo thư viện Faker
fake = Faker()

# Bước 1: Đọc file `order_data.csv` để lấy dữ liệu `order_id` và `order_type` cho các đơn hàng Offline
print("Đang đọc dữ liệu từ order_data.csv...")
order_data = []
with open('order_data.csv', newline='', encoding='utf-8') as f:
    reader = csv.DictReader(f)
    for row in reader:
        if row['ORDER_TYPE'] == 'Offline':
            order_data.append({'ORDER_ID': row['ORDER_ID'], 'ORDER_DATE': row['ORDER_DATE'], 'BRANCH_ID': row['BRANCH_ID']})

print(f"Đã đọc {len(order_data)} đơn hàng Offline từ order_data.csv.")

# Bước 2: Đọc file `table_data.csv` để lấy thông tin bàn
print("Đang đọc dữ liệu từ table_data.csv...")
table_data = {}
with open('table_data.csv', newline='', encoding='utf-8') as f:
    reader = csv.DictReader(f)
    for row in reader:
        branch_id = row['BRANCH_ID']
        if branch_id not in table_data:
            table_data[branch_id] = []
        table_data[branch_id].append({'TABLE_NUM': row['TABLE_NUM'], 'SEAT_AVAILABLE': row['SEAT_AVAILABLE']})

print(f"Đã đọc {len(table_data)} chi nhánh và thông tin bàn từ table_data.csv.")

# Bước 3: Đọc file `work_history.csv` để lấy thông tin về nhân viên làm việc tại các chi nhánh
print("Đang đọc dữ liệu từ work_history.csv...")
work_history_data = {}
with open('work_history_data.csv', newline='', encoding='utf-8') as f:
    reader = csv.DictReader(f)
    for row in reader:
        branch_id = row['BRANCH_ID']
        employee_id = row['EMPLOYEE_ID']
        start_date = datetime.strptime(row['BRANCH_START_DATE'], '%Y-%m-%d')
        end_date = row['BRANCH_END_DATE']
        if end_date:
            end_date = datetime.strptime(end_date, '%Y-%m-%d')
        else:
            end_date = datetime.today()

        if branch_id not in work_history_data:
            work_history_data[branch_id] = []
        work_history_data[branch_id].append({
            'EMPLOYEE_ID': employee_id, 'START_DATE': start_date, 'END_DATE': end_date
        })

print(f"Đã đọc {len(work_history_data)} chi nhánh và thông tin nhân viên từ work_history.csv.")

# Bước 4: Tạo dữ liệu cho bảng OFFLINE_ORDER
print("Đang tạo dữ liệu cho bảng OFFLINE_ORDER...")
offline_order_data = []
for order in order_data:
    order_id = order['ORDER_ID']
    branch_id = order['BRANCH_ID']
    order_date_str = order['ORDER_DATE']
    
    # Kiểm tra và phân tích ORDER_DATE với định dạng SQL DATE
    try:
        order_date = datetime.strptime(order_date_str, '%Y-%m-%d').date()  # Định dạng SQL DATE (YYYY-MM-DD)
    except ValueError:
        print(f"Lỗi định dạng ngày cho ORDER_DATE: {order_date_str}")
        continue  # Bỏ qua đơn hàng nếu không thể phân tích ngày
    
    # Lấy các bàn có cùng branch_id
    available_tables = table_data.get(branch_id, [])
    table_number = random.choice(available_tables)['TABLE_NUM']
    
    # Kiểm tra nếu có đơn hàng Offline khác cùng branch_id và ORDER_TIME, phải khác bàn
    table_conflict = any(o['TABLE_NUMBER'] == table_number and o['BRANCH_ID'] == branch_id and o['ORDER_TIME'] == str(order_date) for o in offline_order_data)
    if table_conflict:
        while table_conflict:
            table_number = random.choice(available_tables)['TABLE_NUM']
            table_conflict = any(o['TABLE_NUMBER'] == table_number and o['BRANCH_ID'] == branch_id and o['ORDER_TIME'] == str(order_date) for o in offline_order_data)

    # Tìm nhân viên làm việc tại chi nhánh và thời gian hợp lệ
    available_employees = work_history_data.get(branch_id, [])
    valid_employees = [e['EMPLOYEE_ID'] for e in available_employees if e['START_DATE'].date() <= order_date <= e['END_DATE'].date()]
    
    if valid_employees:
        employee_id = random.choice(valid_employees)
    else:
        continue  # Bỏ qua nếu không tìm được nhân viên hợp lệ
    
    # Random employee rating theo yêu cầu
    employee_rating = 5 if random.random() <= 0.7 else random.randint(1, 4)

    # Tạo dữ liệu OFFLINE_ORDER
    offline_order_data.append({
        'OFORDER_ID': order_id,
        'TABLE_NUMBER': table_number,
        'EMPLOYEE_ID': employee_id,
        'BRANCH_ID': branch_id,
        'EMPLYEE_RATING': employee_rating,
        'ORDER_TIME': order_date.isoformat()  # SQL DATE định dạng (YYYY-MM-DD)
    })

print(f"Đã tạo {len(offline_order_data)} đơn hàng Offline.")

# Bước 5: Ghi dữ liệu xuống file CSV
print("Đang ghi dữ liệu xuống file offline_order_data.csv...")
header = ['OFORDER_ID', 'TABLE_NUMBER', 'EMPLOYEE_ID', 'BRANCH_ID', 'EMPLYEE_RATING', 'ORDER_TIME']
with open('offline_order_data.csv', mode='w', newline='', encoding='utf-8') as f:
    writer = csv.DictWriter(f, fieldnames=header)
    writer.writeheader()
    for row in offline_order_data:
        writer.writerow(row)

print("Dữ liệu đã được ghi xuống file offline_order_data.csv.")
