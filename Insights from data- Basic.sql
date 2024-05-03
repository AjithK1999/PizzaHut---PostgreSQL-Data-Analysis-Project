-- Retrieve the total number of orders placed.

  select count(*) as total_orders from orders;

	
-- Calculate the total revenue generated from pizza sales.

	select
		sum(od.quantity * p.price) as total_revenue
	from pizzas p join order_details od
	on p.pizza_id = od.pizza_id;


-- Identify the highest-priced pizza. 

	select pt.name as highest_priced_pizza
	from pizza_types pt
	join pizzas p on pt.pizza_type_id = p.pizza_type_id
	order by p.price desc
	limit 1
    
	
-- Identify the most common pizza size ordered.

	select 
		pizza_size as most_common_pizza_size 
	from (
		  select 
		 	p.size as pizza_size,
		 	count(p.size) as total_count
		  from order_details od
		  join pizzas p on od.pizza_id = p.pizza_id
		  group by p.size
		  order by total_count desc
		 )
	limit 1;


-- List the top 5 most ordered pizza types along with their quantities.

	select 
      pt.name as pizza_type,
      sum(quantity) as total_quantity
	from order_details od
	join pizzas p on od.pizza_id = p.pizza_id
	join pizza_types pt on p.pizza_type_id = pt.pizza_type_id
	group by pt.name
	order by total_quantity desc
	limit 5;


select * from order_details;
select * from orders;
select * from pizzas;
select * from pizza_types;
