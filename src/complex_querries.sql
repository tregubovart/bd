-- 1. Топ-5 оборудования по числу аренд за последние 30 дней вместе с категорией и поставщиком
SELECT 
  ec.name          AS Category,
  s.name           AS Supplier,
  ei.name          AS Equipment,
  COUNT(l.loan_id) AS LoansCount
FROM EquipmentItems ei
JOIN EquipmentCategories ec ON ei.category_id = ec.category_id
JOIN Suppliers s           ON ei.supplier_id = s.supplier_id
JOIN EquipmentLoans l      ON ei.item_id = l.item_id
WHERE l.checkout_date >= DATE_SUB(NOW(), INTERVAL 30 DAY)
GROUP BY ec.category_id, ei.item_id, s.supplier_id
ORDER BY LoansCount DESC
LIMIT 5;

-- 2. Топ-5 клиентов по суммарному числу аренды и бронирований за весь период
SELECT
  m.member_id,
  m.full_name                         AS Client,
  COUNT(DISTINCT l.loan_id)           AS TotalLoans,
  COUNT(DISTINCT sb.booking_id)       AS TotalBookings,
  (COUNT(l.loan_id) + COUNT(sb.booking_id)) AS ActivityScore
FROM Members m
LEFT JOIN EquipmentLoans l   ON m.member_id = l.member_id
LEFT JOIN SessionBookings sb ON m.member_id = sb.member_id
GROUP BY m.member_id
HAVING ActivityScore > 0
ORDER BY ActivityScore DESC
LIMIT 5;

-- 3. Тренеры с количеством проведённых сессий и средним числом участников
SELECT
  s.staff_id,
  s.full_name                     AS Trainer,
  COUNT(ts.session_id)            AS SessionsCount,
  ROUND(AVG(sub.Bookings), 1)     AS AvgParticipants
FROM Staff s
JOIN TrainingSessions ts        ON s.staff_id = ts.trainer_id
LEFT JOIN (
  SELECT session_id, COUNT(*) AS Bookings
  FROM SessionBookings
  GROUP BY session_id
) AS sub                       ON ts.session_id = sub.session_id
GROUP BY s.staff_id
ORDER BY SessionsCount DESC, AvgParticipants DESC
LIMIT 5;
 
-- 4. Получаем количество заказов по каждому месяцу и каждому поставщику за последние 6 месяцев
SELECT
    m.month_label   AS `Month`,
    s.name          AS `Supplier`,
    COALESCE(t.OrdersCount, 0) AS `OrdersCount`
FROM
    (
      -- все месяцы, в которые были заказы за последние 6 месяцев
      SELECT DISTINCT
          DATE_FORMAT(order_date, '%Y-%m') AS month_label
      FROM PurchaseOrders
      WHERE order_date >= DATE_SUB(CURDATE(), INTERVAL 6 MONTH)
    ) AS m
  CROSS JOIN Suppliers AS s
  LEFT JOIN (
      -- реальное число заказов по месяцу и поставщику
      SELECT
          supplier_id,
          DATE_FORMAT(order_date, '%Y-%m') AS month_label,
          COUNT(*) AS OrdersCount
      FROM PurchaseOrders
      WHERE order_date >= DATE_SUB(CURDATE(), INTERVAL 6 MONTH)
      GROUP BY supplier_id, month_label
  ) AS t
    ON t.supplier_id = s.supplier_id
   AND t.month_label = m.month_label
ORDER BY
    m.month_label DESC,
    s.name;


-- 5. По категориям: общее число аренд, число уникальных клиентов и среднее число аренд на клиента
SELECT
  ec.name                              AS Category,
  COUNT(l.loan_id)                     AS TotalLoans,
  COUNT(DISTINCT l.member_id)          AS UniqueClients,
  ROUND(COUNT(l.loan_id)/COUNT(DISTINCT l.member_id),2) AS AvgLoansPerClient
FROM EquipmentCategories ec
LEFT JOIN EquipmentItems ei            ON ec.category_id = ei.category_id
LEFT JOIN EquipmentLoans l             ON ei.item_id     = l.item_id
GROUP BY ec.category_id
ORDER BY TotalLoans DESC;  
