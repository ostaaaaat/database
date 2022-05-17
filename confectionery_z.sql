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
    start_date date,
    expiration_date date,
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

--Дополнительные таблицы
create table services
(
	service_id serial not null primary key,
    "type" varchar(100) not null,
    price float not null 
);

create table districts
(
	district_id serial not null primary key,
    "name" varchar(100) not null,
	addresses varchar(100) not null
);

create table deliveries
(
	delivery_id serial not null primary key,
	district_id int not null,
    price float not null,

	foreign key (district_id) 
		references districts (district_id)
);

create table discounts_pr
(
	discount_pr_id serial not null primary key,
    "size" float not null
);

create table copy_product_categories
(
	copy_product_category_id serial not null primary key,
    "name" varchar(100) not null,
    "size" varchar(100) not null,
    price float not null,
    baking_form_id int not null,
	discount_pr_id int,
	
    foreign key (baking_form_id)
		references baking_forms (baking_form_id),
	foreign key (discount_pr_id) 
		references discounts_pr (discount_pr_id)
);

create table dop_orders
(
	dop_order_id serial not null primary key,
    "date" timestamp not null,
    address varchar(100) not null,
	confectioner_id int not null,
    courier_id int not null,
    customer_id int not null,
    discount_id int,
   	package_id int,
	service_id int,
	district_id int not null, 
    
	foreign key (confectioner_id)
		references confectioners (confectioner_id),
	foreign key (courier_id)
		references couriers (courier_id),
	foreign key (customer_id)
		references customers (customer_id),
	foreign key (package_id) 
		references packages (package_id),
	foreign key (discount_id) 
		references discounts (discount_id),
	foreign key (service_id) 
		references services (service_id),
	foreign key (district_id) 
		references districts (district_id)
);

create table dop_orders_copy_product_categories
(
	dop_order_id int not null,
	copy_product_category_id int not null,
    number_of_order_product_category int not null,
    
    foreign key (copy_product_category_id)
		references copy_product_categories (copy_product_category_id),
	foreign key (dop_order_id)
		references dop_orders (dop_order_id),
        
	primary key (dop_order_id, copy_product_category_id)
);

create table copy_product_categories_internal_components
(
	copy_product_category_id int not null,
    internal_components_id int not null,
    number_of_product_category_internal_components int not null,
    foreign key (copy_product_category_id)
		references copy_product_categories (copy_product_category_id),
	foreign key (internal_components_id)
		references internal_components (internal_components_id),
        
	primary key(copy_product_category_id, internal_components_id)
);
	
insert into services ("type", price)
values
('Гелиевые шары', 500),
('Деревянный топпер', 250),
('Картонный топпер', 150),
('Маленькая кукла', 200),
('Плюшевый мишка', 200),
('Свадебные лебеди', 150),
('Живые цветы', 100),
('Топпер-сердце', 100);

insert into districts ("name", addresses)
values
('Краснооктябрьский', 'Сочинская, Репина, Зорге'),
('Дзержинский', 'Краснополянская, Никольская, Короткая'),
('Красноармейский', 'Зеленая, Иванова, Донская'),
('Ворошиловский', 'Школьная, Центральная, Дмитровская'),
('Тракторозаводский', 'Демидова, Гейне, Баумана'),
('Центральный', 'Ленина, Мира, Гвадейская'),
('Советский', 'Еременко, Краснознаменская, Мухина');

insert into deliveries (district_id, price)
values
(1, 100),
(2, 150),
(3, 250),
(4, 100),
(5, 150),
(6, 100),
(7, 200);

insert into discounts_pr ("size")
values
(0.10),
(0.20),
(0.30),
(0.40),
(0.50),
(0.60);

