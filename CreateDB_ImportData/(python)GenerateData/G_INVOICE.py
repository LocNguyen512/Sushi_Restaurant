import csv

# Hàm đọc dữ liệu từ file CSV của bảng ORDER
def read_order_csv(file_path):
    orders = []
    with open(file_path, mode='r', encoding='utf-8') as file:
        reader = csv.DictReader(file)
        for row in reader:
            orders.append({
                "ORDER_ID": row["ORDER_ID"],
                "ORDER_DATE": row["ORDER_DATE"]
            })
    return orders

# Hàm tạo dữ liệu cho bảng INVOICE
def create_invoice_data(orders):
    invoices = []
    for order in orders:
        order_id = order["ORDER_ID"]
        invoice_id = "I" + order_id[1:]  # Thay ký tự 'O' thành 'I'
        invoices.append({
            "INVOICE_ID": invoice_id,
            "TOTAL_AMOUNT": 0,  # Gán TOTAL_AMOUNT = 0
            "DISCOUNT": 0.0,  # Gán DISCOUNT = 0.0
            "ISSUE_DATE": order["ORDER_DATE"],  # ISSUE_DATE = ORDER_DATE
            "ORDER_ID": order_id  # ORDER_ID = ORDER_ID trong ORDER
        })
    return invoices

# Hàm ghi dữ liệu ra file CSV cho bảng INVOICE
def write_invoice_csv(file_path, invoices):
    with open(file_path, mode='w', newline='', encoding='utf-8') as file:
        fieldnames = ["INVOICE_ID", "TOTAL_AMOUNT", "DISCOUNT", "ISSUE_DATE", "ORDER_ID"]
        writer = csv.DictWriter(file, fieldnames=fieldnames)
        writer.writeheader()
        writer.writerows(invoices)

# Đường dẫn tới file CSV của bảng ORDER và file OUTPUT
order_csv_path = "order_data.csv"  # Đường dẫn tới file ORDER.csv
invoice_csv_path = "invoice_data.csv"  # Đường dẫn để lưu file INVOICE.csv

# Đọc dữ liệu từ ORDER.csv
orders = read_order_csv(order_csv_path)

# Tạo dữ liệu cho INVOICE
invoices = create_invoice_data(orders)

# Ghi dữ liệu ra INVOICE.csv
write_invoice_csv(invoice_csv_path, invoices)

print(f"Đã tạo file {invoice_csv_path} với {len(invoices)} dòng.")
