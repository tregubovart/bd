-- Удаляем старые функции, если существуют
DROP FUNCTION IF EXISTS fn_GetMemberPlanPrice;
DROP FUNCTION IF EXISTS fn_GetSupplierEmail;
DROP FUNCTION IF EXISTS fn_GetSessionBookingsCount;

-- Меняем разделитель
DELIMITER $$

-- 2.1. Цена плана абонемента для конкретного клиента
CREATE FUNCTION fn_GetMemberPlanPrice(p_member_id INT)
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
  DECLARE v_price DECIMAL(10,2);
  SELECT mp.price
    INTO v_price
  FROM Members AS m
  JOIN MembershipPlans AS mp ON m.plan_id = mp.plan_id
  WHERE m.member_id = p_member_id;
  RETURN v_price;
END$$
-- Немедленный вызов для проверки
SELECT fn_GetMemberPlanPrice(1) AS PlanPrice$$

-- 2.2. Электронная почта поставщика по его ID
CREATE FUNCTION fn_GetSupplierEmail(p_supplier_id INT)
RETURNS VARCHAR(100)
DETERMINISTIC
BEGIN
  DECLARE v_email VARCHAR(100);
  SELECT email
    INTO v_email
  FROM Suppliers
  WHERE supplier_id = p_supplier_id;
  RETURN v_email;
END$$
-- Немедленный вызов для проверки
SELECT fn_GetSupplierEmail(2) AS SupplierEmail$$

-- 2.3. Количество записей на конкретную сессию
CREATE FUNCTION fn_GetSessionBookingsCount(p_session_id INT)
RETURNS INT
DETERMINISTIC
READS SQL DATA
BEGIN
  DECLARE v_count INT DEFAULT 0;
  SELECT COUNT(*) 
    INTO v_count
  FROM SessionBookings
  WHERE session_id = p_session_id;
  RETURN v_count;
END$$

-- Немедленный вызов для проверки
SELECT fn_GetSessionBookingsCount(1) AS BookingsCount$$

-- Восстанавливаем стандартный разделитель
DELIMITER ;
