-- считаем продажи помесячно в разрезе товарных групп

SELECT ingredient_groups.group_name AS Товарная_группа, 
	   SUM(CASE WHEN MONTH(created_at) = 1 THEN ROUND(price*quantity,0) ELSE 0 END)  AS January,
	   SUM(CASE WHEN MONTH(created_at) = 2 THEN ROUND(price*quantity,0) ELSE 0 END)  AS February,
	   SUM(CASE WHEN MONTH(created_at) = 3 THEN ROUND(price*quantity,0) ELSE 0 END)  AS March,
	   SUM(CASE WHEN MONTH(created_at) = 4 THEN ROUND(price*quantity,0) ELSE 0 END)  AS April,
	   SUM(CASE WHEN MONTH(created_at) = 5 THEN ROUND(price*quantity,0) ELSE 0 END)  AS May,
	   SUM(CASE WHEN MONTH(created_at) = 6 THEN ROUND(price*quantity,0) ELSE 0 END)  AS June,
	   SUM(CASE WHEN MONTH(created_at) = 7 THEN ROUND(price*quantity,0) ELSE 0 END)  AS July,
	   SUM(CASE WHEN MONTH(created_at) = 8 THEN ROUND(price*quantity,0) ELSE 0 END)  AS August,
	   SUM(CASE WHEN MONTH(created_at) = 9 THEN ROUND(price*quantity,0) ELSE 0 END)  AS September,
	   SUM(CASE WHEN MONTH(created_at) = 10 THEN ROUND(price*quantity,0) ELSE 0 END)  AS October,
	   SUM(CASE WHEN MONTH(created_at) = 11 THEN ROUND(price*quantity,0) ELSE 0 END)  AS November,
	   SUM(CASE WHEN MONTH(created_at) = 12 THEN ROUND(price*quantity,0) ELSE 0 END)  AS December,
	   SUM(ROUND(price*quantity,0))  AS TOTAL
  FROM sales
  JOIN ingredients
    ON ingredients.ingredient_id = sales.ingredient_id
  JOIN ingredient_groups
    ON ingredients.ingredient_group_id = ingredient_groups.id
  WHERE YEAR(created_at) = 2019 
  GROUP BY ingredient_groups.group_name
  ORDER BY TOTAL DESC;

-- 10 продавцов с наименьшим показатедем продаж

SELECT employees.employee_last_name, 
       SUM(quantity*price) AS turnover 
  FROM sales
  JOIN customers
    ON sales.customer_id = customers.id
  LEFT JOIN employees
    ON employees.id = customers.employee_id
  GROUP BY employees.employee_last_name
  ORDER BY turnover ASC
  LIMIT 10;
  

 
-- выбор пяти наиболее успешных групп конечных продуктов в текущем году. Можно выдать задание технологам по наполнению портфолио для этих групп.  

SELECT middle_category,
	   ROUND(SUM(CASE WHEN year_of_sale = 2018 THEN turnover_per_end_product ELSE 0 END) - 
	         SUM(CASE WHEN year_of_sale = 2019 THEN turnover_per_end_product ELSE 0 END),0)  AS delta_19_18_USD
  FROM end_products_turnover
  JOIN catalog
    ON catalog.id = end_products_turnover.end_product_id
  JOIN structured_catalog
    ON structured_catalog.id_2 = LEFT(catalog.address,9)
  GROUP BY middle_category
  ORDER BY delta_19_18_USD DESC
  LIMIT 5;
  
	  
    