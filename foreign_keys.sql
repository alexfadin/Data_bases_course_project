ALTER TABLE sales
  MODIFY COLUMN customer_id INT(10) UNSIGNED,
  MODIFY COLUMN ingredient_id INT(10) UNSIGNED,
  ADD CONSTRAINT sales_customer_id_fk 
    FOREIGN KEY (customer_id) REFERENCES customers(id)
      ON DELETE SET NULL,
  ADD CONSTRAINT sales_ingredient_id_fk
    FOREIGN KEY (ingredient_id) REFERENCES ingredients(ingredient_id)
      ON DELETE SET NULL;
      
ALTER TABLE portfolio
  ADD CONSTRAINT portfolio_end_product_id_fk
    FOREIGN KEY (end_product_id) REFERENCES catalog(ID)
      ON DELETE CASCADE,  
  ADD CONSTRAINT portfolio_employee_id_fk
    FOREIGN KEY (employee_id) REFERENCES employees(id)
      ON DELETE CASCADE,
  ADD CONSTRAINT portfolio_ingredient_id_fk
    FOREIGN KEY (ingredient_id) REFERENCES ingredients(ingredient_id)
      ON DELETE CASCADE;

ALTER TABLE portfolio
  ADD CONSTRAINT portfolio_employee_id_fk
    FOREIGN KEY (employee_id) REFERENCES employees(id);

ALTER TABLE customer_product
  ADD CONSTRAINT customer_product_end_product_id_fk
    FOREIGN KEY (end_product_id) REFERENCES catalog(ID)
      ON DELETE CASCADE,  
  ADD CONSTRAINT customer_product_customer_id_fk 
    FOREIGN KEY (customer_id) REFERENCES customers(id)
      ON DELETE CASCADE,
  ADD CONSTRAINT customer_product_ingredient_id_fk
    FOREIGN KEY (ingredient_id) REFERENCES ingredients(ingredient_id)
      ON DELETE CASCADE;
      
ALTER TABLE employees
  ADD CONSTRAINT emloyee_id_position_id_fk
    FOREIGN KEY (position_id) REFERENCES positions(ID)
      ON DELETE CASCADE;
      
ALTER TABLE ingredients
  ADD CONSTRAINT ingredient_id_group_id_fk
    FOREIGN KEY (ingredient_group_id) REFERENCES ingredient_groups(ID)
      ON DELETE CASCADE;

ALTER TABLE customers
  ADD CONSTRAINT customer_emloyee_id_fk
    FOREIGN KEY (employee_id) REFERENCES employees(id)
      ON DELETE CASCADE;  