insert into copy_product_categories ("name", "size", price, baking_form_id, discount_pr_id)
values 
('торт "Тирамиссу"', 'маленький', 600, 1, 3),
('торт "Бисквит"', 'средний', 800, 1, 5),
('торт "Медовик"', 'маленький', 400, 2, 2),
('торт "Наполеон"', 'большой', 1000, 3, 4),
('пирог', 'средний', 400, 1, 1),
('капкейк "Клубничный"', 'средний', 120, 1, NULL),
('пирог', 'маленький', 200, 2, NULL),
('пирог', 'большой', 500, 1, NULL),
('капкейк "Шоколадный"', 'средний', 120, 1, 6),
('торт "Творожный"', 'маленький', 500, 2, NULL);
	
insert into dop_orders ("date", address, confectioner_ID, courier_ID, customer_ID, package_ID, discount_ID, service_id, district_id)
values 
('24.03.21 10:30','ул. Краснополянская, 51-12', 1, 1, 1, 3, 5, 1, 2),
('15.12.22 14:40','ул. Ленина, 4-78', 2, 2, 2, 1, 5, 2, 6),
('04.02.20 15:30','ул. Гвардейская, 34-11', 3, 3, 3, 4, 1, NULL, 6),
('30.03.21 10:00','ул. Дмитровская, 1-42', 4, 4, 4, NULL, 2, 4, 4),
('13.06.20 17:30','ул. Мира, 14-48', 5, 5, 5, 3, 4, 5, 6),
('14.11.22 11:00','ул. Репина, 18-9', 5, 5, 5, 2, NULL, NULL, 1),
('25.03.21 18:30','ул. Зорге, 3-98', 4, 4, 4, 10, 1, 8, 1),
('20.10.21 20:00','ул. Демидова, 11', 3, 3, 3, 1, 5, 1, 5),
('30.12.21 21:00','ул. Сочинская, 33', 2, 2, 2, 6, NULL, 2, 1),
('05.11.22 11:00','ул. Донская, 48', 1, 1, 1, 7, 5, NULL, 3);

insert into dop_orders_copy_product_categories (dop_order_id, copy_product_category_id, number_of_order_product_category)
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

insert into copy_product_categories_internal_components (copy_product_category_id, internal_components_id, number_of_product_category_internal_components)
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

--Показать информацию про кондитерскую
SELECT address, confectioners.name AS confectioner, couriers.name AS courier, phone_number AS courier_phone FROM confectioneries 
JOIN confectioners ON confectioneries.confectionery_id=confectioners.confectionery_id
JOIN couriers ON confectioneries.confectionery_id=couriers.confectionery_id
WHERE address LIKE '%Мира%';

--Показать информацию про ассортимент изделий
SELECT "name", price FROM product_categories;

--Показать информацию про ассортимент начинок;
SELECT internal_components.name AS "name", taste, price FROM internal_components 
JOIN fillings ON fillings.filling_id=internal_components.internal_components_id;

--Показать информацию о конкретном заказе
SELECT date_of_receipt_of_the_order, delivery_address, customers.name AS customer, phone_number AS customer_phone, 
product_categories.name AS product_category, number_of_order_product_category AS "count" FROM "orders" 
JOIN customers ON orders.customer_id=customers.customer_id
JOIN orders_product_categories ON orders.order_id=orders_product_categories.order_id
JOIN product_categories ON product_categories.product_category_id=orders_product_categories.product_category_id
WHERE date_of_receipt_of_the_order='14.11.2022 11:00:00';

--Показать информацию про текущие заказы(за месяц)
SELECT date_of_receipt_of_the_order, delivery_address, "name" AS customer, phone_number AS customer_phone FROM "orders" 
JOIN customers ON orders.customer_id=customers.customer_id
WHERE date_of_receipt_of_the_order>='01.03.2021' AND date_of_receipt_of_the_order<='31.03.2021';

