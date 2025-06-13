-- 3.1. Активность клиентов: число аренд, бронирований и суммарный «скор»
CREATE VIEW vw_MemberActivity AS
SELECT
  m.member_id,
  m.full_name                     AS Client,
  COUNT(DISTINCT l.loan_id)       AS TotalLoans,
  COUNT(DISTINCT sb.booking_id)   AS TotalBookings,
  (COUNT(l.loan_id) + COUNT(sb.booking_id)) AS ActivityScore
FROM Members AS m
LEFT JOIN EquipmentLoans   AS l  ON m.member_id = l.member_id
LEFT JOIN SessionBookings AS sb ON m.member_id = sb.member_id
GROUP BY m.member_id, m.full_name;

-- 3.2. Счётчик аренд по оборудованию с категорией и поставщиком
CREATE VIEW vw_EquipmentLoansCount AS
SELECT
  ei.item_id,
  ei.name          AS Equipment,
  ec.name          AS Category,
  s.name           AS Supplier,
  COUNT(l.loan_id) AS LoansCount
FROM EquipmentItems AS ei
JOIN EquipmentCategories AS ec ON ei.category_id = ec.category_id
JOIN Suppliers           AS s  ON ei.supplier_id = s.supplier_id
LEFT JOIN EquipmentLoans AS l  ON ei.item_id = l.item_id
GROUP BY ei.item_id, ei.name, ec.name, s.name;

-- 3.3. Ближайшие тренировки с именем тренера и числом записавшихся
CREATE VIEW vw_UpcomingSessions AS
SELECT
  ts.session_id,
  ts.title        AS SessionTitle,
  ts.start_time,
  st.full_name    AS Trainer,
  (SELECT COUNT(*) 
     FROM SessionBookings sb 
     WHERE sb.session_id = ts.session_id
  ) AS BookedCount
FROM TrainingSessions AS ts
JOIN Staff AS st ON ts.trainer_id = st.staff_id
WHERE ts.start_time >= NOW();

-- Примеры запросов к представлениям:
SELECT * FROM vw_MemberActivity       LIMIT 5;
SELECT * FROM vw_EquipmentLoansCount  ORDER BY LoansCount DESC LIMIT 5;
SELECT * FROM vw_UpcomingSessions     LIMIT 10;