-- создадим триггер, который на добавление записи в таблицу портфолио создаст список адресов для рассылки менеджерам, 
-- у которых есть клиенты, производящие похожий продукт
drop trigger make_send_list;
DELIMITER //

CREATE TRIGGER make_send_list AFTER INSERT ON portfolio
    FOR EACH ROW BEGIN
    DECLARE new_record VARCHAR(50); 
    SELECT category INTO new_record from portfolio JOIN catalog ON portfolio.end_product_id = catalog.id order by updated_at DESC LIMIT 1;
    CALL send_list(new_record);
    
    END
    //
    
INSERT INTO portfolio
(employee_id,end_product_id,ingredient_id,dosage_g_per_100_kg_min,dosage_g_per_100_kg_max,descript)
VALUES
(45, 1300, 1100, 50, 150, 'отличный результат на дозировке 100 г/100 кг');

-- триггер не срабатывает, возвращает ошибку 1415.  