--Рассчитать полную стоимость заказа
SELECT date_of_receipt_of_the_order,
SUM(number_of_order_product_category * product_categories.price) AS sum_product_categories,
SUM(number_of_product_category_internal_components * internal_components.price) AS sum_internal_components,
packages.price AS price_packages, SUM((number_of_order_product_category * product_categories.price) + (number_of_product_category_internal_components * internal_components.price) + packages.price) AS summa,
SUM(((number_of_order_product_category * product_categories.price) + (number_of_product_category_internal_components * internal_components.price) + packages.price)*discount_size) AS discount,
SUM(((number_of_order_product_category * product_categories.price) + (number_of_product_category_internal_components * internal_components.price) + packages.price) - (((number_of_order_product_category * product_categories.price) + (number_of_product_category_internal_components * internal_components.price) + packages.price)*discount_size))
FROM orders_product_categories
JOIN orders ON orders.order_id=orders_product_categories.order_id
JOIN product_categories ON product_categories.product_category_id=orders_product_categories.product_category_id
JOIN product_categories_internal_components ON orders_product_categories.product_category_id=product_categories_internal_components.product_category_id
JOIN internal_components ON internal_components.internal_components_id=product_categories_internal_components.internal_components_id
JOIN discounts ON orders.discount_id=discounts.discount_id
JOIN packages ON orders.package_id=packages.package_id
WHERE orders.order_id = 3 
GROUP BY date_of_receipt_of_the_order, product_categories.name, number_of_order_product_category, product_categories.price, internal_components.name, 
number_of_product_category_internal_components, internal_components.price, discount_size, packages.type, packages.price;

--Показать отчетный доход за месяц
SELECT date_of_receipt_of_the_order,
product_categories.name AS product_category, number_of_order_product_category AS count_product_categories, product_categories.price AS price_product_categories, SUM(number_of_order_product_category * product_categories.price) AS sum_product_categories,
internal_components.name AS internal_components, number_of_product_category_internal_components AS count_internal_components, internal_components.price AS price_internal_components, SUM(number_of_product_category_internal_components * internal_components.price) AS sum_internal_components,
discount_size, packages.type, packages.price AS price_packages, SUM((number_of_order_product_category * product_categories.price) + (number_of_product_category_internal_components * internal_components.price) + packages.price) AS summa,
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
number_of_product_category_internal_components, internal_components.price, discount_size, packages.type, packages.price;

--Показать самый популярный размер тортов
SELECT product_categories.size, COUNT(product_categories.size) AS "count" FROM orders_product_categories
JOIN product_categories ON product_categories.product_category_id=orders_product_categories.product_category_id 
GROUP BY product_categories.size ORDER BY "count" DESC LIMIT 1;

--Показать самую популярную категорию изделий
SELECT product_categories.name, COUNT(product_categories.product_category_id) AS "count" FROM orders_product_categories
JOIN product_categories ON product_categories.product_category_id=orders_product_categories.product_category_id 
GROUP BY product_categories.product_category_id ORDER BY "count" DESC LIMIT 1;

--Показать наиболее популярные наполнения
SELECT product_categories_internal_components.internal_components_id, COUNT(product_categories_internal_components.internal_components_id) AS "count" 
FROM product_categories_internal_components
GROUP BY product_categories_internal_components.internal_components_id ORDER BY "count" DESC LIMIT 3;

