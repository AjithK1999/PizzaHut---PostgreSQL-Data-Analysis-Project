-- Retrieve the total number of orders placed.

  	select count(*) as total_orders from orders;

	
-- Calculate the total revenue generated from pizza sales.

	select
		sum(od.quantity * p.price) as total_revenue
	from pizzas p join order_details od
	on p.pizza_id = od.pizza_id;


-- Identify the highest-priced pizza. 

	select 
		pt.name as highest_priced_pizza
	from pizza_types pt
	join pizzas p on pt.pizza_type_id = p.pizza_type_id
	order by p.price desc
	limit 1;
    
	
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


-- Join the necessary tables to find the total quantity of each pizza category ordered.

	select 
    		pt.category as category,
    		sum(quantity) as total_order_quantity
	from order_details od
	join pizzas p on od.pizza_id = p.pizza_id
	join pizza_types pt on p.pizza_type_id = pt.pizza_type_id
	group by pt.category
	order by total_order_quantity desc;
	
-- Determine the distribution of orders by hour of the day.

	select 
    		extract(hour from order_time) as hour, 
    		count(order_id) orders_count from orders
	group by extract(hour from order_time)
	order by hour;


-- Join relevant tables to find the category-wise distribution of pizzas ordered.

	select 
   		pt.category as category, 
    		sum(od.quantity) as total_quantity_ordered
	from order_details od
	join pizzas p on od.pizza_id = p.pizza_id
	join pizza_types pt on p.pizza_type_id = pt.pizza_type_id
	group by pt.category
	
	
-- Group the orders by date and calculate the average number of pizzas ordered per day.

  	select 
    		round(avg(sum_orders_per_day)) as average_orders_per_day
  	from(
      	     select
		o.order_date as day, 
		sum(od.quantity) as sum_orders_per_day
	     from orders o
	     join order_details od on o.order_id = od.order_id
	     group by o.order_date
      	    )

    
-- Determine the top 3 most ordered pizza types based on revenue.

  	select 
    		pt.name as pizza_type, 
    		sum(od.quantity * p.price) as total_revenue
	from order_details od
	join pizzas p on od.pizza_id = p.pizza_id
	join pizza_types pt on p.pizza_type_id = pt.pizza_type_id
	group by pt.name
	order by total_revenue desc
	limit 3;


-- Calculate the percentage contribution of each pizza type/ category to total revenue.

	select 
		pt.category as pizza_type,
		round(sum(od.quantity * p.price)/(
						  select 
						       sum(od.quantity * p.price) 
						  from order_details od
						  join pizzas p on od.pizza_id = p.pizza_id
						 )*100,2) as percentage_of_revenue
	from order_details od
	join pizzas p on od.pizza_id = p.pizza_id
	join pizza_types pt on p.pizza_type_id = pt.pizza_type_id
	group by pt.category
	 
-- Analyze the cumulative revenue generated over time.

	select
		order_date,
		sum(revenue) over(order by order_date) as cumulative_revenue
	from (
		select 
			o.order_date as order_date,
			sum(p.price * od.quantity) as revenue
		from pizzas p
		join order_details od on p.pizza_id = od.pizza_id
		join orders o on od.order_id = o.order_id
		group by o.order_date
	      )
	order by order_date;


-- Determine the top 3 most ordered pizza types based on revenue for each pizza category.

		
	select
		category,
		name,
		revenue,
		position
	from (
		select 
			pt.category as category, 
			pt.name as name, 
			sum(od.quantity * p.price) as revenue,
			rank() over (partition by pt.category order by sum(od.quantity * p.price) desc) as position
		from order_details od
		join pizzas p on od.pizza_id = p.pizza_id
		join pizza_types pt on p.pizza_type_id = pt.pizza_type_id
		group by pt.category, pt.name
		order by category, revenue desc 
		)
	where position in (1,2,3);