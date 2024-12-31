import csv
import random
from faker import Faker
from datetime import datetime, timedelta

# Tạo instance của Faker
fake = Faker()
Faker.seed(0)
random.seed(0)

# Đọc dữ liệu từ file CSV
def read_csv(file_name):
    with open(file_name, mode='r', encoding='utf-8') as file:
        reader = csv.DictReader(file)
        return [row for row in reader]

# Ghi dữ liệu xuống file CSV
def write_to_csv(file_name, data):
    fieldnames = ['DATE_ACCESSED', 'TIME_ACCESSED', 'CUSTOMER_ID', 'SESSION_DURATION']
    with open(file_name, mode='w', encoding='utf-8', newline='') as file:
        writer = csv.DictWriter(file, fieldnames=fieldnames)
        writer.writeheader()
        writer.writerows(data)

# Đọc dữ liệu từ file CSV
account_data = read_csv('account_data.csv')
employee_data = read_csv('employee_data.csv')

# Lấy danh sách customer_id và nhân bản để mỗi customer_id xuất hiện 5 lần
customer_ids = [row['CUSTOMER_ID'] for row in account_data if row['CUSTOMER_ID']]
customer_ids = customer_ids * 5

# Lấy start_date_work nhỏ nhất từ employee_data.csv
start_date_works = [datetime.strptime(row['START_DATE_WORK'], '%Y-%m-%d') for row in employee_data if row['START_DATE_WORK']]
start_date_work_min = min(start_date_works)

# Hàm random date_accessed theo tỷ lệ 40% trước 1/1/2018 và 60% sau 1/1/2018
def random_date_accessed():
    jan_1_2018 = datetime(2018, 1, 1)
    if random.random() < 0.4:
        return fake.date_between(start_date=start_date_work_min, end_date=jan_1_2018 - timedelta(days=1))
    else:
        return fake.date_between(start_date=jan_1_2018, end_date='today')

# Hàm random time_accessed từ 5:00 sáng đến 11:55 đêm
def random_time_accessed():
    # Random giờ từ 5 đến 23 và phút từ 0 đến 55
    hour = random.randint(5, 23)
    minute = random.randint(0, 55)
    second = random.randint(0, 59)
    return f"{hour:02}:{minute:02}:{second:02}"


# Hàm random session_duration từ 60 đến 5000 (giây)
def random_session_duration():
    return random.randint(60, 5000)

# Tạo dữ liệu cho bảng ONLINE_ACCESS_HISTORY
def generate_online_access_history_data():
    records = []
    used_dates = {}

    for customer_id in customer_ids:
        date_accessed = random_date_accessed()
        # Đảm bảo không trùng date_accessed với cùng customer_id
        while customer_id in used_dates and date_accessed in used_dates[customer_id]:
            date_accessed = random_date_accessed()

        if customer_id not in used_dates:
            used_dates[customer_id] = set()
        used_dates[customer_id].add(date_accessed)

        time_accessed = random_time_accessed()
        session_duration = random_session_duration()

        records.append({
            'DATE_ACCESSED': date_accessed.strftime('%Y-%m-%d'),
            'TIME_ACCESSED': time_accessed,
            'CUSTOMER_ID': customer_id,
            'SESSION_DURATION': session_duration
        })

    return records

# Generate data
online_access_history_data = generate_online_access_history_data()

# Write data to CSV
write_to_csv('online_access_history_data.csv', online_access_history_data)

print("File online_access_history_data.csv đã được tạo thành công.")