--UPDATE
UPDATE creams SET taste='абрикосовый', color='оранжевый' WHERE taste='клубничный';
UPDATE confectioners SET "name"='Афанасьева Ирина Геннадьевна' WHERE "name"='Морозова Ольга Сергеевна';
UPDATE internal_components SET price=500 WHERE "name"='декор "Щенячий патруль"';
UPDATE baking_forms SET "name"='ромб' WHERE "name"='произвольная форма';
UPDATE packages SET price=350 WHERE 'type'='Новогодняя';
--DELETE
DELETE FROM confectioneries WHERE address='ул.Никольская,34';
DELETE FROM confectioners WHERE "name"='Орехов Марк Анатольевич';
DELETE FROM couriers WHERE "name"='Романов Егор Антонович';
DELETE FROM customers WHERE customer_id>8;
DELETE FROM packages WHERE "type"='Женская';
--SELECT (WHERE)
SELECT * FROM decors;
SELECT * FROM internal_components WHERE price=100;
SELECT "name", phone_number FROM customers WHERE customer_id<8;
--DISTINCT
SELECT DISTINCT "size" FROM product_categories;
SELECT COUNT(DISTINCT confectioner_id) FROM orders;
--AND/OR/NOT
SELECT * FROM "orders" WHERE confectioner_id=2 AND courier_id=2;
SELECT * FROM product_categories WHERE "name"='пирог' AND baking_form_id=2;
SELECT * FROM discounts WHERE start_date>='01.01.2021' AND expiration_date<='31.12.2021';
SELECT * FROM product_categories WHERE 	"size"='маленький' OR baking_form_id=3;
SELECT * FROM creams WHERE taste='шоколадный' OR color='белый';
SELECT * FROM internal_components WHERE price NOT IN(200, 250);
SELECT * FROM couriers WHERE confectionery_id NOT BETWEEN 2 AND 4;
--IN
SELECT * FROM discounts WHERE discount_size IN(0.10, 0.30);
SELECT * FROM product_categories WHERE "size" IN('маленький', 'большой');
--BETWEEN
SELECT * FROM "orders" WHERE date_of_receipt_of_the_order BETWEEN '01.01.2022' AND '31.12.2022';
SELECT * FROM customers WHERE "name" BETWEEN 'A' AND 'К';
--IS NULL
SELECT * FROM "orders" WHERE package_id IS NULL;
SELECT * FROM discounts WHERE expiration_date IS NULL;
--AS
SELECT discount_size AS "size" FROM discounts;
SELECT taste AS cream_taste, color AS cream_color FROM creams;
--LIKE
SELECT * FROM internal_components WHERE "name" LIKE 'крем%';
SELECT * FROM product_categories WHERE "name" NOT LIKE 'пирог%' AND "size" LIKE 'средний';
SELECT * FROM "orders" WHERE delivery_address LIKE '%Сочинская%';
SELECT * FROM decors WHERE "type" LIKE '%мастик%';
SELECT "name" FROM internal_components WHERE "name" LIKE '%ягод%';
--SELECT INTO
SELECT * INTO copy_decors FROM decors;
SELECT * INTO copy_orders FROM "orders" WHERE 1=0;
--JOIN: INNER, OUTER (LEFT, RIGHT, FULL), CROSS, NATURAL
SELECT date_of_receipt_of_the_order, delivery_address, confectioners.name AS confectioner, couriers.name AS courier, couriers.phone_number AS courier_phone,
customers.name AS customer, customers.phone_number AS customer_phone, discount_size, packages.type AS package
FROM orders
JOIN confectioners ON orders.confectioner_id=confectioners.confectioner_id
JOIN couriers ON orders.courier_id=couriers.courier_id
JOIN customers ON orders.customer_id=customers.customer_id
JOIN discounts ON orders.discount_id=discounts.discount_id
JOIN packages ON orders.package_id=packages.package_id;

SELECT product_categories.name AS categories, "size", price, baking_forms.name AS baking_form FROM product_categories
JOIN baking_forms ON product_categories.baking_form_id=baking_forms.baking_form_id;

SELECT date_of_receipt_of_the_order, delivery_address, product_categories.name AS product_category, "size", number_of_order_product_category AS "count" 
FROM orders_product_categories
JOIN orders ON orders.order_id=orders_product_categories.order_id
JOIN product_categories ON product_categories.product_category_id=orders_product_categories.product_category_id;

SELECT internal_components.name AS "name", taste, color, price FROM internal_components
JOIN creams ON creams.cream_id=internal_components.internal_components_id;

SELECT internal_components.name AS "name", "type", "size", form, price FROM internal_components 
JOIN decors ON decors.decor_id=internal_components.internal_components_id;

SELECT internal_components.name AS "name", taste, price FROM internal_components 
JOIN fillings ON fillings.filling_id=internal_components.internal_components_id;

