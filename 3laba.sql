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
	discount_size float not null
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
	confectioner_id int,
    courier_id int not null,
    customer_id int not null,
    discount_id int not null,
    package_id int,
    
	foreign key (confectioner_id)
		references confectioners (confectioner_id)
		on delete set null,
	foreign key (courier_id)
		references couriers (courier_id),
	foreign key (customer_id)
		references customers (customer_id),
	foreign key (package_id) 
		references packages (package_id)
		on delete set null,
	foreign key (discount_id) 
		references discounts (discount_id)
);


create table product_categories
(
	product_category_id serial not null primary key,
    "name" varchar(100) not null,
    size varchar(100) not null,
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
('начинка "Ореховая"', 100),
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
(9, 'ореховый');

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
('01.01.2022', '01.02.2022', 0.50),
('11.07.2020', '31.12.2020', 0.30),
('21.03.2021', '10.04.2021', 0.15),
('30.06.2017', '24.07.2017', 0.05),
('08.12.2021', '10.12.2021', 0.45),
('10.10.2019', '15.10.2019', 0.10),
('15.02.2018', '15.03.2018', 0);

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
('24.03.22 10:30','ул. Краснополянская, 51-12', 1, 1, 1, 7, 5),
('15.12.22 14:40','ул. Ленина, 4-78', 2, 2, 2, 9, 5),
('04.02.22 15:30','ул. Гвардейская, 34-11', 3, 3, 3, 4, 1),
('27.03.22 10:00','ул. Дмитровская, 1-42', 4, 4, 4, 2, 2),
('13.06.22 17:30','ул. Мира, 14-48', 5, 5, 5, 3, 4),
('14.11.22 11:00','ул. Репина, 18-9', 5, 5, 6, 2, 5),
('25.05.22 18:30','ул. Зорге, 3-98', 4, 4, 7, 10, 1),
('20.10.22 20:00','ул. Демидова, 11', 3, 3, 8, 1, 5),
('28.12.22 21:00','ул. Сочинская, 33', 2, 2, 9, 6, 1),
('05.11.22 11:00','ул. Донская, 48', 1, 1, 10, 7, 5),
('20.03.22 12:40','ул. Жукова, 53-1', 1, 2, 3, 4, 5),
('10.12.22 12:00','ул. Мира, 4', 2, 1, 2, 4, 3),
('14.02.22 09:30','ул. 39 Гвардейская, 27-11', 5, 4, 3, 2, 1),
('03.03.22 18:00','ул. Иванова, 13-442', 1, 3, 5, 3, 1),
('23.06.22 08:30','ул. Зорге, 52-48', 2, 2, 4, 4, 6),
('06.11.22 11:00','ул. Сочинская, 10', 10, 9, 8, 7, 6),
('21.05.22 11:30','ул. Репина, 13-98', 6, 8, 10, 8, 6),
('02.10.22 07:00','ул. Донская, 15', 7, 9, 5, 6, 10),
('18.12.22 11:00','ул. Иванова, 17', 1, 10, 2, 9, 3),
('15.11.22 16:00','ул. Демидова, 93-18', 6, 4, 7, 3, 8);

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
(3, 7, 1),
(4, 8, 1),
(5, 2, 1),
(6, 8, 12),
(7, 2, 2),
(8, 9, 1),
(9, 6, 9),
(10, 3, 3);

insert into orders_product_categories (order_id, product_category_id, number_of_order_product_category)
values
(1, 1, 2),
(2, 2, 1),
(3, 3, 1),
(4, 4, 1),
(5, 5, 3),
(6, 6, 12),
(7, 7, 2),
(8, 8, 1),
(9, 9, 9),
(10, 10, 3),
(11, 9, 1),
(12, 7, 1),
(13, 5, 1),
(14, 3, 2),
(15, 1, 1),
(16, 10, 2),
(17, 8, 3),
(18, 6, 16),
(19, 4, 5),
(20, 2, 2);

select * from confectioneries;
select * from confectioners;
select * from couriers;
select * from customers;
select * from internal_components;
select * from creams;
select * from fillings;
select * from decors;
select * from baking_forms;
select * from discounts;
select * from packages;
select * from "orders";
select * from product_categories;
select * from orders_product_categories;
