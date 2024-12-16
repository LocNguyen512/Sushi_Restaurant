import csv
import random
from faker import Faker

# Khởi tạo Faker và các biến
faker = Faker()
Faker.seed(0)

# Tạo danh sách account_id
account_ids = [f"A{str(i).zfill(3)}" for i in range(1, 101)]

# Đọc dữ liệu từ các file CSV đầu vào
with open('employee_data.csv', encoding='utf-8') as emp_file:
    employee_data = list(csv.DictReader(emp_file))

with open('department_data.csv', encoding='utf-8') as dept_file:
    department_data = list(csv.DictReader(dept_file))

with open('customer_data.csv', encoding='utf-8') as cust_file:
    customer_data = list(csv.DictReader(cust_file))

# Lọc các employee_id từ department_name = "Quản lý chi nhánh"
branch_manager_dept_ids = {
    dept['DEPARTMENT_ID'] for dept in department_data if dept['DEPARTMENT_NAME'] == "Quản lý chi nhánh"
}
branch_manager_employees = [
    emp['EMPLOYEE_ID'] for emp in employee_data if emp['DEPARTMENT_ID'] in branch_manager_dept_ids
]

# Tạo các employee_id và customer_id
selected_branch_managers = random.sample(branch_manager_employees, 15)
remaining_employees = [
    emp['EMPLOYEE_ID'] for emp in employee_data if emp['EMPLOYEE_ID'] not in selected_branch_managers
]
selected_employees = selected_branch_managers + random.sample(remaining_employees, 45)
selected_customers = random.sample(
    [cust['CUSTOMER_ID'] for cust in customer_data], 40
)

# Tạo dữ liệu cho bảng ACCOUNT
accounts = []

for i in range(100):
    account_id = account_ids[i]
    username = faker.unique.user_name()[:15]
    password = '123'

    if i < 60:  # 60 account với employee_id
        employee_id = selected_employees[i]
        customer_id = ''
        if employee_id in selected_branch_managers:
            role = "Quản lý chi nhánh"
        else:
            role = "Nhân viên"
    elif i < 100 - 5:  # 40 account với customer_id
        employee_id = ''
        customer_id = selected_customers[i - 60]
        role = "Khách hàng"
    else:  # 5 account quản lý công ty
        employee_id = ''
        customer_id = ''
        role = "Quản lý công ty"

    accounts.append({
        'ACCOUNT_ID': account_id,
        'USERNAME': username,
        'PASSWORD': password,
        'ROLE': role,
        'EMPLOYEE_ID': employee_id,
        'CUSTOMER_ID': customer_id
    })

# Ghi dữ liệu xuống file CSV
output_file = 'account_data.csv'
with open(output_file, mode='w', encoding='utf-8', newline='') as file:
    writer = csv.DictWriter(file, fieldnames=['ACCOUNT_ID', 'USERNAME', 'PASSWORD', 'ROLE', 'EMPLOYEE_ID', 'CUSTOMER_ID'])
    writer.writeheader()
    writer.writerows(accounts)

print(f"Dữ liệu đã được ghi vào file {output_file}")