SELECT product_categories.name AS product_category, "size", baking_forms.name AS baking_form, internal_components.name AS internal_components,
product_categories_internal_components.number_of_product_category_internal_components AS "count"
FROM product_categories_internal_components
JOIN product_categories ON product_categories.product_category_id=product_categories_internal_components.product_category_id
JOIN internal_components ON internal_components.internal_components_id=product_categories_internal_components.internal_components_id
JOIN baking_forms ON product_categories.baking_form_id=baking_forms.baking_form_id;

SELECT internal_components.name AS "name", creams.taste AS cream_taste, creams.color AS cream_color, decors.type AS decor_type, decors.size AS decor_size,
decors.form AS decor_form, fillings.taste AS filling_taste, price FROM internal_components
LEFT JOIN creams ON creams.cream_id=internal_components.internal_components_id
LEFT JOIN fillings ON fillings.filling_id=internal_components.internal_components_id
LEFT JOIN decors ON decors.decor_id=internal_components.internal_components_id;

SELECT date_of_receipt_of_the_order, "type" FROM orders
RIGHT JOIN packages ON orders.package_id=packages.package_id;

SELECT product_categories.name AS categories, baking_forms.name AS baking_form FROM product_categories
RIGHT JOIN baking_forms ON product_categories.baking_form_id=baking_forms.baking_form_id;

SELECT date_of_receipt_of_the_order, start_date, expiration_date, discount_size FROM orders
FULL JOIN discounts ON orders.discount_id=discounts.discount_id;

SELECT confectioners.name AS confectioner, couriers.name AS couriers FROM confectioners
CROSS JOIN couriers
WHERE confectioners.confectionery_id=1 AND couriers.confectionery_id=1;

SELECT product_categories.name AS product_category, "size", baking_forms.name AS baking_form FROM product_categories
CROSS JOIN baking_forms
WHERE product_categories.name LIKE 'пирог%' AND (baking_forms.baking_form_id=1 OR baking_forms.baking_form_id=2);

SELECT address, confectioners.name AS confectioner FROM confectioneries
NATURAL JOIN confectioners;

SELECT address, couriers.name AS courier FROM confectioneries
NATURAL JOIN couriers;

--GROUP BY
SELECT product_categories.size, SUM(price) AS "sum" FROM product_categories GROUP BY product_categories.size;

SELECT couriers.name AS courier, COUNT(delivery_address) AS "count_of_orders" FROM orders 
JOIN couriers ON orders.courier_id=couriers.courier_id GROUP BY couriers.name;
--HAVING
SELECT confectioners.confectionery_id, COUNT(confectioners.confectionery_id) AS "count" FROM confectioners
JOIN confectioneries ON confectioners.confectionery_id=confectioneries.confectionery_id 
GROUP BY confectioners.confectionery_id HAVING confectioners.confectionery_id>=3;

SELECT discounts.discount_size, MIN(start_date) AS start_date FROM discounts GROUP BY discounts.discount_size HAVING discounts.discount_size >= 0.15;
--LIMIT
SELECT customers.name AS customer, COUNT(orders.customer_id) AS "count" FROM orders 
JOIN customers ON orders.customer_id=customers.customer_id GROUP BY customers.name LIMIT 3;

--ORDER BY (ASC|DESC)
SELECT date_of_receipt_of_the_order, delivery_address, customers.name AS customer, customers.phone_number AS customer_phone
FROM orders JOIN customers ON orders.customer_id=customers.customer_id ORDER BY date_of_receipt_of_the_order;

SELECT * FROM product_categories ORDER BY "name" ASC, price DESC;
--COUNT
SELECT packages.type AS package, SUM(price) AS "sum", COUNT(price) AS "count" FROM orders 
JOIN packages ON orders.package_id=packages.package_id GROUP BY packages.type;

