import csv
import random
from datetime import datetime, timedelta

# Đường dẫn đến các file CSV
branch_csv_path = "restaurant_branch_data.csv"
customer_csv_path = "customer_data.csv"
work_history_csv_path = "work_history_data.csv"
output_csv_path = "order_data.csv"

# Số lượng dòng dữ liệu
num_rows = 110000

# Đọc dữ liệu từ file WORK_HISTORY
work_history = {}
with open(work_history_csv_path, mode="r", encoding="utf-8") as work_file:
    work_reader = csv.DictReader(work_file)
    for row in work_reader:
        branch_id = row["BRANCH_ID"]
        start_date = datetime.strptime(row["BRANCH_START_DATE"], "%Y-%m-%d").date()
        # Kiểm tra nếu BRANCH_END_DATE là NULL và thay thế bằng ngày hiện tại nếu cần
        end_date_str = row["BRANCH_END_DATE"]
        if end_date_str.upper() == "":
            end_date = datetime.now().date()  # Nếu NULL thì gán là ngày hiện tại
        else:
            end_date = datetime.strptime(end_date_str, "%Y-%m-%d").date()
        
        if branch_id not in work_history:
            work_history[branch_id] = []
        work_history[branch_id].append((start_date, end_date))

# Đọc dữ liệu từ file RESTAURANT_BRANCH
branch_data = {}
with open(branch_csv_path, mode="r", encoding="utf-8") as branch_file:
    branch_reader = csv.DictReader(branch_file)
    for row in branch_reader:
        branch_id = row["BRANCH_ID"]
        open_time = datetime.strptime(row["OPEN_TIME"], "%H:%M:%S").time()
        close_time = datetime.strptime(row["CLOSE_TIME"], "%H:%M:%S").time()
        branch_data[branch_id] = (open_time, close_time)

# Đọc dữ liệu từ file CUSTOMER_ID
with open(customer_csv_path, mode="r", encoding="utf-8") as customer_file:
    customer_reader = csv.reader(customer_file)
    customer_ids = [row[0] for row in customer_reader if row]

# Các giá trị ORDER_TYPE
order_types = ["ONLINE", "OFFLINE", "DELIVERY"]

# Hàm tạo ORDER_ID ngẫu nhiên
def generate_order_id(index):
    return f"O{index:06}"

# Hàm tạo ORDER_DATE dựa trên WORK_HISTORY
def generate_order_date(branch_id):
    if branch_id not in work_history or not work_history[branch_id]:
        raise ValueError(f"Branch ID {branch_id} không có dữ liệu thời gian trong WORK_HISTORY.")
    
    # Lấy ngẫu nhiên một khoảng thời gian từ WORK_HISTORY
    start_date, end_date = random.choice(work_history[branch_id])
    random_date = start_date + timedelta(days=random.randint(0, (end_date - start_date).days))
    return random_date.strftime("%Y-%m-%d")

# Hàm tạo ORDER_TIME ngẫu nhiên dựa trên OPEN_TIME và CLOSE_TIME
def generate_order_time(branch_id):
    open_time, close_time = branch_data[branch_id]
    open_seconds = open_time.hour * 3600 + open_time.minute * 60 + open_time.second
    close_seconds = close_time.hour * 3600 + close_time.minute * 60 + close_time.second
    
    # Tạo thời gian ngẫu nhiên trong khoảng OPEN_TIME và CLOSE_TIME
    random_seconds = random.randint(open_seconds + 1, close_seconds - 1)
    hours, remainder = divmod(random_seconds, 3600)
    minutes, seconds = divmod(remainder, 60)
    return f"{hours:02}:{minutes:02}:{seconds:02}"

# Khởi tạo danh sách kết quả
rows = []

# Tạo các dòng dữ liệu và đảm bảo mỗi CUSTOMER_ID và BRANCH_ID xuất hiện ít nhất 1 lần
branch_customer_mapping = {}

for i in range(num_rows):
    # Đảm bảo mỗi BRANCH_ID xuất hiện ít nhất 1 lần với mỗi ORDER_TYPE
    branch_id = random.choice(list(branch_data.keys()))
    
    # Đảm bảo mỗi ORDER_TYPE xuất hiện ít nhất 1 lần cho mỗi BRANCH_ID
    if branch_id not in branch_customer_mapping:
        branch_customer_mapping[branch_id] = {order_type: False for order_type in order_types}

    available_order_types = [order_type for order_type, assigned in branch_customer_mapping[branch_id].items() if not assigned]
    
    # Nếu còn ORDER_TYPE chưa được gán cho chi nhánh, chọn 1
    if available_order_types:
        order_type = random.choice(available_order_types)
        branch_customer_mapping[branch_id][order_type] = True
    else:
        # Nếu đã gán hết ORDER_TYPE, chọn ngẫu nhiên
        order_type = random.choice(order_types)
    
    # Đảm bảo mỗi CUSTOMER_ID xuất hiện ít nhất một lần
    customer_id = random.choice(customer_ids)

    row = [
        generate_order_id(len(rows) + 1),  # ORDER_ID
        generate_order_date(branch_id),   # ORDER_DATE
        branch_id,                        # BRANCH_ID
        customer_id,                      # CUSTOMER_ID
        order_type,                       # ORDER_TYPE
        generate_order_time(branch_id)    # ORDER_TIME
    ]
    rows.append(row)

# Ghi vào file CSV
with open(output_csv_path, mode="w", newline="", encoding="utf-8") as file:
    writer = csv.writer(file)
    
    # Ghi header
    writer.writerow(["ORDER_ID", "ORDER_DATE", "BRANCH_ID", "CUSTOMER_ID", "ORDER_TYPE", "ORDER_TIME"])
    
    # Ghi dữ liệu
    writer.writerows(rows)

print(f"File CSV '{output_csv_path}' đã được tạo với {num_rows} dòng.")
