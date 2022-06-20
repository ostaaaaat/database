COPY confectioneries (address)
FROM 'C:\confectioneries.csv'
DELIMITER ';'
CSV HEADER;

COPY confectioners ("name", confectionery_id)
FROM 'C:\confectioners.csv'
DELIMITER ','
CSV HEADER;

COPY couriers ("name", phone_number, confectionery_id)
FROM 'C:\couriers.csv'
DELIMITER ','
CSV HEADER;

COPY customers ("name", phone_number)
FROM 'C:\customers.csv'
DELIMITER ','
CSV HEADER;

COPY internal_components ("name", price)
FROM 'C:\internal_components.csv'
DELIMITER ','
CSV HEADER;

COPY creams (taste, color, cream_id)
FROM 'C:\creams.csv'
DELIMITER ','
CSV HEADER;

COPY fillings (taste, filling_id)
FROM 'C:\fillings.csv'
DELIMITER ','
CSV HEADER;

COPY decors ("type", "size", form, decor_id)
FROM 'C:\decors.csv'
DELIMITER ','
CSV HEADER;

COPY baking_forms ("name")
FROM 'C:\baking_forms.csv'
DELIMITER ','
CSV HEADER;

COPY discounts (start_date, expiration_date, discount_size)
FROM 'C:\discounts.csv'
DELIMITER ','
CSV HEADER;

COPY packages ("type", price)
FROM 'C:\packages.csv'
DELIMITER ','
CSV HEADER;

COPY orders (date_of_receipt_of_the_order, delivery_address, confectioner_ID, courier_ID, customer_ID, discount_ID, package_ID)
FROM 'C:\orders.csv'
DELIMITER ','
CSV HEADER;

COPY product_categories ("name", "size", price, baking_form_ID)
FROM 'C:\product_categories.csv'
DELIMITER ','
CSV HEADER;

COPY orders_product_categories (order_id, product_category_id, number_of_order_product_category)
FROM 'C:\orders_product_categories.csv'
DELIMITER ','
CSV HEADER;

COPY product_categories_internal_components (product_category_id, internal_components_id, number_of_product_category_internal_components)
FROM 'C:\product_categories_internal_components.csv'
DELIMITER ','
CSV HEADER;

/* Индексы */
create index ind_add ON confectioneries (address);
--Показать информацию про кондитерскую
EXPLAIN (format json)
SELECT address, confectioners.name AS confectioner, couriers.name AS courier, phone_number AS courier_phone FROM confectioneries 
JOIN confectioners ON confectioneries.confectionery_id=confectioners.confectionery_id
JOIN couriers ON confectioneries.confectionery_id=couriers.confectionery_id
WHERE address LIKE 'Aspen%';

create index ind_date ON orders (date_of_receipt_of_the_order);
--Показать информацию про текущие заказы (за месяц)
EXPLAIN (format json)
SELECT date_of_receipt_of_the_order, delivery_address, "name" AS customer, phone_number AS customer_phone FROM "orders" 
JOIN customers ON orders.customer_id=customers.customer_id
WHERE date_of_receipt_of_the_order>='01.03.2021' AND date_of_receipt_of_the_order<='31.03.2021'
ORDER BY date_of_receipt_of_the_order;

--Выводит заказы, отсортированные по дате
EXPLAIN (format json)
SELECT date_of_receipt_of_the_order, delivery_address, customers.name AS customer, customers.phone_number AS customer_phone
FROM orders JOIN customers ON orders.customer_id=customers.customer_id ORDER BY date_of_receipt_of_the_order;

create index ind_del_add ON orders (delivery_address);
--Выводит заказ по адресу
EXPLAIN (format json)
SELECT * FROM "orders" WHERE delivery_address LIKE '%Collins%';

create index ind_price ON product_categories (price);
--Выводит изделия, отсортированные по цене (по возрастанию)
EXPLAIN (format json)
SELECT * FROM product_categories ORDER BY "name" ASC, price DESC;