SELECT baking_forms.name AS baking_form, COUNT(baking_forms.name) AS "count" FROM product_categories
JOIN baking_forms ON product_categories.baking_form_id=baking_forms.baking_form_id GROUP BY baking_forms.name;
--MAX
SELECT MAX(discount_size) FROM discounts;
--MIN
SELECT MIN(price) FROM packages;
--SUM
SELECT SUM(price) FROM internal_components;
--AVG
SELECT AVG(price) FROM product_categories;
SELECT AVG(price) FROM internal_components;

--UNION, EXCEPT, INTERSECT
SELECT confectionery_id, "name" FROM confectioners WHERE confectionery_id = 3
UNION SELECT confectionery_id, "name" FROM couriers WHERE confectionery_id = 3;

SELECT cream_id, taste FROM creams
UNION ALL SELECT filling_id, taste FROM fillings;

SELECT taste FROM creams
INTERSECT SELECT taste FROM fillings;

SELECT price FROM packages
EXCEPT SELECT price FROM internal_components;

--GROUP_CONCAT и другие разнообразные функции SQL
SELECT string_agg(taste, ',') AS taste FROM fillings;
SELECT string_agg("type", ',') AS "type" FROM packages WHERE price>=200;
SELECT string_agg("name", ',') AS "name" FROM product_categories WHERE "name" LIKE 'торт%';

--Вложенные SELECT с GROUP BY, ALL, ANY, EXISTS
SELECT * FROM packages WHERE package_id IN (SELECT package_id FROM packages WHERE price > 150);
SELECT * FROM internal_components WHERE price < ANY (SELECT price FROM packages WHERE price < 200);
SELECT * FROM internal_components WHERE price < ALL (SELECT price FROM product_categories WHERE price = 200);
SELECT * FROM couriers WHERE EXISTS(SELECT * FROM confectioneries WHERE couriers.confectionery_id=confectioneries.confectionery_id);

--WITH
WITH cte_internal_components("name", price) AS (SELECT "name", price FROM internal_components )
SELECT * FROM cte_internal_components;

WITH cte_packages("type", price) AS (SELECT "type", price FROM packages)
SELECT * FROM cte_packages;

WITH cte_product_categories("name", price) AS (SELECT "name", price FROM product_categories )
SELECT * FROM cte_product_categories;

--Запросы со строковыми функциями СУБД, с функциями работы с датами временем (форматированием дат), с арифметическими функциями
SELECT age(expiration_date, start_date) AS "period" FROM discounts;
SELECT extract("month" from date_of_receipt_of_the_order) AS "month_of_order" FROM orders;
SELECT extract(dow from date_of_receipt_of_the_order) AS "day_of_week" FROM orders;
SELECT SUM(price) FROM product_categories WHERE "name" LIKE 'торт%';
SELECT SUM(price) FROM internal_components WHERE "name" LIKE 'начинка%';
SELECT AVG(price) FROM packages;

--Сложные запросы, входящие в большинство групп выше, т.е. SELECT ... JOIN ... JOIN ... WHERE ... GROUP BY ... ORDER BY ... LIMIT ...;
SELECT date_of_receipt_of_the_order,
product_categories.name AS product_category, number_of_order_product_category AS count_product_categories, product_categories.price AS price_product_categories, SUM(number_of_order_product_category * product_categories.price) AS sum_product_categories,
internal_components.name AS internal_components, number_of_product_category_internal_components AS count_internal_components, internal_components.price AS price_internal_components, SUM(number_of_product_category_internal_components * internal_components.price) AS sum_internal_components,
discount_size, packages.type, packages.price AS price_packages, SUM((number_of_order_product_category * product_categories.price) + (number_of_product_category_internal_components * internal_components.price) + packages.price) AS summa,
SUM(((number_of_order_product_category * product_categories.price) + (number_of_product_category_internal_components * internal_components.price) + packages.price)*discount_size) AS discount,
SUM(((number_of_order_product_category * product_categories.price) + (number_of_product_category_internal_components * internal_components.price) + packages.price) - (((number_of_order_product_category * product_categories.price) + (number_of_product_category_internal_components * internal_components.price) + packages.price)*discount_size))
FROM orders_product_categories
JOIN orders ON orders.order_id=orders_product_categories.order_id
JOIN product_categories ON product_categories.product_category_id=orders_product_categories.product_category_id
JOIN product_categories_internal_components ON orders_product_categories.product_category_id=product_categories_internal_components.product_category_id
JOIN internal_components ON internal_components.internal_components_id=product_categories_internal_components.internal_components_id
JOIN discounts ON orders.discount_id=discounts.discount_id
JOIN packages ON orders.package_id=packages.package_id
GROUP BY date_of_receipt_of_the_order, product_categories.name, number_of_order_product_category, product_categories.price, internal_components.name, 
number_of_product_category_internal_components, internal_components.price, discount_size, packages.type, packages.price;

