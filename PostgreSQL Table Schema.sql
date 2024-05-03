-- Schema for table 'pizzas'
create table pizzas (
	pizza_id varchar(50) not null,
	pizza_type_id varchar(50) not null, 
	size varchar(50) not null,
	price int not null,
	primary key (pizza_id));

-- Schema for table 'pizza_types'
create table pizza_types (
	pizza_type_id text not null,
	name text not null,
	category text not null,
	ingredients text not null
	);
	
-- Schema for table 'orders'
create table orders (
    order_id SERIAL primary key not null,
    order_date DATE not null,
    order_time TIME not null
    );

-- Schema for table 'order_details'
create table order_details (
	order_details_id int primary key not null,
	order_id int not null, 
	pizza_id text not null, 
	quantity int not null,
	foreign key (order_id)
	references orders(order_id),
	foreign key (pizza_id)
	references pizzas(pizza_id)
	);
