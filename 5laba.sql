drop schema public cascade;
create schema public;

create table confectioneries
(
	confectionery_id serial not null primary key,
    address varchar(100) not null
);

create table confectioners
(
	confectioner_id serial not null primary key,
    "name" varchar(100) not null,
    confectionery_id int not null,
	
    foreign key(confectionery_id)
		references confectioneries (confectionery_id)
);

create table couriers
(
	courier_id serial not null primary key,
    "name" varchar(100) not null,
    phone_number char(20) not null,
    confectionery_id int not null,
	
    foreign key(confectionery_id)
		references confectioneries (confectionery_id)
);

create table customers
(
	customer_id serial not null primary key,
    "name" varchar(100) not null,
    phone_number char(20) not null
);

create table internal_components
(
	internal_components_id serial not null primary key,
    "name" varchar(100) not null,
    price float not null
);

create table creams
(
	cream_id int not null primary key,
    taste varchar(100) not null,
    color varchar(100) not null,
	
    foreign key (cream_id)
		references internal_components (internal_components_id)
);

create table fillings
(
	filling_id int not null primary key,
	taste varchar(100) not null,
	
    foreign key (filling_id)
		references internal_components (internal_components_id)
);

create table decors
(
	decor_id int not null primary key,
    "type" varchar(100) not null,
    "size" varchar(100) not null,
    form varchar(100) not null,
	
    foreign key (decor_id)
		references internal_components (internal_components_id)
);

create table baking_forms
(
	baking_form_id serial not null primary key,
    "name" varchar(100) not null
);

create table discounts
(
	discount_id serial not null primary key,
    start_date timestamp,
    expiration_date timestamp,
	discount_size float null
);

create table packages
(
	package_id serial not null primary key,
    "type" varchar(100) not null,
    price float not null 
);

create table "orders"
(
	order_id serial not null primary key,
    date_of_receipt_of_the_order timestamp not null,
    delivery_address varchar(100) not null,
	confectioner_id int not null,
    courier_id int not null,
    customer_id int not null,
    discount_id int,
    package_id int,
    
	foreign key (confectioner_id)
		references confectioners (confectioner_id),
	foreign key (courier_id)
		references couriers (courier_id),
	foreign key (customer_id)
		references customers (customer_id),
	foreign key (package_id) 
		references packages (package_id),
	foreign key (discount_id) 
		references discounts (discount_id)
);

create table product_categories
(
	product_category_id serial not null primary key,
    "name" varchar(100) not null,
    "size" varchar(100) not null,
    price float not null ,
    baking_form_id int not null,
	
    foreign key (baking_form_id)
		references baking_forms (baking_form_id)
);

create table product_categories_internal_components
(
	product_category_id int not null,
    internal_components_id int not null,
    number_of_product_category_internal_components int not null,
	
    foreign key (product_category_id)
		references product_categories (product_category_id),
	foreign key (internal_components_id)
		references internal_components (internal_components_id),
        
	primary key(product_category_id, internal_components_id)
);