SELECT "date", address, 
copy_product_categories.name, SUM((number_of_order_product_category * copy_product_categories.price) - (number_of_order_product_category * copy_product_categories.price * discounts_pr.size) ) AS summa_pr,
internal_components.name, SUM(number_of_product_category_internal_components * internal_components.price) AS summa_in,
packages.type, packages.price, 
services.type, services.price, 
districts.name, deliveries.price, discounts.discount_size,
SUM ((((number_of_order_product_category * copy_product_categories.price) - (number_of_order_product_category * copy_product_categories.price * discounts_pr.size) ) +
	(number_of_product_category_internal_components * internal_components.price) +
	packages.price + services.price + deliveries.price) * (1 - discounts.discount_size))
FROM dop_orders_copy_product_categories
JOIN dop_orders ON dop_orders.dop_order_id=dop_orders_copy_product_categories.dop_order_id
JOIN copy_product_categories ON copy_product_categories.copy_product_category_id=dop_orders_copy_product_categories.copy_product_category_id
JOIN copy_product_categories_internal_components ON dop_orders_copy_product_categories.copy_product_category_id=copy_product_categories_internal_components.copy_product_category_id
JOIN internal_components ON internal_components.internal_components_id=copy_product_categories_internal_components.internal_components_id
JOIN discounts ON dop_orders.discount_id=discounts.discount_id
JOIN packages ON dop_orders.package_id=packages.package_id
JOIN services ON dop_orders.service_id=services.service_id
JOIN districts ON dop_orders.district_id=districts.district_id
JOIN deliveries ON deliveries.district_id=districts.district_id
JOIN discounts_pr ON discounts_pr.discount_pr_id=copy_product_categories.discount_pr_id
WHERE copy_product_categories.name LIKE 'торт%'
GROUP BY "date", address, 
copy_product_categories.name, number_of_order_product_category, copy_product_categories.price, discounts_pr.size, 
internal_components.name, number_of_product_category_internal_components, internal_components.price, 
packages.type, packages.price, 
services.type, services.price, 
districts.name, deliveries.price, discounts.discount_size; 

SELECT copy_product_categories.name AS product_categories, copy_product_categories.size, baking_forms.name AS baking_form, 
copy_product_categories.price, discounts_pr.size AS discount_pr, 
SUM (copy_product_categories.price * (1 - discounts_pr.size))
FROM copy_product_categories
JOIN baking_forms ON copy_product_categories.baking_form_id=baking_forms.baking_form_id
JOIN discounts_pr ON discounts_pr.discount_pr_id=copy_product_categories.discount_pr_id
GROUP BY copy_product_categories.name, copy_product_categories.size, baking_forms.name, copy_product_categories.price, discounts_pr.size
ORDER BY "sum" DESC LIMIT 3;

