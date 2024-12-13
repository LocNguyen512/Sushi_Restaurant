import csv
import random

# Đọc file CSV chứa BRANCH_ID
branch_ids = []

# Đọc file CSV chứa thông tin chi nhánh
with open('restaurant_branch_data.csv', mode='r', encoding='utf-8') as file:
    reader = csv.DictReader(file)
    for row in reader:
        branch_ids.append(row['BRANCH_ID'])  # Giả sử tên cột là 'BRANCH_ID'

# Tạo dữ liệu cho bảng TABLE_
table_data = []

# Trạng thái bàn và tỷ lệ xuất hiện
status_options = ['Đang phục vụ', 'Khách đặt trước', 'Còn trống']
status_weights = [0.55, 0.35, 0.10]  # Tỷ lệ phần trăm

# Tạo dữ liệu cho mỗi chi nhánh
for branch_id in branch_ids:
    tables = []
    # Số lượng bàn mỗi trạng thái dựa trên tỷ lệ
    total_tables = 50
    num_serving = int(total_tables * status_weights[0])
    num_reserved = int(total_tables * status_weights[1])
    num_empty = total_tables - (num_serving + num_reserved)  # Còn lại là trạng thái "Còn trống"

    # Đảm bảo mỗi trạng thái xuất hiện ít nhất 1 lần
    if num_empty == 0:
        num_empty += 1
        if num_serving > num_reserved:
            num_serving -= 1
        else:
            num_reserved -= 1

    # Tạo danh sách các trạng thái cho 50 bàn
    statuses = (
        ['Đang phục vụ'] * num_serving +
        ['Khách đặt trước'] * num_reserved +
        ['Còn trống'] * num_empty
    )
    random.shuffle(statuses)  # Trộn ngẫu nhiên danh sách trạng thái

    # Tạo dữ liệu cho các bàn
    for table_num in range(1, total_tables + 1):
        table_status = statuses[table_num - 1]
        seat_available = 5 if table_num <= 25 else 10
        tables.append([table_num, branch_id, table_status, seat_available])

    # Thêm dữ liệu của chi nhánh vào danh sách tổng
    table_data.extend(tables)

# Lưu dữ liệu vào file CSV
csv_filename = "table_data.csv"
with open(csv_filename, mode='w', newline='', encoding='utf-8') as file:
    writer = csv.writer(file)
    writer.writerow(["TABLE_NUM", "BRANCH_ID", "TABLE_STATUS", "SEAT_AVILABLE"])
    writer.writerows(table_data)

print(f"File CSV {csv_filename} đã được tạo thành công!")
