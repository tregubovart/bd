
DROP TRIGGER IF EXISTS trg_check_plan_price


-- Триггер: проверяет, что цена плана абонемента больше 0
DELIMITER $$

CREATE TRIGGER trg_check_plan_price
BEFORE INSERT ON MembershipPlans
FOR EACH ROW
BEGIN
  IF NEW.price <= 0 THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'Price must be positive';
  END IF;
END$$

DELIMITER ;

-- === Проверка работы триггера ===

-- 1) Вставка с корректными данными (должна пройти успешно)
INSERT INTO MembershipPlans(plan_id, name, price)
VALUES (11998746, 'Тестовый_Правильный', 2590.00);

-- 2) Вставка с некорректными данными (должна выдать ошибку)
INSERT INTO MembershipPlans(plan_id, name, price)
VALUES (12040008, 'Тестовый_Неправильный', -500.00);