create table orders_product_categories
(
	order_id int not null,
	product_category_id int not null,
    number_of_order_product_category int not null,
    
    foreign key (product_category_id)
		references product_categories (product_category_id),
	foreign key (order_id)
		references "orders" (order_id),
        
	primary key (order_id, product_category_id)
);
/*
insert into confectioneries (address)
values
('ул. Зеленая, 15'),
('ул. Мира, 16'),
('ул. Краснознаменская, 4'),
('ул. Ленина, 48'),
('ул. Баумана, 6'),
('ул. Еременко, 55'),
('ул. Короткая, 15'),
('ул. Никольская, 34'),
('ул. Центральная, 13'),
('ул. Школьная, 6');

insert into confectioners ("name", confectionery_ID)
values
('Федорова Елена Владимировна', 1),
('Морозова Ольга Сергеевна', 2),
('Белякова Ярослава Юрьевна', 3),
('Вишнякова Валерия Дмитриевна', 4),
('Панова Николь Романовна', 5),
('Орехов Марк Анатольевич ', 5),
('Панфилов Артем Станиславович', 4),
('Лебедев Игорь Петрович', 3),
('Крюков Евгений Андреевич', 2),
('Ефимов Вячеслав Григорьевич', 1);

insert into couriers ("name", phone_number, confectionery_ID)
values
('Русаков Алексей Геннадьевич', '89615304070', 1),
('Селиверстов Денис Семенович','89615304071', 2),
('Кондратьев Клим Николаевич','89615304072', 3),
('Артемьев Всеволод Степанович','89615304073', 4),
('Власов Станислав Миронович','89615304074', 5),
('Красильников Игорь Дмитриевич','89615304075', 5),
('Николаев Ефрем Егорович','89615304076', 4),
('Прохоркин Арсений Климович','89615304077', 3),
('Романов Егор Антонович','89615304078', 2),
('Зимин Леонид Сергеевич','89615304079', 1);

insert into customers ("name", phone_number)
values
('Михайлов Сергей Николаевич', '89023408789'),
('Гришин Давид Валентинович','89023408788'),
('Соколова Алиса Витальевна','89023408787'),
('Зуева Марта Владимировна','89023408786'),
('Бирюкова Елизавета Валерьевна','89023408785'),
('Кузьмина Алия Михайловна','89023408784'),
('Михеев Юрий Вячеславович','89023408783'),
('Ильина Мия Артемовна','89023408782'),
('Селезнева Вероника Юрьевна','89023408781'),
('Максимов Савелий Иванович','89023408780');

insert into internal_components ("name", price)
values
('крем "Тирамиссу"', 150),
('начинка "Лесные ягоды"', 100),
('крем-чиз', 200),
('декор "Цветы из яблок"', 100),
('начинка "Маршмеллоу"', 100),
('декор "Щенячий патруль"', 250),
('крем "Пломбир"', 150),
('крем "Розовые облака"', 100),
('начинка "Шоколадная"', 100),
('декор "Холодное сердце"', 250);

insert into creams (cream_ID, color, taste)
values
(1,'коричневый', 'шоколадный'),
(3,'белый', 'сливочный'),
(7,'голубой', 'сливочно-молочный'),
(8,'розовый', 'клубничный');

insert into fillings (filling_ID, taste)
values
(2, 'ягодный'),
(5, 'зефирный'),
(9, 'шоколадный');

insert into decors (decor_ID, "type", "size", form)
values
(4, 'фрукты', 'большой', 'цветы'),
(6, 'фигурки из мастики', 'средний', 'персонажи из мультика'),
(10, 'вафельная картинка', 'средний', 'персонажи из мультика');

insert into baking_forms (name)
values
('круглая'),
('квадратная'),
('сердечко'),
('книга'),
('произвольная форма');

insert into discounts (start_date, expiration_date, discount_size)
values
('01.01.2020', '31.12.2021', 0.10),
('01.03.2021', '10.03.2021', 0.20),
('22.02.2021', '24.02.2021', 0.20),
('01.01.2022', NULL, 0.50),
('11.07.2020', '31.12.2020', 0.30),
('21.03.2021', '10.04.2021', 0.15),
('30.06.2017', '24.07.2017', 0.05),
('08.12.2021', '10.12.2021', 0.45),
('10.10.2019', NULL, 0.10),
('15.02.2018', '15.03.2018', NULL);
*/
insert into packages ("type", price)
values
('Праздничная', 200),
('Обычная', 100),
('Свадебная', 500),
('Мужская', 150),
('Женская', 150),
('Новогодняя', 200),
('День Рождения', 200),
('14 февраля', 200),
('Прозрачная', 50),
('Детская', 150);
/*
insert into orders (date_of_receipt_of_the_order, delivery_address, confectioner_ID, courier_ID, customer_ID, package_ID, discount_ID)
values 
('24.03.21 10:30','ул. Краснополянская, 51-12', 1, 1, 1, 3, 5),
('15.12.22 14:40','ул. Ленина, 4-78', 2, 2, 2, 1, 5),
('04.02.20 15:30','ул. Гвардейская, 34-11', 3, 3, 3, 4, 1),
('30.03.21 10:00','ул. Дмитровская, 1-42', 4, 4, 4, NULL, 2),
('13.06.20 17:30','ул. Мира, 14-48', 5, 5, 5, 3, 4),
('14.11.22 11:00','ул. Репина, 18-9', 5, 5, 5, 2, NULL),
('25.03.21 18:30','ул. Зорге, 3-98', 4, 4, 4, 10, 1),
('20.10.21 20:00','ул. Демидова, 11', 3, 3, 3, 1, 5),
('30.12.21 21:00','ул. Сочинская, 33', 2, 2, 2, 6, NULL),
('05.11.22 11:00','ул. Донская, 48', 1, 1, 1, 7, 5);

insert into product_categories ("name", "size", price, baking_form_ID)
values
('торт "Тирамиссу"', 'маленький', 600, 1),
('торт "Бисквит"', 'средний', 800, 1),
('торт "Медовик"', 'маленький', 400, 2),
('торт "Наполеон"', 'большой', 1000, 3),
('пирог', 'средний', 400, 1),
('капкейк "Клубничный"', 'средний', 120, 1),
('пирог', 'маленький', 200, 2),
('пирог', 'большой', 500, 1),
('капкейк "Шоколадный"', 'средний', 120, 1),
('торт "Творожный"', 'маленький', 500, 2);

insert into product_categories_internal_components (product_category_id, internal_components_id, number_of_product_category_internal_components)
values
(1, 1, 2),
(2, 3, 1), 
(2, 10, 1),
(3, 7, 1),
(4, 8, 1),
(4, 9, 1),
(5, 2, 1),
(5, 4, 1),
(5, 9, 1),
(6, 8, 12),
(6, 5, 12),
(7, 2, 2),
(8, 9, 1),
(9, 6, 9),
(9, 3, 9),
(10, 3, 3);

insert into orders_product_categories (order_id, product_category_id, number_of_order_product_category)
values
(1, 1, 2),
(2, 3, 1),
(3, 3, 1),
(4, 4, 1),
(5, 5, 3),
(6, 6, 12),
(7, 3, 2),
(8, 8, 1),
(9, 9, 9),
(10, 10, 3);
*/

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
/*create table confectioneries
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

