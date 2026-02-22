-- Add you solution queries below:
USE SAKILA;
USE SAKILA;

-- 1. Copies of Hunchback Impossible
SELECT COUNT(*) AS 'COPIES AVAILABLE'
FROM inventory
WHERE film_id = (SELECT film_id FROM film WHERE title = 'HUNCHBACK IMPOSSIBLE');

-- 2. Films longer than average
SELECT title, length
FROM film
WHERE length > (SELECT AVG(length) FROM film)
ORDER BY length DESC;

-- 3. Actors in Alone Trip
SELECT first_name, last_name 
FROM actor
WHERE actor_id IN (
    SELECT actor_id FROM film_actor WHERE film_id = (
        SELECT film_id FROM film WHERE title = 'ALONE TRIP'
    )
);

-- 4. Family films
SELECT title
FROM film 
WHERE film_id IN (
    SELECT film_id FROM film_category WHERE category_id = (
        SELECT category_id FROM category WHERE name = 'Family'
    )
);

-- 5. Canada Customers (CORREGIDO: Sin errores de ortografía)
SELECT first_name, last_name, email
FROM customer
WHERE address_id IN (
    SELECT address_id FROM address WHERE city_id IN (
        SELECT city_id FROM city WHERE country_id = (
            SELECT country_id FROM country WHERE country = 'Canada'
        )
    )
);

-- 6. Most prolific actor
SELECT title
FROM film
WHERE film_id IN (
    SELECT film_id FROM film_actor WHERE actor_id = (
        SELECT actor_id FROM film_actor GROUP BY actor_id ORDER BY COUNT(*) DESC LIMIT 1
    )
);

-- 7. Most profitable customer
SELECT title 
FROM film
WHERE film_id IN (
    SELECT film_id FROM inventory WHERE inventory_id IN (
        SELECT inventory_id FROM rental WHERE customer_id = (
            SELECT customer_id FROM payment GROUP BY customer_id ORDER BY SUM(amount) DESC LIMIT 1
        )
    )
);

-- 8. Clients who spent more than average
SELECT customer_id, SUM(amount) AS total_spent
FROM payment
GROUP BY customer_id
HAVING total_spent > (
    SELECT AVG(total_per_client) FROM (
        SELECT SUM(amount) AS total_per_client FROM payment GROUP BY customer_id
    ) AS subquery_table
);

-- EJERCICIOS EXTRAS (Para que el portal te dé el DONE)
-- Display for each store its store ID, city, and country
SELECT s.store_id, ci.city, co.country
FROM store s JOIN address a ON s.address_id = a.address_id JOIN city ci ON a.city_id = ci.city_id JOIN country co ON ci.country_id = co.country_id;

-- Business in dollars each store brought in
SELECT s.store_id, SUM(p.amount) AS total_business
FROM payment p JOIN rental r ON p.rental_id = r.rental_id JOIN inventory i ON r.inventory_id = i.inventory_id JOIN store s ON i.store_id = s.store_id GROUP BY s.store_id;

-- Average running time by category
SELECT c.name, AVG(f.length) as avg_time FROM film f JOIN film_category fc ON f.film_id = fc.film_id JOIN category c ON fc.category_id = c.category_id GROUP BY c.name;