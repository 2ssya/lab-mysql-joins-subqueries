-- Add you solution queries below:
USE SAKILA;

-- 1. How many copies of the film Hunchback Impossible exist in the inventory system?

SELECT COUNT(*) AS 'COPIES DISPONIBLE'
FROM inventory
WHERE film_id =(SELECT film_id FROM film WHERE title = 'HUNCHBACK IMPOSSIBLE');

-- 2.List all films whose length is longer than the average of all the films.
SELECT title, length
from film
WHERE length > (
    SELECT AVG(length) 
	FROM film)
ORDER BY length DESC;


-- 3. Use subqueries to display all actors who appear in the film Alone Trip.
SELECT first_name, last_name 
from actor
WHERE actor_id IN (
    SELECT actor_id FROM film_actor WHERE film_id = (
         SELECT film_id FROM film WHERE title = 'Alone Trip'));
         
-- 4. Sales have been lagging among young families, and you wish to target all family movies for a 
-- promotion. Identify all movies categorized as family films.
SELECT title
FROM film 
WHERE film_id IN( 
    SELECT  film_id FROM film_category WHERE category_id =(SELECT category_id FROM category WHERE name = 'Family'));

-- 5. Get name and email from customers from Canada using subqueries. Do the same with joins. Note that to create a join, you will have
-- to identify the correct tables with their primary keys and foreign keys, that will help you get the relevant information.
SELECT firt_name, last_name, email
FROM custumer
WHERE adress_id IN (
SELECT adreess_id
FROM FROM address
    WHERE city_id IN (
        SELECT city_id
        FROM city
        WHERE country_id = (
            SELECT country_id
            FROM country
            WHERE country = 'Canada'
        )
    )
);

-- 6. Which are films starred by the most prolific actor? Most prolific actor is defined as the actor that has acted in the most number of films. First you will have to find the most 
SELECT title
FROM film
WHERE film_id IN (
	SELECT film_id FROM film_actor WHERE actor_id = (
	     SELECT actor_id FROM film_actor
		 GROUP BY actor_id
	     ORDER BY COUNT(*) DESC
	     LIMIT 1
    )
);

-- prolific actor and then use that actor_id to find the different films that he/she starred.
-- 7. Films rented by most profitable customer. You can use the customer table and payment table to find the most 
-- profitable customer ie the customer that has made the largest sum of payments.
SELECT title 
FROM film
WHERE film_id IN (
    SELECT film_id FROM inventory WHERE inventory_id  IN (
         SELECT inventory_id FROM rental WHERE customer_id = (
           SELECT customer_id FROM payment
           GROUP BY customer_id
           ORDER BY SUM(amount) DESC
           LIMIT 1
           )
           )
		);

-- 8. Get the client_id and the total_amount_spent of those clients who spent more than
SELECT customer_id, SUM(amount) AS total_spent
FROM payment
GROUP BY customer_id
HAVING total_spent > (
    -- Calculamos el promedio de una tabla temporal de totales
    SELECT AVG(total_per_client) FROM (
        SELECT SUM(amount) AS total_per_client 
        FROM payment 
        GROUP BY customer_id
    ) AS subquery_table
);