from faker import Faker 
import csv

# Tạo đối tượng Faker
fake = Faker("vi_VN")  # Đảm bảo tên tiếng Việt có dấu
Faker.seed(0)  # Đảm bảo tái tạo dữ liệu giống nhau khi chạy lại

# Số lượng bản ghi
num_records = 100000
output_file = "customer_data.csv"

# Tạo danh sách customer_id từ 000001 đến 100000
customer_ids = [f"{i:06}" for i in range(1, num_records + 1)]

# Hàm để tạo dữ liệu khách hàng
def generate_unique_data(num_records):
    # Tập hợp để đảm bảo dữ liệu không bị trùng
    used_phone_numbers = set()
    used_identity_cards = set()
    used_emails = set()

    data = []

    # Bộ đếm i, j, k
    i = 0
    j = 0
    k = 0

    for _ in range(num_records):
        # Tạo dữ liệu duy nhất cho từng thuộc tính
        # Tạo phone_number duy nhất
        while True:
            i += 1
            phone_number = f"0{fake.random_number(digits=9, fix_len=True)}"
            if phone_number not in used_phone_numbers:
                used_phone_numbers.add(phone_number)
                print(f"Đã tạo thành công PHONE {i}.")
                break
        
        # Tạo identity_card duy nhất
        while True:
            j += 1
            identity_card = str(fake.random_number(digits=12, fix_len=True)).zfill(12)  # Đảm bảo chuỗi 12 chữ số
            if identity_card not in used_identity_cards:
                used_identity_cards.add(identity_card)
                print(f"Đã tạo thành công ID {j}.")
                break
        
        # Tạo email duy nhất
        while True:
            k += 1
            email_local_part = fake.email().split("@")[0][:30]
            email = f"{email_local_part}_{len(used_emails)+1}@gmail.com"  # Đảm bảo tính duy nhất
            if email not in used_emails:
                used_emails.add(email)
                print(f"Đã tạo thành công MAIL {k}.")
                break

        # Tạo các trường còn lại
        full_name = fake.name()
        if len(full_name) > 50:
            full_name = full_name[:50]

        gender = fake.random_element(["Nam", "Nữ"])

        # Thêm vào danh sách dữ liệu
        data.append((full_name, phone_number, email, identity_card, gender))
        print(f"Đã tạo thành công DS.")

    return data

# Ghi dữ liệu vào file CSV
with open(output_file, mode="w", newline="", encoding="utf-8") as file:
    writer = csv.writer(file)
    # Ghi header
    writer.writerow(["CUSTOMER_ID", "FULL_NAME", "PHONE_NUMBER", "EMAIL", "IDENTITY_CARD", "GENDER"])

    # Tạo dữ liệu và ghi vào file
    unique_data = generate_unique_data(num_records)
    for customer_id, (full_name, phone_number, email, identity_card, gender) in zip(customer_ids, unique_data):
        writer.writerow([customer_id, full_name, phone_number, email, identity_card, gender])  # identity_card là chuỗi
        print(f"Đã tạo thành công {customer_id}.")

print(f"Đã tạo thành công {num_records} dòng dữ liệu trong file {output_file}.")
