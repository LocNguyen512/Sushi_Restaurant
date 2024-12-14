from faker import Faker
from datetime import date, timedelta
import csv
import random

# Khởi tạo Faker với ngôn ngữ tiếng Việt
fake = Faker('vi_VN')

# Đọc department_id từ file department_data.csv
def read_department_ids():
    department_data = []
    with open('department_data.csv', 'r', encoding='utf-8') as file:
        reader = csv.DictReader(file)
        for row in reader:
            department_data.append(row)
    return department_data

# Tạo dữ liệu employee
def generate_employee_data(department_data, num_employees=15000):
    employees = []
    department_salaries = {}
    current_date = date.today()  # Lấy ngày hiện tại
    min_start_date = date(2015, 1, 1)  # Ngày 1/1/2015

    # Gán salary cho các department
    for department in department_data:
        department_id = department['DEPARTMENT_ID']
        department_name = department['DEPARTMENT_NAME']

        if department_name == 'Quản lý chi nhánh':
            department_salaries[department_id] = 40000000  # Lương lớn nhất 40 triệu
        else:
            department_salaries[department_id] = random.randint(10000000, 40000000)

    branch_departments = [d for d in department_data if d['DEPARTMENT_NAME'] == 'Quản lý chi nhánh']
    branch_employee_ids = random.sample(range(1, num_employees + 1), len(branch_departments))

    for i in range(1, num_employees + 1):
        employee_id = f"E{i:06d}"
        full_name = fake.name()

        # Random ngày sinh
        dob = fake.date_of_birth(minimum_age=18, maximum_age=45)

        # Xác định START_DATE_WORK
        if random.random() <= 0.8:  # 80% ngày >= 1/1/2015
            start_date = min_start_date + timedelta(days=random.randint(0, (current_date - min_start_date).days))
        else:
            start_date = dob + timedelta(days=18 * 365)  # Tính từ ngày sinh đủ 18 năm
            if start_date >= min_start_date:
                start_date = min_start_date - timedelta(days=random.randint(1, 365))

        # Đảm bảo START_DATE_WORK - DOB >= 18 năm
        if (start_date - dob).days < 18 * 365:
            start_date = dob + timedelta(days=18 * 365)

        # Xác định TERMINATION_DATE
        termination_date = None
        if random.random() > 0.6:  # 40% có giá trị
            termination_date = start_date + timedelta(days=random.randint(1, (45 - 18) * 365))
            # Đảm bảo TERMINATION_DATE - DOB <= 45 năm
            if (termination_date - dob).days > 45 * 365 or termination_date >= current_date:
                termination_date = None

        # Gán department_id
        if i in branch_employee_ids:
            department = branch_departments.pop()
        else:
            department = random.choice(department_data)

        department_id = department['DEPARTMENT_ID']
        salary = department_salaries[department_id]
        gender = random.choice(["Nam", "Nữ"])

        employee = {
            'EMPLOYEE_ID': employee_id,
            'FULL_NAME': full_name,
            'DATE_OF_BIRTH': dob.strftime('%Y-%m-%d'),
            'GENDER': gender,
            'SALARY': salary,
            'START_DATE_WORK': start_date.strftime('%Y-%m-%d'),
            'TERMINATION_DATE': termination_date.strftime('%Y-%m-%d') if termination_date else '',
            'DEPARTMENT_ID': department_id
        }
        employees.append(employee)

    return employees

# Ghi dữ liệu employee ra file CSV
def write_employee_csv(employees, filename='employee_data.csv'):
    with open(filename, 'w', encoding='utf-8', newline='') as file:
        writer = csv.DictWriter(file, fieldnames=[
            'EMPLOYEE_ID', 'FULL_NAME', 'DATE_OF_BIRTH', 'GENDER', 'SALARY',
            'START_DATE_WORK', 'TERMINATION_DATE', 'DEPARTMENT_ID'
        ])
        writer.writeheader()
        writer.writerows(employees)

if __name__ == "__main__":
    department_data = read_department_ids()
    employees = generate_employee_data(department_data)
    write_employee_csv(employees)
    print("File employee_data.csv đã được tạo thành công!")
