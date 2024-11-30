import csv
import random
from faker import Faker

# Khởi tạo Faker
fake = Faker()

# Hàm tạo account_id
def generate_account_id(index):
    return f"U{index:06d}"

# Hàm tạo username không trùng
def generate_unique_usernames(count):
    usernames = set()
    while len(usernames) < count:
        username = fake.user_name()[:25]
        usernames.add(username)
    return list(usernames)

# Đọc file CSV
def read_csv(file_name):
    with open(file_name, mode="r", encoding="utf-8") as file:
        reader = csv.DictReader(file)
        return list(reader)

# Ghi file CSV
def write_csv(file_name, fieldnames, data):
    with open(file_name, mode="w", encoding="utf-8", newline="") as file:
        writer = csv.DictWriter(file, fieldnames=fieldnames)
        writer.writeheader()
        writer.writerows(data)

# Xử lý logic tạo dữ liệu bảng ACCOUNT
def create_account_data(employees, customers, departments):
    accounts = []
    account_id_index = 1

    # Tạo mapping từ department_id sang department_name
    department_mapping = {dept["DEPARTMENT_ID"]: dept["DEPARTMENT_NAME"] for dept in departments}

    # Xử lý nhân viên
    for emp in employees:
        if emp["TERMINATION_DATE"] == "":
            department_name = department_mapping.get(emp["DEPARTMENT_ID"], "")
            if department_name in ["Quan ly", "Thu ngan", "Le tan", "Quan tri he thong"]:
                role = (
                    "Thu ngân" if department_name == "Thu ngan" else
                    "Lễ tân" if department_name == "Le tan" else
                    "Quản lý công ty"
                )
                accounts.append({
                    "ACCOUNT_ID": generate_account_id(account_id_index),
                    "USER_NAME": "",  # Sẽ thêm sau
                    "PASSWORD": fake.password(length=10),
                    "ROLE": role,
                    "CUSTOMER_ID": "",
                    "EMPLOYEE_ID": emp["EMPLOYEE_ID"]
                })
                account_id_index += 1

    # Random 100 khách hàng
    selected_customers = random.sample(customers, 100)
    for cust in selected_customers:
        accounts.append({
            "ACCOUNT_ID": generate_account_id(account_id_index),
            "USER_NAME": "",  # Sẽ thêm sau
            "PASSWORD": fake.password(length=10),
            "ROLE": "Khách hàng",
            "CUSTOMER_ID": cust["CUSTOMER_ID"],
            "EMPLOYEE_ID": ""
        })
        account_id_index += 1

    # Thêm user_name ngẫu nhiên
    usernames = generate_unique_usernames(len(accounts))
    for account, username in zip(accounts, usernames):
        account["USER_NAME"] = username

    return accounts

# Main
if __name__ == "__main__":
    # Đọc dữ liệu từ file CSV
    employees = read_csv("employee_data.csv")
    customers = read_csv("customer_data.csv")
    departments = read_csv("department_data.csv")

    # Tạo dữ liệu ACCOUNT
    accounts = create_account_data(employees, customers, departments)

    # Ghi dữ liệu ra file CSV
    account_fieldnames = ["ACCOUNT_ID", "USER_NAME", "PASSWORD", "ROLE", "CUSTOMER_ID", "EMPLOYEE_ID"]
    write_csv("account_data.csv", account_fieldnames, accounts)

    print("Dữ liệu ACCOUNT đã được tạo và ghi vào file ACCOUNT.csv.")