create index ind_confectioner ON orders (confectioner_id);
--Сумма заработка кондитеров
EXPLAIN (format json)
SELECT confectioner, SUM(summa) FROM
(SELECT confectioners.name AS confectioner,
SUM(((number_of_order_product_category * product_categories.price) + (number_of_product_category_internal_components * internal_components.price) + packages.price) * (1 - discount_size)) AS summa
FROM orders_product_categories
JOIN orders ON orders.order_id=orders_product_categories.order_id
JOIN product_categories ON product_categories.product_category_id=orders_product_categories.product_category_id
JOIN product_categories_internal_components ON orders_product_categories.product_category_id=product_categories_internal_components.product_category_id
JOIN internal_components ON internal_components.internal_components_id=product_categories_internal_components.internal_components_id
JOIN discounts ON orders.discount_id=discounts.discount_id
JOIN packages ON orders.package_id=packages.package_id
JOIN confectioners ON orders.confectioner_id=confectioners.confectioner_id
GROUP BY confectioners.name) AS confectioner_orders
GROUP BY confectioner
ORDER BY "sum" DESC;

create index ind_customer ON orders (customer_id);
--Выводит топ 3 заказчиков и количество их заказов. Группировка по заказчику.
EXPLAIN (format json)
SELECT customers.name AS customer, COUNT(orders.customer_id) AS "count" FROM orders 
JOIN customers ON orders.customer_id=customers.customer_id GROUP BY customers.name LIMIT 3;

create index ind_confectionery ON confectioners (confectionery_id);
create index ind_confectionery_c ON couriers (confectionery_id);
--Выводит кондитеров и курьеров, работающих в кондитерской с id = 3
EXPLAIN (format json)
SELECT confectionery_id, "name" FROM confectioners WHERE confectionery_id = 5
UNION SELECT confectionery_id, "name" FROM couriers WHERE confectionery_id = 5;

create index ind_discount ON orders (discount_id);
--Выводит самую популярную скидку с размером и количеством повторов
EXPLAIN (format json)
SELECT discounts.discount_size AS discount, COUNT(discounts.discount_size) AS "count" FROM orders 
JOIN discounts ON orders.discount_id=discounts.discount_id GROUP BY discounts.discount_size ORDER BY "count" DESC LIMIT 1;


/* Представления */ 
--Выводит список текущих заказов по адресу Vine Hill
CREATE VIEW current_order
AS
SELECT date_of_receipt_of_the_order, delivery_address, "name" AS customer, phone_number AS customer_phone FROM "orders" 
JOIN customers ON orders.customer_id=customers.customer_id
WHERE delivery_address LIKE 'Vine%Hill';

SELECT * FROM current_order;

--Выводит все внутренние компоненты с описанием
CREATE VIEW all_internal_components
AS
SELECT internal_components.name AS "name", creams.taste AS "taste_type", creams.color AS "size_color", '-' AS "form", price FROM internal_components
INNER JOIN creams ON creams.cream_id=internal_components.internal_components_id
UNION 
SELECT internal_components.name AS "name", decors.type AS  "taste_type", decors.size AS "size_color", decors.form AS "form", price FROM internal_components 
INNER JOIN decors ON decors.decor_id=internal_components.internal_components_id
UNION
SELECT internal_components.name AS "name", fillings.taste AS  "taste_type",'-' AS "size_color", '-' AS "form", price FROM internal_components 
INNER JOIN fillings ON fillings.filling_id=internal_components.internal_components_id;

SELECT * FROM all_internal_components;

--Отчет за месяц
CREATE VIEW report
AS
SELECT date_of_receipt_of_the_order,
product_categories.name AS product_category, number_of_order_product_category AS count_product_categories, product_categories.price AS price_product_categories, SUM(number_of_order_product_category * product_categories.price) AS sum_product_categories,
internal_components.name AS internal_components, number_of_product_category_internal_components AS count_internal_components, internal_components.price AS price_internal_components, SUM(number_of_product_category_internal_components * internal_components.price) AS sum_internal_components,
discount_size, packages.price AS price_packages, SUM((number_of_order_product_category * product_categories.price) + (number_of_product_category_internal_components * internal_components.price) + packages.price) AS summa,
SUM(((number_of_order_product_category * product_categories.price) + (number_of_product_category_internal_components * internal_components.price) + packages.price)*discount_size) AS discount,
SUM(((number_of_order_product_category * product_categories.price) + (number_of_product_category_internal_components * internal_components.price) + packages.price) - (((number_of_order_product_category * product_categories.price) + (number_of_product_category_internal_components * internal_components.price) + packages.price)*discount_size))
FROM orders_product_categories
JOIN orders ON orders.order_id=orders_product_categories.order_id
JOIN product_categories ON product_categories.product_category_id=orders_product_categories.product_category_id
JOIN product_categories_internal_components ON orders_product_categories.product_category_id=product_categories_internal_components.product_category_id
JOIN internal_components ON internal_components.internal_components_id=product_categories_internal_components.internal_components_id
JOIN discounts ON orders.discount_id=discounts.discount_id
JOIN packages ON orders.package_id=packages.package_id
WHERE date_of_receipt_of_the_order>='01.03.2021' AND date_of_receipt_of_the_order<='31.03.2021' 
GROUP BY date_of_receipt_of_the_order, product_categories.name, number_of_order_product_category, product_categories.price, internal_components.name, 
number_of_product_category_internal_components, internal_components.price, discount_size, packages.type, packages.price
ORDER BY date_of_receipt_of_the_order;

