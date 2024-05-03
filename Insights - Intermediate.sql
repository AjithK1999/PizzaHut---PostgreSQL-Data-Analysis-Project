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
      select o.order_date as day, sum(od.quantity) as sum_orders_per_day
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
