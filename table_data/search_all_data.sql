SELECT
    table_name   AS 'TABLE_NAME',
    table_rows   AS 'TABLE_ROWS'
FROM
    information_schema.tables
WHERE
    table_schema = DATABASE()
    AND table_type = 'BASE TABLE'
    AND table_name IN (
        'EquipmentCategories',
        'Suppliers',
        'EquipmentItems',
        'MembershipPlans',
        'Members',
        'Staff',
        'PurchaseOrders',
        'EquipmentLoans',
        'TrainingSessions',
        'SessionBookings'
    )
ORDER BY
    table_name;
