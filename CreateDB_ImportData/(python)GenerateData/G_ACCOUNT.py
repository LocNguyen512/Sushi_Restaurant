import csv
import random
from faker import Faker

fake = Faker()
Faker.seed(0)

# Đọc dữ liệu từ file CSV cho các bảng EMPLOYEE, CUSTOMER, DEPARTMENT
def read_csv_file(file_name):
    with open(file_name, mode='r', encoding='utf-8') as file:
        reader = csv.DictReader(file)
        return list(reader)

employees = read_csv_file('employee_data.csv')
customers = read_csv_file('customer_data.csv')
departments = read_csv_file('department_data.csv')

# Lấy danh sách các nhân viên đủ điều kiện để tạo ACCOUNT
eligible_employees = []
department_roles = {
    "Quan ly": "QUẢN LÝ CHI NHÁNH",
    "Thu ngan": "THU NGÂN",
    "Le tan": "LỄ TÂN"
}
for emp in employees:
    if emp['TERMINATION_DATE'] == "":
        dept = next((dept for dept in departments if dept['DEPARTMENT_ID'] == emp['DEPARTMENT_ID']), None)
        if dept and dept['DEPARTMENT_NAME'] in department_roles:
            emp['ROLE'] = department_roles[dept['DEPARTMENT_NAME']]
            eligible_employees.append(emp)

# Random 100 khách hàng tạo ACCOUNT
customer_accounts = random.sample(customers, 100)

# Tạo ACCOUNT
accounts = []
account_id_counter = 1

# Hàm tạo ACCOUNT_ID
def generate_account_id(counter):
    return f"U{counter:06d}"

# Hàm tạo user_name
existing_usernames = set()
def generate_username():
    while True:
        username = fake.user_name()[:20]
        if username not in existing_usernames:
            existing_usernames.add(username)
            return username

# Tạo account cho nhân viên
for emp in eligible_employees:
    accounts.append({
        'ACCOUNT_ID': generate_account_id(account_id_counter),
        'USER_NAME': generate_username(),
        'PASSWORD': '123',
        'ROLE': emp['ROLE'],
        'CUSTOMER_ID': None,
        'EMPLOYEE_ID': emp['EMPLOYEE_ID']
    })
    account_id_counter += 1

# Tạo account cho khách hàng
for cust in customer_accounts:
    accounts.append({
        'ACCOUNT_ID': generate_account_id(account_id_counter),
        'USER_NAME': generate_username(),
        'PASSWORD': '123',
        'ROLE': 'KHÁCH HÀNG',
        'CUSTOMER_ID': cust['CUSTOMER_ID'],
        'EMPLOYEE_ID': None
    })
    account_id_counter += 1

# Tạo 3 account độc lập với ROLE là QUẢN LÝ CÔNG TY
for _ in range(3):
    accounts.append({
        'ACCOUNT_ID': generate_account_id(account_id_counter),
        'USER_NAME': generate_username(),
        'PASSWORD': '123',
        'ROLE': 'QUẢN LÝ CÔNG TY',
        'CUSTOMER_ID': None,
        'EMPLOYEE_ID': None
    })
    account_id_counter += 1

# Ghi dữ liệu xuống file CSV
output_file = 'account_data.csv'
with open(output_file, mode='w', encoding='utf-8', newline='') as file:
    writer = csv.DictWriter(file, fieldnames=['ACCOUNT_ID', 'USER_NAME', 'PASSWORD', 'ROLE', 'CUSTOMER_ID', 'EMPLOYEE_ID'])
    writer.writeheader()
    writer.writerows(accounts)

print(f"Dữ liệu ACCOUNT đã được ghi vào file {output_file}.")
