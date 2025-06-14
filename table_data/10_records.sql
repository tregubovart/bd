-- 1. Категории оборудования
INSERT INTO EquipmentCategories(category_id, name, description) VALUES
(1,  'Кардиотренажёры',        'Беговые дорожки и велотренажёры'),
(2,  'Силовые тренажёры',       'Штанги, гантели и силовые машины'),
(3,  'Аксессуары',             'Коврики, мячи и скакалки'),
(4,  'Свободные веса',         'Гири и олимпийские блины'),
(5,  'Функциональный зал',     'TRX и канаты'),
(6,  'Йога и пилатес',         'Коврики и блоки'),
(7,  'Бокс и единоборства',     'Боксерские груши и перчатки'),
(8,  'Групповые классы',       'Спиннинг и зумба'),
(9,  'Растяжка',               'Упражнения на гибкость'),
(10, 'Восстановление',         'Валики и массажные мячи');

-- 2. Поставщики
INSERT INTO Suppliers(supplier_id, name, phone, email) VALUES
(1,  'ФитнесМаркет',    '+7 999 111-22-33', 'info@fitmarket.ru'),
(2,  'ПроТренаж',       '+7 495 333-44-55', 'sales@protrain.ru'),
(3,  'GymGlobal',       '+1 222 333 4444',  'contact@gymglobal.com'),
(4,  'SportLine',       '+7 812 555-66-77', 'support@sportline.ru'),
(5,  'HealthEquip',     '+44 20 7946 0958', 'info@healthequip.uk'),
(6,  'MusclePro',       '+7 916 777-88-99', 'sales@musclepro.ru'),
(7,  'FlexGear',        '+7 351 888-99-00', 'contact@flexgear.ru'),
(8,  'StrongHold',      '+1 646 123-4567',  'info@stronghold.com'),
(9,  'ActiveSports',    '+7 812 111-22-33', 'support@activesports.ru'),
(10, 'PrimeFitness',    '+7 495 222-33-44', 'info@primefitness.ru');

-- 3. Оборудование
INSERT INTO EquipmentItems(item_id, name, category_id, supplier_id) VALUES
(1,  'Беговая дорожка LifeRun',      1, 1),
(2,  'Велотренажёр SpinX',           1, 3),
(3,  'Машина Смита',                 2, 2),
(4,  'Гиря 16 кг',                   4, 6),
(5,  'Скакалка SpeedRope',           3, 7),
(6,  'TRX система',                  5, 7),
(7,  'Коврик YogaMat',               6, 1),
(8,  'Боксёрская груша ProBag',      7, 4),
(9,  'Эллиптический тренажёр E200',   1, 5),
(10, 'Фоум роллер RecoverRoll',     10,10);

-- 4. Планы абонементов
INSERT INTO MembershipPlans(plan_id, name, price) VALUES
(1,  'Базовый',      1990.00),
(2,  'Стандарт',     2490.00),
(3,  'Премиум',      3490.00),
(4,  'VIP',          4990.00),
(5,  'Студент',      1590.00),
(6,  'Семейный',     5990.00),
(7,  'Корпоративный',8990.00),
(8,  'Дневной',       990.00),
(9,  'Ночной',       1290.00),
(10, 'Месячный',     3990.00);

-- 5. Клиенты
INSERT INTO Members(member_id, full_name, email, plan_id) VALUES
(1,  'Иванов И.И.',   'ivanov@mail.ru',   1),
(2,  'Петрова А.А.',  'petrova@mail.ru',  2),
(3,  'Сидоров П.П.',  'sidorov@mail.ru',  3),
(4,  'Кузнецова К.К.','kuznetsova@mail.ru',4),
(5,  'Смирнов С.С.',  'smirnov@mail.ru',  5),
(6,  'Морозова М.М.', 'morozova@mail.ru', 6),
(7,  'Васильев В.В.', 'vasiliev@mail.ru', 7),
(8,  'Новикова Н.Н.', 'novikova@mail.ru', 8),
(9,  'Фёдоров Ф.Ф.',  'fedorov@mail.ru',  9),
(10, 'Киселёв К.К.',  'kiselev@mail.ru',  10);

-- 6. Персонал
INSERT INTO Staff(staff_id, full_name, role) VALUES
(1,  'Смирнов Д.Д.',    'Тренер'),
(2,  'Кузнецова Л.Л.', 'Менеджер'),
(3,  'Орлов В.В.',     'Тренер'),
(4,  'Павлова Е.Е.',   'Администратор'),
(5,  'Медведев М.М.',  'Тренер'),
(6,  'Иванова И.И.',   'Администратор'),
(7,  'Киселёв С.С.',   'Тренер'),
(8,  'Соколова О.О.',  'Менеджер'),
(9,  'Лебедев Л.Л.',   'Тренер'),
(10, 'Горбунова Г.Г.', 'Обслуживание');

-- 7. Заказы на закупку
INSERT INTO PurchaseOrders(order_id, supplier_id, order_date) VALUES
(1,  1, '2025-01-10'),
(2,  2, '2025-01-15'),
(3,  3, '2025-02-01'),
(4,  4, '2025-02-10'),
(5,  5, '2025-03-05'),
(6,  6, '2025-03-20'),
(7,  7, '2025-04-01'),
(8,  8, '2025-04-15'),
(9,  9, '2025-05-01'),
(10,10, '2025-05-10');

-- 8. Аренда оборудования
INSERT INTO EquipmentLoans(loan_id, member_id, item_id, checkout_date) VALUES
(1,  1, 1, '2025-06-01 09:00:00'),
(2,  2, 2, '2025-06-01 10:30:00'),
(3,  3, 3, '2025-06-02 11:00:00'),
(4,  4, 4, '2025-06-02 12:15:00'),
(5,  5, 5, '2025-06-03 13:20:00'),
(6,  6, 6, '2025-06-03 14:45:00'),
(7,  7, 7, '2025-06-04 15:10:00'),
(8,  8, 8, '2025-06-04 16:25:00'),
(9,  9, 9, '2025-06-05 17:00:00'),
(10,10,10,'2025-06-05 18:30:00');

-- 9. Тренировочные сессии
INSERT INTO TrainingSessions(session_id, title, trainer_id, start_time) VALUES
(1,  'Утренняя йога',          1, '2025-06-10 07:00:00'),
(2,  'Силовая тренировка',      3, '2025-06-10 09:00:00'),
(3,  'Кардио экспресс',         5, '2025-06-10 11:00:00'),
(4,  'Пилатес',                 7, '2025-06-11 08:00:00'),
(5,  'Бокс для начинающих',     9, '2025-06-11 10:00:00'),
(6,  'Спиннинг',                1, '2025-06-12 18:00:00'),
(7,  'HIIT',                    3, '2025-06-12 19:00:00'),
(8,  'Зумба',                   5, '2025-06-13 17:30:00'),
(9,  'Стретчинг',               7, '2025-06-13 08:30:00'),
(10, 'Функциональная тренировка',9,'2025-06-14 09:30:00');

-- 10. Бронирования сессий
INSERT INTO SessionBookings(booking_id, session_id, member_id) VALUES
(1,  1,  1),
(2,  2,  2),
(3,  3,  3),
(4,  4,  4),
(5,  5,  5),
(6,  6,  6),
(7,  7,  7),
(8,  8,  8),
(9,  9,  9),
(10, 10, 10);
