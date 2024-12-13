import csv
import random
from datetime import datetime

# Hàm hỗ trợ random giá trị kiểu int theo tỷ lệ 80% là 5, 20% là 1-4
def random_rating():
    return 5 if random.random() < 0.8 else random.randint(1, 4)

# Hàm tạo nội dung comment
def generate_comment(service, location, price, quality, environment):
    if all(r == 5 for r in [service, location, price, quality, environment]):
        return "TẤT CẢ ĐỀU TỐT VÀ KHÔNG CÓ GÌ ĐỂ CHÊ"
    elif 1 in [service, location, price, quality, environment] or 2 in [service, location, price, quality, environment]:
        return "QUÁN CÒN THIẾU SÓT NHIỀU NÊN CẦN CẢI THIỆN"
    else:
        return "MỌI THỨ CỦA QUÁN ĐỀU ỔN"

# Đọc dữ liệu từ file CSV ORDER và INVOICE
def read_csv(filename):
    with open(filename, mode='r', encoding='utf-8') as file:
        return list(csv.DictReader(file))

# Tạo file CSV chứa dữ liệu BRANCH_RATING
def generate_branch_rating(order_file, invoice_file, output_file):
    orders = read_csv(order_file)
    invoices = read_csv(invoice_file)
    
    # Tạo dictionary mapping từ INVOICE_ID -> ISSUE_DATE
    invoice_mapping = {invoice['INVOICE_ID']: invoice['ISSUE_DATE'] for invoice in invoices}

    # Tạo dữ liệu cho bảng BRANCH_RATING
    with open(output_file, mode='w', encoding='utf-8', newline='') as file:
        writer = csv.writer(file, quoting=csv.QUOTE_NONE, escapechar='\\')  # QUOTE_NONE để không có dấu "
        # Ghi header
        writer.writerow(["RATING_ID", "SERVICE_RATING", "LOCATION_RATING", "PRICE_RATING", 
                         "DISH_QUALITY_RATING", "ENVIRONMENT_RATING", "COMMENT", 
                         "BRANCH_ID", "RATING_DATE", "INVOICE_ID"])
        
        for order in orders:
            order_id = order['ORDER_ID']
            branch_id = order['BRANCH_ID']
            invoice_id = next((inv['INVOICE_ID'] for inv in invoices if inv['ORDER_ID'] == order_id), None)
            rating_date = invoice_mapping.get(invoice_id, None)
            
            if not rating_date:
                continue
            
            # Tạo RATING_ID
            rating_id = "R" + order_id[1:]
            
            # Tạo các giá trị rating ngẫu nhiên
            service_rating = random_rating()
            location_rating = random_rating()
            price_rating = random_rating()
            quality_rating = random_rating()
            environment_rating = random_rating()
            
            # Tạo comment
            comment = generate_comment(service_rating, location_rating, price_rating, quality_rating, environment_rating)
            
            # Loại bỏ dấu ngoặc kép trong comment nếu có
            comment = comment.replace('"', '')  # Thay thế tất cả dấu ngoặc kép bằng chuỗi rỗng
            
            # Ghi dữ liệu
            writer.writerow([rating_id, service_rating, location_rating, price_rating, 
                             quality_rating, environment_rating, comment, branch_id, 
                             rating_date, invoice_id])

# Sử dụng hàm để tạo dữ liệu
generate_branch_rating('order_data.csv', 'invoice_data.csv', 'branch_rating_data.csv')