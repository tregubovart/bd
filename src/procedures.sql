-- Удаляем старые процедуры, если существуют
DROP PROCEDURE IF EXISTS sp_GetMemberLoans;
DROP PROCEDURE IF EXISTS sp_AddSupplier;
DROP PROCEDURE IF EXISTS sp_GetMonthlyOrdersStats;

-- Меняем разделитель, чтобы внутри процедур можно было использовать ';'
DELIMITER $$

-- 1.1. Получить все аренды указанного клиента
CREATE PROCEDURE sp_GetMemberLoans(IN p_member_id INT)
BEGIN
  SELECT
    l.loan_id,
    l.item_id,
    l.checkout_date
  FROM EquipmentLoans AS l
  WHERE l.member_id = p_member_id;
END$$
-- Немедленный вызов для проверки (вернёт список аренд или пустой набор)
CALL sp_GetMemberLoans(1)$$


-- 1.2. Добавить нового поставщика и сразу вывести его данные
CREATE PROCEDURE sp_AddSupplier(
  IN p_name  VARCHAR(150),
  IN p_phone VARCHAR(50),
  IN p_email VARCHAR(100)
)
BEGIN
  DECLARE v_next_id INT;
  -- вычисляем следующий ID
  SELECT IFNULL(MAX(supplier_id), 0) + 1
    INTO v_next_id
  FROM Suppliers;
  -- вставляем
  INSERT INTO Suppliers(supplier_id, name, phone, email)
  VALUES(v_next_id, p_name, p_phone, p_email);
  -- сразу выводим вставленную запись
  SELECT
    supplier_id,
    name,
    phone,
    email
  FROM Suppliers
  WHERE supplier_id = v_next_id;
END$$
-- Немедленный вызов для проверки: вернёт только что вставленного поставщика
CALL sp_AddSupplier('TestSupplier', '+7 000 000-00-00', 'test@demo.ru')$$


-- 1.3. Статистика по заказам за указанный месяц (формат 'YYYY-MM')
-- теперь всегда возвращает одну строку с нулём, если заказов не было
CREATE PROCEDURE sp_GetMonthlyOrdersStats(IN p_month CHAR(7))
BEGIN
  DECLARE v_count INT;
  SELECT COUNT(*) 
    INTO v_count
  FROM PurchaseOrders
  WHERE DATE_FORMAT(order_date, '%Y-%m') = p_month;
  -- выводим результат
  SELECT
    p_month   AS Month,
    v_count   AS OrdersCount;
END$$
-- Немедленный вызов для проверки: вернёт ровно одну строку
CALL sp_GetMonthlyOrdersStats('2025-05')$$

-- Восстанавливаем стандартный разделитель
DELIMITER ;
