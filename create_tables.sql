CREATE DATABASE products_ingredients;

USE products_ingredients;

-- 1. клиенты компании
CREATE TABLE customers (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,  
  customer_name VARCHAR(100) NOT NULL,
  employee_id INTEGER,
  created_at DATETIME DEFAULT NOW(),
  updated_at DATETIME DEFAULT NOW() ON UPDATE NOW()
);


-- 2. сотрудники компании
CREATE TABLE employees (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  employee_name VARCHAR(100) NOT NULL,
  employee_last_name VARCHAR(100) NOT NULL,
  email VARCHAR(120) NOT NULL UNIQUE,
  created_at DATETIME DEFAULT NOW(),
  updated_at DATETIME DEFAULT NOW() ON UPDATE NOW()
);


-- 3. Список должностей
CREATE TABLE positions (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  group_name VARCHAR(100) NOT NULL
  );

-- 4. Штатное расписание. Таблица будет нужна для рапсределения прав
CREATE TABLE employee_position (
  position_id INT UNSIGNED NOT NULL,
  user_id INT UNSIGNED NOT NULL,
  PRIMARY KEY (position_id, user_id)
);

-- 5. таблица ингредиентов. В реальности это справочник с большим кол-вом полей, 
-- но для целей данной работы это не требуется
CREATE TABLE ingredients (
  ingredient_id INT UNSIGNED NOT NULL,
  ingredient_group_id INT UNSIGNED NOT NULL,
  PRIMARY KEY (ingredient_id, ingredient_group_id)
  );  

-- 6. таблица групп ингридиентов (ароматизаторы, красители, желатины и пр)
CREATE TABLE ingredient_groups (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  group_name VARCHAR(150) NOT NULL,
  group_description TEXT NOT NULL
  );  


-- 7. Продукты, которые производит клиент с использованием наших ингредиентов. кандидат на исправление
CREATE TABLE customer_product (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  end_product_id INT UNSIGNED NOT NULL,
  customer_id INT UNSIGNED NOT NULL,
  ingredient_id INT,
  product_description TEXT
  
);
-- 8. Ингредиенты, которые поставляем клиенту мы
CREATE TABLE customer_ingredient (
  ingredient_id INT UNSIGNED NOT NULL,
  customer_id INT UNSIGNED NOT NULL,
  
  PRIMARY KEY (ingredient_id, customer_id)
  );

-- 9. Таблица продаж. 
CREATE TABLE sales (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  customer_id INT UNSIGNED NOT NULL,
  ingredient_id INT UNSIGNED NOT NULL,
  quantity DECIMAL(10,2) NOT NULL,
  price DECIMAL(7,2) NOT NULL,
  created_at DATETIME DEFAULT NOW()
  );

-- 10. создаем таблицу дозировок ингридиентов в конечные продукты  
CREATE TABLE portfolio (
  employee_id INT UNSIGNED NOT NULL,
  end_product_id INT UNSIGNED NOT NULL,
  ingredient_id INT UNSIGNED NOT NULL,
  dosage_g_per_100_kg_min INT,
  dosage_g_per_100_kg_max INT,
  descript TEXT NOT NULL,
  created_at DATETIME DEFAULT NOW(),
  updated_at DATETIME DEFAULT NOW() ON UPDATE NOW(),
  PRIMARY KEY (employee_id, end_product_id, ingredient_id)
  );
  
  ALTER TABLE portfolio
  ADD COLUMN employee_position_id INT UNSIGNED NOT NULL
  ;
  
  -- 11. Создаем каталог типов конечных товаров, где в поле address указываем родство каждого элемента с другими элементами этой таблицы.
  -- Такая запись потребуется исходя из специфики задачи. В таблицу customer_product мы будем по возможности вносить предельно конкретные значения(например, майонез), 
  -- но если данных недостаточно, тогда в этом же поле мы будем указывать родительское значение(например, соусы). При этом при запросе к базе по категории соусы мы хотим, чтобы нам показались
  -- записи и для соусов и для майонезов.
   
CREATE TABLE catalog (
  ID INT NOT NULL PRIMARY KEY,
  Category VARCHAR(50),
  Address VARCHAR(20)
);
