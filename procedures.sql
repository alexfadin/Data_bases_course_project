  -- Небольшая рекомендательная система основанная на данных об использовании ингредиентов в те или иные конечные продукты.
  -- Зная что производит клиент, менеджер по продажам имеет ассортимент подходящих ингредиентов. При этом, можно вывести как все ингредиенты для
  -- укрупненной группы, например Соусы, так и для вполне конкретного соуса, например, Барбекю.
  -- Такой способ возможен исходя из особой структуры таблицы catalog, в которой есть поле address, в котором данные хранятся в виде списка смежности 
  -- с другими значениями таблицы catalog.
  DELIMITER //
  
  CREATE PROCEDURE used_ingredients (IN catalog_item VARCHAR(50))
  BEGIN
    DECLARE group_catalog VARCHAR(50); 
    SET group_catalog = (SELECT address FROM catalog WHERE category = catalog_item);
    
    SELECT catalog_item, catalog.category, catalog.address, ingredients.ingredient_name, ingredient_groups.group_name  
    FROM customer_product
      JOIN catalog
        ON catalog.id = end_product_id
      JOIN ingredients
        ON ingredients.ingredient_id = customer_product.ingredient_id
      JOIN ingredient_groups
        ON ingredients.ingredient_group_id = ingredient_groups.id
      
    WHERE LEFT(address, CHAR_LENGTH(group_catalog)) = group_catalog  
    ORDER by group_name ASC;
    
END //

-- тоже самое, только выборка идет по портфолио
DELIMITER //
CREATE PROCEDURE portfolio_selection (IN catalog_item VARCHAR(50))
  BEGIN
    DECLARE group_catalog VARCHAR(50); 
    SET group_catalog = (SELECT address FROM catalog WHERE category = catalog_item);
  
SELECT catalog_item, catalog.category, 
	   catalog.address, ingredients.ingredient_name, 
       ingredient_groups.group_name, portfolio.descript, 
       employee_last_name, portfolio.updated_at  
    FROM portfolio
      JOIN catalog
        ON catalog.id = end_product_id
      JOIN ingredients
        ON ingredients.ingredient_id = portfolio.ingredient_id
      JOIN ingredient_groups
        ON ingredients.ingredient_group_id = ingredient_groups.id
	  JOIN employees
        ON portfolio.employee_id = employees.id
      

 WHERE LEFT(address, CHAR_LENGTH(group_catalog)) = group_catalog  
    ORDER by group_name ASC;
    
END //


-- создаем список адресатов для рассылки по какому-либо ингредиенту. Задумывалось, что при добавлении записи в таблицу portfolio 
-- триггер срабатывает и запускает эту процедуру. Но там возникает ошибка 1415, которую не удется победить.
DELIMITER //
  
  CREATE PROCEDURE send_list (IN catalog_item VARCHAR(50))
  BEGIN
    DECLARE group_catalog VARCHAR(50); 
    SET group_catalog = (SELECT address FROM catalog WHERE category = catalog_item);
    
    SELECT catalog_item, catalog.category, customer_name, employees.email, employees.employee_last_name 
    FROM customer_product
      JOIN catalog
        ON catalog.id = end_product_id
      JOIN ingredients
        ON ingredients.ingredient_id = customer_product.ingredient_id
      JOIN ingredient_groups
        ON ingredients.ingredient_group_id = ingredient_groups.id
	  JOIN customers
        ON customers.id = customer_product.customer_id
	  JOIN employees
        ON customers.employee_id = employees.id
        
          
    WHERE LEFT(address, CHAR_LENGTH(group_catalog)) = group_catalog  
    ORDER by email ASC;
    
END //