SELECT * FROM report;

/* Триггеры */
/*
create table confectioneries
(
	confectionery_id serial not null primary key,
    address varchar(100) not null
);*/

create table confectioneries_audits
(
	conf_id serial not null primary key,
	confectionery_id int not null,
    address varchar(100) not null,
	changed_on TIMESTAMP(6) NOT NULL
);

CREATE OR REPLACE FUNCTION log_address_changes()
  RETURNS TRIGGER 
  LANGUAGE PLPGSQL
  AS
$$
BEGIN
	IF NEW.address <> OLD.address THEN
		 INSERT INTO confectioneries_audits(confectionery_id,address,changed_on)
		 VALUES(OLD.confectionery_id,OLD.address,now());
	END IF;

	RETURN NEW;
END;
$$;

CREATE TRIGGER address_changes
  BEFORE UPDATE
  ON confectioneries
  FOR EACH ROW
  EXECUTE PROCEDURE log_address_changes();

UPDATE confectioneries
SET address = 'Vinsent Avenue'
WHERE confectionery_id = 2;

UPDATE confectioneries
SET address = 'Anney Hill'
WHERE confectionery_id = 3;

select * from confectioneries_audits;


/* Процедуры */
--Выдать упаковки с заданной пользователем ценой
CREATE PROCEDURE pac (a int)
	LANGUAGE sql
	AS $$
	SELECT * FROM packages WHERE price = a;
	$$;

call pac(150);

--Выдать данные про внутренние компоненты по заданному названию
CREATE PROCEDURE int_com ("name" varchar(60))
	LANGUAGE sql
	AS $$
	SELECT internal_components.name AS "name", taste, color, price FROM internal_components
	JOIN creams ON creams.cream_id=internal_components.internal_components_id
	WHERE internal_components.name = "name";
	$$;

call int_com('KFC');

--Выводит данные про изделия (форму, размер, внутренние компоненты) по заданному названию
CREATE PROCEDURE prod_categ (b varchar(60))
	LANGUAGE sql
	AS $$
	SELECT product_categories.name AS product_category, "size", baking_forms.name AS baking_form, internal_components.name AS internal_components,
	product_categories_internal_components.number_of_product_category_internal_components AS "count"
	FROM product_categories_internal_components
	JOIN product_categories ON product_categories.product_category_id=product_categories_internal_components.product_category_id
	JOIN internal_components ON internal_components.internal_components_id=product_categories_internal_components.internal_components_id
	JOIN baking_forms ON product_categories.baking_form_id=baking_forms.baking_form_id
	WHERE product_categories.name = b;
	$$;

call prod_categ('Portland');

/* Функции */
--Выдать тип внутреннего компонента
CREATE OR REPLACE FUNCTION item_type(internal_components_id int) RETURNS varchar(20) AS $$
DECLARE "type" varchar(30);

BEGIN
	if internal_components_id > 6666 then
		"type" :='начинка';
	elseif internal_components_id < 3334 then
		"type" :='крем';
	elseif internal_components_id >= 3334 AND internal_components_id <= 6666 then
		"type" :='декор';
	end if;
    
	return(type);
END;
$$ LANGUAGE plpgsql;

SELECT internal_components_id, internal_components.name AS "name", item_type(internal_components_id) as "type", price 
FROM internal_components
LEFT JOIN creams ON creams.cream_id=internal_components.internal_components_id
LEFT JOIN fillings ON fillings.filling_id=internal_components.internal_components_id
LEFT JOIN decors ON decors.decor_id=internal_components.internal_components_id;