SELECT discounts.discount_size AS discount, COUNT(discounts.discount_size) AS "count" FROM orders 
JOIN discounts ON orders.discount_id=discounts.discount_id GROUP BY discounts.discount_size ORDER BY "count" DESC LIMIT 1;
--Модицикация--
--Все внутренние компоненты через union
SELECT internal_components.name AS "name", creams.taste AS "taste_type", creams.color AS "size_color", '-' AS "form", price FROM internal_components
INNER JOIN creams ON creams.cream_id=internal_components.internal_components_id
UNION 
SELECT internal_components.name AS "name", decors.type AS  "taste_type", decors.size AS "size_color", decors.form AS "form", price FROM internal_components 
INNER JOIN decors ON decors.decor_id=internal_components.internal_components_id
UNION
SELECT internal_components.name AS "name", fillings.taste AS  "taste_type",'-' AS "size_color", '-' AS "form", price FROM internal_components 
INNER JOIN fillings ON fillings.filling_id=internal_components.internal_components_id;

--Сумма заработка кондитера за определенный период
SELECT date_of_receipt_of_the_order,
product_categories.name AS product_category, number_of_order_product_category AS count_product_categories, product_categories.price AS price_product_categories, SUM(number_of_order_product_category * product_categories.price) AS sum_product_categories,
internal_components.name AS internal_components, number_of_product_category_internal_components AS count_internal_components, internal_components.price AS price_internal_components, SUM(number_of_product_category_internal_components * internal_components.price) AS sum_internal_components,
discount_size, packages.type, packages.price AS price_packages, SUM((number_of_order_product_category * product_categories.price) + (number_of_product_category_internal_components * internal_components.price) + packages.price) AS summa,
SUM(((number_of_order_product_category * product_categories.price) + (number_of_product_category_internal_components * internal_components.price) + packages.price)*discount_size) AS discount,
SUM(((number_of_order_product_category * product_categories.price) + (number_of_product_category_internal_components * internal_components.price) + packages.price) - (((number_of_order_product_category * product_categories.price) + (number_of_product_category_internal_components * internal_components.price) + packages.price)*discount_size))
FROM orders_product_categories
JOIN orders ON orders.order_id=orders_product_categories.order_id
JOIN product_categories ON product_categories.product_category_id=orders_product_categories.product_category_id
JOIN product_categories_internal_components ON orders_product_categories.product_category_id=product_categories_internal_components.product_category_id
JOIN internal_components ON internal_components.internal_components_id=product_categories_internal_components.internal_components_id
JOIN discounts ON orders.discount_id=discounts.discount_id
JOIN packages ON orders.package_id=packages.package_id
WHERE confectioner_id = 2
GROUP BY date_of_receipt_of_the_order, product_categories.name, number_of_order_product_category, product_categories.price, internal_components.name, 
number_of_product_category_internal_components, internal_components.price, discount_size, packages.type, packages.price;

--Топ 3 форм выпечки
SELECT baking_forms.name AS baking_form, COUNT(baking_forms.name) AS "count" FROM product_categories
JOIN baking_forms ON product_categories.baking_form_id=baking_forms.baking_form_id GROUP BY baking_forms.name ORDER BY "count" DESC LIMIT 3;

--Сумма заработка кондитера за определенный период
SELECT confectioner, SUM(summa) FROM
(SELECT confectioners.name AS confectioner,
SUM(((number_of_order_product_category * product_categories.price) + (number_of_product_category_internal_components * internal_components.price) + packages.price) *
	(1 - discount_size)) AS summa
FROM orders_product_categories
JOIN orders ON orders.order_id=orders_product_categories.order_id
JOIN product_categories ON product_categories.product_category_id=orders_product_categories.product_category_id
JOIN product_categories_internal_components ON orders_product_categories.product_category_id=product_categories_internal_components.product_category_id
JOIN internal_components ON internal_components.internal_components_id=product_categories_internal_components.internal_components_id
JOIN discounts ON orders.discount_id=discounts.discount_id
JOIN packages ON orders.package_id=packages.package_id
JOIN confectioners ON orders.confectioner_id=confectioners.confectioner_id
WHERE confectioners.name LIKE 'Федорова%'
GROUP BY confectioners.name) AS confectioner_orders
GROUP BY confectioner;


