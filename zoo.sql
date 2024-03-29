drop schema public cascade;
create schema public;

create table "types"
(
	id_type serial not null primary key,
	"name" varchar(100) not null
);

create table zoos
(
	id_zoo serial not null primary key,
	address varchar(200) not null,
	"name" varchar(100) not null
);

create table cages
(
	id_cage serial not null primary key,
	area int not null,
	id_zoo int not null,
	
	foreign key(id_zoo)
		references zoos (id_zoo)
);

create table animals
(
	id_animal serial not null primary key,
	"name" varchar(100) not null,
	age int not null,
	id_cage int not null,
	id_type int not null
);

create table employee
(
	id_employee serial not null primary key,
	"name" varchar(100) not null,
	"position" varchar(100) not null,
	salary int not null,
	id_zoo int not null,
	
	foreign key(id_zoo)
		references zoos (id_zoo)
);

create table feed
(
	id_food serial not null primary key,
	"type" varchar(100) not null,
	shelf_life int not null
);

create table sponsor
(
	id_sponsor serial not null primary key,
	"name" varchar(100) not null
);

create table visitors
(
	Id_visitor serial not null primary key,
	"name" varchar(100) not null,
	age int not null
);

create table tickets
(
	id_ticket serial not null primary key,
	date_of_visit date not null,
	"type" varchar(100) not null,
	id_zoo int not null,
	id_visitor int not null,
	
	foreign key(id_zoo)
		references zoos (id_zoo),
	foreign key(id_visitor)
		references visitors (id_visitor)
);

create table penalties
(
	id_penaltie serial not null primary key,
	amount int not null,
	description varchar(200) not null,
	"name" varchar(100) not null
);

create table purchases
(
	id_purchase serial not null primary key,
	"date" date not null,
	description varchar(100) not null,
	id_zoo int not null,
	
	foreign key(id_zoo)
		references zoos (id_zoo)
);

create table employees_to_animals
(
	id_animal int not null,
	id_employee int not null,
	
	foreign key(id_animal)
		references animals (id_animal),
	foreign key(id_employee)
		references employee (id_employee),
	
	primary key(id_animal, id_employee)
);

create table animals_to_feed
(
	id_animal int not null,
	id_food int not null,
	norm_in_day int not null,
	
	foreign key(id_animal)
		references animals (id_animal),
	foreign key(id_food)
		references feed (id_food),
	
	primary key(id_animal, id_food)
);

create table purchases_to_feed
(
	id_purchase int not null,
	id_food int not null,
	weight int not null,
	
	foreign key(id_purchase)
		references purchases (id_purchase),
	foreign key(id_food)
		references feed (id_food)
);

create table zoos_to_sponsors
(
	id_zoo int not null,
	id_sponsor int not null,
	"date" date not null,
	
	foreign key(id_zoo)
		references zoos (id_zoo),
	foreign key(id_sponsor)
		references sponsor (id_sponsor),
	
	primary key(id_zoo, id_sponsor)
);

create table tickets_to_penalties
(
	id_ticket int not null,
	id_penaltie int not null,
	
	foreign key(id_ticket)
		references tickets (id_ticket),
	foreign key(id_penaltie)
		references penalties (id_penaltie),
	
	primary key(id_ticket, id_penaltie)
);
--добавление столбца
alter table zoos add column price int not null;
--удаление столбца
alter table tickets drop column "type";
--добавление внешнего ключа
alter table animals add foreign key(id_cage) references cages (id_cage);
alter table animals add foreign key(id_type) references "types" (id_type);
--удаление первичного ключа, добавление первичного ключа
alter table purchases_to_feed add primary key(id_purchase, id_food);
--добавление ограниченичения 
alter table zoos add constraint price_check1 check (price <= 50000);
alter table animals_to_feed add constraint norm_in_day_check2 check (norm_in_day <= 500);
--переименовка таблиц
alter table employee rename to employees;
alter table sponsor rename to sponsors;
alter table animals_to_feed rename column norm_in_day to norm;

insert into "types" ("name")
values
('Слон');

insert into zoos (address, "name", price)
values
('ул.Ленина, 54 (Саратов)', 'Зоомир', 500);

insert into cages (area, id_zoo)
values
(200, 1);

insert into animals ("name", age, id_cage, id_type)
values
('Кевин', 2, 1, 1);

insert into employees ("name", "position", salary, id_zoo)
values
('Майк','Ветеринар', 34000, 1);

insert into feed ("type", shelf_life)
values
('Сено', 4);

insert into sponsors ("name")
values
('Забожный Михаил Иванович');

insert into visitors ("name", age)
values
('Кирилл', 12);

insert into tickets (date_of_visit, id_zoo, id_visitor)
values
('14.12.1999', 1, 1);

insert into penalties (amount, description, "name")
values
(2000, 'Запрещено фотографировать любых видов животных со вспышкой и без нее', 'Фотосессии с животными');

insert into purchases ("date", description, id_zoo)
values
('02.02.2011', 'Заказ ко дню города', 1);

insert into employees_to_animals (id_animal, id_employee)
values
(1, 1);

insert into animals_to_feed (id_animal, id_food, norm)
values
(1, 1, 10);

insert into purchases_to_feed (id_food, id_purchase, weight)
values
(1, 1, 67);

insert into zoos_to_sponsors (id_zoo, id_sponsor, "date")
values
(1, 1, '24.03.1994');

insert into tickets_to_penalties (id_penaltie, id_ticket)
values
(1, 1);

--Модификация--
--покупка на посещение нескольких клеток (а не зоопарка)
--животное привязано к одному сотруднику (а не ко многим)
--1 штраф сторого привязан к одному билету (поменять primary key)

alter table purchases drop column id_zoo;
create table purchases_to_cages
(
	id_purchase int not null,
	id_cage int not null,
	
	foreign key(id_purchase)
		references purchases (id_purchase),
	foreign key(id_cage)
		references cages (id_cage),
	
	primary key(id_purchase, id_cage)
);

drop table employees_to_animals;
alter table animals 
add column id_employee int,
add foreign key (id_employee) references employees(id_employee);


drop table tickets_to_penalties;
alter table penalties add foreign key (id_penaltie) references tickets(id_ticket);

