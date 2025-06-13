import random
import datetime

# Количество записей для каждой таблицы
NUM_RECORDS = 10000

# Функции для генерации случайных дат и дат-времени

def random_date(start_year=2024, end_year=2025):
    start = datetime.date(start_year, 1, 1).toordinal()
    end = datetime.date(end_year, 12, 31).toordinal()
    return datetime.date.fromordinal(random.randint(start, end))


def random_datetime(start_year=2024, end_year=2025):
    date = random_date(start_year, end_year)
    hour = random.randint(6, 22)
    minute = random.randint(0, 59)
    return datetime.datetime.combine(date, datetime.time(hour, minute))

with open("insert_data.sql", "w", encoding="utf-8") as f:
    # 1. EquipmentCategories
    for i in range(1, NUM_RECORDS + 1):
        name = f"Категория_{i}"
        desc = f"Описание категории {i}"
        f.write(f"INSERT INTO EquipmentCategories (category_id, name, description) VALUES ({i}, '{name}', '{desc}');\n")

    # 2. Suppliers
    for i in range(1, NUM_RECORDS + 1):
        name = f"Поставщик_{i}"
        phone = f"+7{random.randint(9000000000, 9999999999)}"
        email = f"supplier{i}@example.com"
        f.write(f"INSERT INTO Suppliers (supplier_id, name, phone, email) VALUES ({i}, '{name}', '{phone}', '{email}');\n")

    # 3. EquipmentItems
    for i in range(1, NUM_RECORDS + 1):
        name = f"Оборудование_{i}"
        category = random.randint(1, NUM_RECORDS)
        supplier = random.randint(1, NUM_RECORDS)
        f.write(f"INSERT INTO EquipmentItems (item_id, name, category_id, supplier_id) VALUES ({i}, '{name}', {category}, {supplier});\n")

    # 4. MembershipPlans
    for i in range(1, NUM_RECORDS + 1):
        name = f"План_{i}"
        price = round(random.uniform(500, 3000), 2)
        f.write(f"INSERT INTO MembershipPlans (plan_id, name, price) VALUES ({i}, '{name}', {price});\n")

    # 5. Members
    for i in range(1, NUM_RECORDS + 1):
        full = f"Клиент_{i}"
        email = f"member{i}@example.com"
        plan = random.randint(1, NUM_RECORDS)
        f.write(f"INSERT INTO Members (member_id, full_name, email, plan_id) VALUES ({i}, '{full}', '{email}', {plan});\n")

    # 6. Staff
    roles = ["Тренер", "Менеджер", "Администратор", "Инструктор"]
    for i in range(1, NUM_RECORDS + 1):
        full = f"Сотрудник_{i}"
        role = random.choice(roles)
        f.write(f"INSERT INTO Staff (staff_id, full_name, role) VALUES ({i}, '{full}', '{role}');\n")

    # 7. PurchaseOrders
    for i in range(1, NUM_RECORDS + 1):
        supplier = random.randint(1, NUM_RECORDS)
        date = random_date()
        f.write(f"INSERT INTO PurchaseOrders (order_id, supplier_id, order_date) VALUES ({i}, {supplier}, '{date}');\n")

    # 8. EquipmentLoans
    for i in range(1, NUM_RECORDS + 1):
        member = random.randint(1, NUM_RECORDS)
        item = random.randint(1, NUM_RECORDS)
        dt = random_datetime()
        f.write(f"INSERT INTO EquipmentLoans (loan_id, member_id, item_id, checkout_date) VALUES ({i}, {member}, {item}, '{dt}');\n")

    # 9. TrainingSessions
    for i in range(1, NUM_RECORDS + 1):
        title = f"Сессия_{i}"
        trainer = random.randint(1, NUM_RECORDS)
        start = random_datetime()
        f.write(f"INSERT INTO TrainingSessions (session_id, title, trainer_id, start_time) VALUES ({i}, '{title}', {trainer}, '{start}');\n")

    # 10. SessionBookings
    for i in range(1, NUM_RECORDS + 1):
        session = random.randint(1, NUM_RECORDS)
        member = random.randint(1, NUM_RECORDS)
        f.write(f"INSERT INTO SessionBookings (booking_id, session_id, member_id) VALUES ({i}, {session}, {member});\n")

print("Файл insert_data.sql успешно сгенерирован.")
