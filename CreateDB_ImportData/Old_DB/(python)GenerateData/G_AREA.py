import csv

# Danh sách các thành phố ở Việt Nam
cities = [
    ("A01", "Hà Nội"),
    ("A02", "Hồ Chí Minh"),
    ("A03", "Đà Nẵng"),
    ("A04", "Cần Thơ"),
    ("A05", "Hải Phòng"),
    ("A06", "Nha Trang"),
    ("A07", "Huế"),
    ("A08", "Quảng Ninh"),
    ("A09", "Bình Dương")
]

# Tạo và ghi dữ liệu vào file CSV
with open('area_data.csv', mode='w', newline='', encoding='utf-8') as file:
    writer = csv.writer(file)
    # Ghi tiêu đề của bảng
    writer.writerow(["AREA_ID", "AREA_NAME"])
    
    # Ghi các dòng dữ liệu cho các thành phố
    for city in cities:
        writer.writerow(city)

print("File CSV đã được tạo thành công!")
