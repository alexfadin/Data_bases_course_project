
-- Создаем  иерархическую версию каталога

CREATE VIEW structured_catalog AS 
  SELECT id_1, super_category, 
		 id_2, middle_category, 
         address AS id_3, category AS subcategory 
  FROM (SELECT id_1, super_category, 
			   address AS id_2, 
               category AS middle_category 
		  FROM (SELECT address AS id_1, category AS super_category 
				  FROM catalog 
				  WHERE length(address) = 4) AS supercat
	      LEFT JOIN catalog AS catalog_level_2
            ON supercat.id_1 = LEFT(catalog_level_2.address, 4)
          WHERE length(catalog_level_2.address) = 9) AS middlecat
     LEFT JOIN catalog AS catalog_level_3
      ON id_2 = LEFT(catalog_level_3.address,9)
     WHERE length(catalog_level_3.address) = 14;

-- строим подробную человекочитаемую таблицу по продажам
CREATE VIEW sales_detailed AS 
  SELECT customer_name AS Клиент,
		 group_name as "Товарная группа", 
		 articul AS Артикул, 
		 ingredient_name AS Товар,
		 employee_last_name AS Менеджер, 
		 quantity AS Количество, 
		 price AS "Цена USD", 
		 sales.created_at AS Дата
    FROM sales
    JOIN customers
      ON customers.id = sales.customer_id
    JOIN ingredients
      ON ingredients.ingredient_id = sales.ingredient_id
    JOIN employees
      ON customers.employee_id = employees.id
    JOIN ingredient_groups
      ON ingredients.ingredient_group_id = ingredient_groups.id
    ORDER BY Дата ASC;

-- делаем вспомогательную таблицу для решения одной из главных задачи базы данных(группируем продажи по клиентам, товарам и годам продажи)  
CREATE VIEW sales_by_customer_ingredient AS 
  SELECT YEAR(created_at) AS Year_of_sale, 
    customer_id, ingredient_id, SUM(quantity*price) AS Turnover 
    FROM sales
    GROUP BY customer_id, ingredient_id, YEAR(created_at);

-- прикручиваем к таблице конечных продуктов производимых клиентами продажи по ингредиентам (предыдущее представление) таким образом, чтобы если клиент
-- использует один ингредиент в несколько своих продуктов, продажи ингредиента разделились между ними поровну(т.к. мы точно не знаем
-- сколько и куда он использует, а разделить надо). На выходе получаем сырую таблицу содержащую данные по продажам в конечные продукты.
-- Теперь ее можно использовать для выявления растущих или стагнирующих продуктов и приоретизации распределения ресурсов организации
-- (технологов, продакт-менеджеров, менеджеров по продажам), например, создать новые портфолио(таблица portfolio). 

CREATE VIEW end_products_turnover AS
  SELECT DISTINCT customer_product.customer_id, 
				  customer_product.ingredient_id, 
                  customer_product.end_product_id, 
                  year_of_sale, 
                  turnover/  
                  COUNT(end_product_id) OVER (partition by CONCAT_WS("-",customer_product.customer_id, 
																		 customer_product.ingredient_id, 
																		 year_of_sale)) 
				  AS turnover_per_end_product
    FROM customer_product
      JOIN sales_by_customer_ingredient
        ON customer_product.customer_id = sales_by_customer_ingredient.customer_id
        AND customer_product.ingredient_id = sales_by_customer_ingredient.ingredient_id;

  
    


