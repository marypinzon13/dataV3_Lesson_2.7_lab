/*

-How many films are there for each of the categories in the category table. Use appropriate join to write this query.
-Display the total amount rung up by each staff member in August of 2005.
-Which actor has appeared in the most films?
-Most active customer (the customer that has rented the most number of films)
-Display the first and last names, as well as the address, of each staff member.
-List each film and the number of actors who are listed for that film.
-Using the tables payment and customer and the JOIN command, list the total paid by each customer. List the customers alphabetically by last name.
-List number of films per category.

*/

-- How many films are there for each of the categories in the category table. Use appropriate join to write this query
SELECT * FROM sakila.film;
SELECT * FROM sakila.film_category;
SELECT * FROM sakila.category;


SELECT DISTINCT (f.title), fc.category_id as category, COUNT(fc.category_id) as n_category
FROM sakila.film as f
INNER JOIN sakila.film_category as fc
ON f.film_id = fc.film_id
GROUP BY fc.category_id, f.title
ORDER BY category_id ASC;

-- Display the total amount rung up by each staff member in August of 2005.

SELECT * FROM sakila.staff;
SELECT * FROM sakila.payment;

SELECT s.staff_id, SUM(p.amount) as total_amount
FROM sakila.staff as s
INNER JOIN sakila.payment as p
ON s.staff_id = p.staff_id
WHERE p.payment_date like '2005-08%'
GROUP BY s.staff_id;

-- Which actor has appeared in the most films?
SELECT * FROM sakila.film;
SELECT * FROM sakila.film_actor;

SELECT fa.actor_id, COUNT(f.film_id) as film
FROM sakila.film_actor as fa
INNER JOIN sakila.film as f
ON fa.film_id = f.film_id
GROUP BY actor_id
ORDER BY film DESC;

-- Most active customer (the customer that has rented the most number of films)

SELECT * FROM sakila.customer;
SELECT * FROM sakila.rental;


SELECT DISTINCT(r.customer_id) as customer, COUNT(r.rental_date) as time, c.customer_id as costumer
FROM sakila.customer as c
INNER JOIN sakila.rental as r
ON c.customer_id = r.customer_id
WHERE c.active = 1
GROUP BY c.customer_id
ORDER BY COUNT(r.rental_date) DESC;

SELECT DISTINCT(r.customer_id) as customer, COUNT(r.rental_date) as time, c.customer_id as costumer,
CASE WHEN c.active= 1 THEN 'ACTIVE'
ELSE 'INACTIVE'
END AS 'status'
FROM sakila.customer as c
INNER JOIN sakila.rental as r
ON c.customer_id = r.customer_id
GROUP BY c.customer_id
ORDER BY COUNT(r.rental_date) DESC;

-- Display the first and last names, as well as the address, of each staff member.
SELECT * FROM sakila.staff;
SELECT * FROM sakila.address;

SELECT s.first_name, s.last_name, a.address
FROM sakila.staff as s
INNER JOIN sakila.address as a
ON s.address_id = a.address_id
WHERE a.address_id IN(3, 4);

-- List each film and the number of actors who are listed for that film.                                                                                                                  
SELECT * FROM sakila.film;
SELECT * FROM sakila.film_actor;

SELECT fa.film_id, COUNT(fa.actor_id) as number_actor, f.title
FROM sakila.film_actor as fa
INNER JOIN sakila.film as f
ON fa.film_id = f.film_id
GROUP BY fa.film_id;

/*
-Using the tables payment and customer and the JOIN command, list the total paid by each customer. 
List the customers alphabetically by last name.
*/
SELECT * FROM sakila.payment;
SELECT * FROM sakila.customer;


SELECT DISTINCT(c.last_name), p.customer_id, SUM(p.amount) over(partition by customer_id) as total_paid
FROM sakila.customer as c
INNER JOIN sakila.payment as p
ON c.customer_id = p.customer_id
ORDER BY c.last_name ASC;