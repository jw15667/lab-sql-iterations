use sakila;
-- Write a query to find what is the total business done by each store.
select c.store_id, sum(amount) as total_business from customer c
join payment
using (customer_id)
group by c.store_id;

-- Convert the previous query into a stored procedure.

drop procedure if exists total_business_by_store;

delimiter //
create procedure total_business_by_store (out param1 float)
begin
  select c.store_id, sum(amount) as total_business from customer c
	join payment
	using (customer_id)
	group by c.store_id;
end;
//
delimiter ;

call total_business_by_store(@x);
-- Convert the previous query into a stored procedure that takes the input for store_id and displays the total sales for that store.


drop procedure if exists total_business_choose_store;

delimiter //
create procedure total_business_choose_store (in param1 int)
begin
  select c.store_id, sum(amount) as total_business from customer c
	join payment
	using (customer_id)
    where c.store_id = param1;
end;
//
delimiter ;

call total_business_choose_store(2);

-- Update the previous query. Declare a variable total_sales_value of float type, that will store the returned result 
-- (of the total sales amount for the store). Call the stored procedure and print the results.

drop procedure if exists total_business_choose_store_declared;

delimiter //
create procedure total_business_choose_store_declared (in param1 int)
begin
  declare total_sales_value float default 0.0;
  select sum(amount) as total_business into total_sales_value
  from customer c
	join payment
	using (customer_id)
    where c.store_id = param1
    group by param1;
    
    select total_sales_value;
end;
//
delimiter ;

call total_business_choose_store_declared(1); 
-- In the previous query, add another variable flag. If the total sales value for the store is over 30,000, 
-- then label it as green_flag, otherwise label is as red_flag. 
-- Update the stored procedure that takes an input as the store_id and returns total sales value for that store and flag value.

drop procedure if exists total_business_choose_store_declared;

delimiter //

create procedure total_business_choose_store_declared (in param1 int, out param2 float, out param3 varchar(20))
begin
  declare total_sales_value float default 0.0;
  declare flag varchar(20) default "";
  select sum(amount) as total_business into total_sales_value
  from customer c
	join payment
	using (customer_id)
	where c.store_id = param1
	group by param1;
    
    select total_sales_value;
    case
    when total_sales_value > 30000 then
		set flag = 'green';
	else
		set flag = 'red';
	end case;
    
    select total_sales_value into param2;
    select flag into param3;
end;
//
delimiter ;

call total_business_choose_store_declared(1, @x, @y);