--Определяет тип заказа: масштабный или обычный (по количеству изделий в заказе)
CREATE OR REPLACE FUNCTION count_type("count" int) RETURNS varchar(60) AS $$
DECLARE "type" varchar(60);

BEGIN
	if "count" < 5 then
		"type" :='обычный';
	elseif "count" > 5 then
		"type" :='масштабный';
	end if;
    
	return(type);
END;
$$ LANGUAGE plpgsql;

SELECT orders.date_of_receipt_of_the_order, number_of_order_product_category AS "count", count_type(number_of_order_product_category)
FROM orders_product_categories
JOIN orders ON orders.order_id=orders_product_categories.order_id;

--Увеличить цену в зависимости от ее величины
CREATE OR REPLACE FUNCTION new_price(price float) RETURNS float AS $$
BEGIN
	if price >= 200 then
		return price + 50;
	elseif price < 200 then
		return price + 100;
	end if;
END;
$$ LANGUAGE plpgsql;

SELECT packages.type AS "name", packages.price AS "old_price", new_price(price) as "new_price" 
FROM packages;

/* Модификация */
create index ind_size ON product_categories ("size");
--1. Индексы. Вывести все категории продуктов с заданными диапазоном цен и размеров
EXPLAIN (format json)
SELECT product_categories.name AS product_category, "size", baking_forms.name AS baking_form, price
FROM product_categories
JOIN baking_forms ON product_categories.baking_form_id=baking_forms.baking_form_id
WHERE (price BETWEEN 150 AND 300) AND ("size" = 'M')
ORDER BY price;

--2. Процедуры и функции. написать процедуру (передаем id заказчика, а через 2 out параметра возвращаем количество заказов и их сумму )
CREATE VIEW report_customers
AS
SELECT customer, count_order, SUM(summa) FROM
(SELECT customers.customer_id AS customer, COUNT(orders.customer_id) AS count_order,
SUM(((number_of_order_product_category * product_categories.price) + (number_of_product_category_internal_components * internal_components.price) + packages.price) * (1 - discount_size)) AS summa
FROM orders_product_categories
JOIN orders ON orders.order_id=orders_product_categories.order_id
JOIN product_categories ON product_categories.product_category_id=orders_product_categories.product_category_id
JOIN product_categories_internal_components ON orders_product_categories.product_category_id=product_categories_internal_components.product_category_id
JOIN internal_components ON internal_components.internal_components_id=product_categories_internal_components.internal_components_id
JOIN discounts ON orders.discount_id=discounts.discount_id
JOIN packages ON orders.package_id=packages.package_id
JOIN customers ON orders.customer_id=customers.customer_id
GROUP BY customers.customer_id) AS customer_orders
GROUP BY customer, count_order;

select * from report_customers;

CREATE OR REPLACE FUNCTION customer_order (customer_id int) RETURNS table (order_count bigint, order_sum float) AS $$
BEGIN
	RETURN query
	SELECT count_order, "sum" FROM report_customers WHERE report_customers.customer = customer_id;
END;
$$ LANGUAGE plpgsql;

SELECT * FROM customer_order(196);

--3. Триггеры. При добавлении продукта определенной категории (свадебный торт) в заказ, менять тип упаковки на соответствующий(свадебная)
CREATE OR REPLACE FUNCTION update_package()
  RETURNS TRIGGER 
  LANGUAGE PLPGSQL
  AS
$$
DECLARE product_name varchar(100);
BEGIN
	SELECT "name" INTO product_name FROM product_categories WHERE product_category_id = NEW.product_category_id;
	IF product_name = 'Miami' THEN
		UPDATE orders SET package_id = 3 WHERE orders.order_id = NEW.order_id ;
	END IF;

	RETURN NEW;
END;
$$;

CREATE TRIGGER packages_changes
  BEFORE INSERT OR UPDATE
  ON orders_product_categories
  FOR EACH ROW
  EXECUTE PROCEDURE update_package();

select * from orders WHERE order_id = 4;

insert into orders_product_categories (order_id, product_category_id, number_of_order_product_category)
values
(4, 8, 2);

select * from orders WHERE order_id = 4;
