import csv
import random

# Đọc dữ liệu từ file ORDER
def read_orders(file_path):
    orders = []
    with open(file_path, mode='r', encoding='utf-8') as file:
        reader = csv.DictReader(file)
        for row in reader:
            orders.append({'ORDER_ID': row['ORDER_ID'], 'BRANCH_ID': row['BRANCH_ID']})
    return orders

# Đọc dữ liệu từ file DISH_AVAILABLE
def read_dishes(file_path):
    dishes = []
    with open(file_path, mode='r', encoding='utf-8') as file:
        reader = csv.DictReader(file)
        for row in reader:
            if row['IS_AVAILABLE'] == '1':  # Chỉ chọn món khả dụng
                dishes.append({'BRANCH_ID': row['BRANCH_ID'], 'DISH_ID': row['DISH_ID']})
    return dishes

# Sinh dữ liệu ORDER_DISH
def generate_order_dish(orders, dishes, output_file, num_records):
    order_dish_set = set()  # Để tránh trùng cặp ORDER_ID và DISH_ID
    data = []

    while len(data) < num_records:
        order = random.choice(orders)
        branch_id = order['BRANCH_ID']
        order_id = order['ORDER_ID']

        # Lọc danh sách món theo BRANCH_ID
        available_dishes = [dish for dish in dishes if dish['BRANCH_ID'] == branch_id]

        if available_dishes:
            dish = random.choice(available_dishes)
            dish_id = dish['DISH_ID']
            quantity = random.randint(1, 5)

            # Kiểm tra trùng cặp ORDER_ID và DISH_ID
            if (order_id, dish_id) not in order_dish_set:
                order_dish_set.add((order_id, dish_id))
                data.append({'ORDER_ID': order_id, 'DISH_ID': dish_id, 'QUANTITY': quantity})

    # Ghi dữ liệu ra file CSV
    with open(output_file, mode='w', encoding='utf-8', newline='') as file:
        writer = csv.DictWriter(file, fieldnames=['ORDER_ID', 'DISH_ID', 'QUANTITY'])
        writer.writeheader()
        writer.writerows(data)

# Đường dẫn tới các file CSV
order_file = 'order_data.csv'
dish_file = 'dish_available_data.csv'
output_file = 'order_dish_data.csv'

# Thực thi các bước
orders = read_orders(order_file)
dishes = read_dishes(dish_file)
generate_order_dish(orders, dishes, output_file, 120000)
