-- 1. Категории оборудования
CREATE TABLE EquipmentCategories (
    category_id    INT        PRIMARY KEY,
    name           VARCHAR(100),
    description    TEXT
);

-- 2. Поставщики
CREATE TABLE Suppliers (
    supplier_id    INT        PRIMARY KEY,
    name           VARCHAR(150),
    phone          VARCHAR(50),
    email          VARCHAR(100)
);

-- 3. Оборудование
CREATE TABLE EquipmentItems (
    item_id        INT        PRIMARY KEY,
    name           VARCHAR(150),
    category_id    INT,
    supplier_id    INT,
    FOREIGN KEY (category_id) REFERENCES EquipmentCategories(category_id),
    FOREIGN KEY (supplier_id) REFERENCES Suppliers(supplier_id)
);

-- 4. Планы абонементов
CREATE TABLE MembershipPlans (
    plan_id        INT        PRIMARY KEY,
    name           VARCHAR(100),
    price          DECIMAL(10,2)
);

-- 5. Клиенты
CREATE TABLE Members (
    member_id      INT        PRIMARY KEY,
    full_name      VARCHAR(150),
    email          VARCHAR(150),
    plan_id        INT,
    FOREIGN KEY (plan_id) REFERENCES MembershipPlans(plan_id)
);

-- 6. Персонал
CREATE TABLE Staff (
    staff_id       INT        PRIMARY KEY,
    full_name      VARCHAR(150),
    role           VARCHAR(50)
);

-- 7. Закупки
CREATE TABLE PurchaseOrders (
    order_id       INT        PRIMARY KEY,
    supplier_id    INT,
    order_date     DATE,
    FOREIGN KEY (supplier_id) REFERENCES Suppliers(supplier_id)
);

-- 8. Аренда оборудования
CREATE TABLE EquipmentLoans (
    loan_id        INT        PRIMARY KEY,
    member_id      INT,
    item_id        INT,
    checkout_date  DATETIME,
    FOREIGN KEY (member_id) REFERENCES Members(member_id),
    FOREIGN KEY (item_id) REFERENCES EquipmentItems(item_id)
);

-- 9. Тренировочные сессии
CREATE TABLE TrainingSessions (
    session_id     INT        PRIMARY KEY,
    title          VARCHAR(150),
    trainer_id     INT,
    start_time     DATETIME,
    FOREIGN KEY (trainer_id) REFERENCES Staff(staff_id)
);

-- 10. Бронирования на тренировки
CREATE TABLE SessionBookings (
    booking_id     INT        PRIMARY KEY,
    session_id     INT,
    member_id      INT,
    FOREIGN KEY (session_id) REFERENCES TrainingSessions(session_id),
    FOREIGN KEY (member_id) REFERENCES Members(member_id)
);
