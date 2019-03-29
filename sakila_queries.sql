-- 1a.Display the first and last names of all actors from the table `actor`.

USE sakila;
SELECT first_name, last_name 
FROM actor;

-- 1.b.Display the first and last name of each actor in a single column in upper case letters. 
-- Name the column `Actor Name`.

SELECT  UPPER(CONCAT(first_name,  ' ', last_name) ) AS ' Actor Name'
FROM actor;

-- 2a.You need to find the ID number, first name, and last name of an actor, of whom you 
-- know only the first name, "Joe." What is one query would you use to obtain this information?

SELECT actor_id, first_name, last_name 
FROM actor
WHERE first_name = 'JOE';

-- 2b.Find all actors whose last name contain the letters `GEN`.

SELECT actor_id, first_name, last_name 
FROM actor
WHERE last_name LIKE '%GEN%';

-- 2c.Find all actors whose last names contain the letters `LI`. This time, order the rows 
-- by last name and first name, in that order.

SELECT actor_id, first_name, last_name 
FROM actor
WHERE last_name LIKE '%LI%'
ORDER BY last_name, first_name;

-- 2d.Using `IN`, display the `country_id` and `country` columns of the following 
-- countries: Afghanistan, Bangladesh, and China.

SELECT country_id,  country
FROM country
WHERE country IN ('Afghanistan', 'Bangladesh', 'China');

-- 3a.You want to keep a description of each actor. You don't think you will be 
-- performing queries on a description, so create a column in the table `actor` 
-- named `description` and use the data type `BLOB` (Make sure to research the type 
-- `BLOB`, as the difference between it and `VARCHAR` are significant).

SELECT * FROM actor;

ALTER TABLE actor
ADD COLUMN  description  BLOB;
-- verified
SELECT description, first_name
FROM actor;

-- 3b.Very quickly you realize that entering descriptions for each actor is too 
-- much effort. Delete the `description` column.

ALTER TABLE actor
DROP COLUMN description;

-- 4a.List the last names of actors, as well as how many actors have that last name.

SELECT last_name, COUNT(*) AS `Count`
FROM actor
GROUP BY last_name;

-- 4b.List last names of actors and the number of actors who have that last name, 
-- but only for names that are shared by at least two actors.

SELECT last_name, COUNT(*) AS `Count`
FROM actor
GROUP BY last_name
HAVING Count = 2;

-- 4c.The actor `HARPO WILLIAMS` was accidentally entered in the `actor` table 
-- as `GROUCHO WILLIAMS`. Write a query to fix the record.

UPDATE actor 
SET first_name= 'HARPO'
WHERE first_name='GROUCHO' AND last_name='WILLIAMS';
-- verified
SELECT first_name, last_name
FROM actor
WHERE first_name='HARPO' and last_name='WILLIAMS';

-- 4d. Perhaps we were too hasty in changing `GROUCHO` to `HARPO`. It turns out 
-- that `GROUCHO` was the correct name after all! In a single query, if the first 
-- name of the actor is currently `HARPO`, change it to `GROUCHO`.
UPDATE actor 
SET first_name= 'GROUCHO'
WHERE first_name='HARPO' AND last_name='WILLIAMS';

-- 5a.You cannot locate the schema of the `address` table. Which query would you 
-- use to re-create it?

DESCRIBE sakila.address;

-- 6a.Use `JOIN` to display the first and last names, as well as the address, of
-- each staff member. Use the tables `staff` and `address`.

SELECT staff.first_name, staff.last_name, address.address
FROM staff  
LEFT JOIN address  
ON staff.address_id = address.address_id;

-- 6b.Use `JOIN` to display the total amount rung up by each staff member in 
-- August of 2005. Use tables `staff` and `payment`.

SELECT s.first_name, s.last_name, SUM(p.amount) AS 'TOTAL'
FROM staff s 
LEFT JOIN payment p  ON s.staff_id = p.staff_id
WHERE payment_date between '2005-08-01 00:00.00'  and  '2005-08-31 00:00.00' 
GROUP BY s.first_name, s.last_name;

-- 6c.List each film and the number of actors who are listed for that film. Use 
-- tables `film_actor` and `film`. Use inner join.

SELECT f.title, COUNT(a.actor_id) AS 'TOTAL'
FROM film f INNER JOIN film_actor  a ON f.film_id = a.film_id
GROUP BY f.title;

-- 6d.How many copies of the film `Hunchback Impossible` exist in the inventory system?

SELECT title, COUNT(inventory_id) AS number_of_copies 
FROM film 
INNER JOIN inventory ON film.film_id = inventory.film_id 
WHERE title = 'Hunchback Impossible';

-- 6e.Using the tables `payment` and `customer` and the `JOIN` command, list the total 
-- paid by each customer.List the customers alphabetically by last name.

SELECT first_name,  last_name, SUM(amount) AS total_paid 
FROM payment INNER JOIN customer ON payment.customer_id = customer.customer_id 
GROUP BY payment.customer_id 
ORDER BY last_name ASC;

-- 7a.The music of Queen and Kris Kristofferson have seen an unlikely resurgence. As an 
-- unintended consequence, filmsstarting with the letters `K` and `Q` have also soared in 
-- popularity. Use subqueries to display the titles of 
-- movies starting with the letters `K` and `Q` whose language is English.

SELECT title
FROM film
WHERE (title LIKE 'K%' OR title LIKE 'Q%') 
AND language_id= (SELECT language_id FROM language WHERE name='English');

-- 7b.Use subqueries to display all actors who appear in the film `Alone Trip`.

SELECT first_name, last_name
FROM actor
WHERE actor_id
	IN (SELECT actor_id FROM film_actor WHERE film_id 
		IN (SELECT film_id from film where title='ALONE TRIP'));
        
--  7c.You want to run an email marketing campaign in Canada, for which you will 
-- need the names and email addresses of all Canadian customers. Use joins to retrieve 
-- this information.

SELECT first_name, last_name, ctry.country, UPPER(email )
FROM customer c
JOIN address a ON (c.address_id = a.address_id)
JOIN city ct ON (a.city_id=ct.city_id)
JOIN country ctry ON (ct.country_id=ctry.country_id)
WHERE ctry.country= 'Canada';

-- 7d.Sales have been lagging among young families, and you wish to target all family 
-- movies for a promotion. Identify all movies categorized as _family_ films.

SELECT f.title, c.name
FROM film f
JOIN film_category fcat on (f.film_id=fcat.film_id)
JOIN category c on (fcat.category_id=c.category_id)
WHERE c.name LIKE 'Family';

-- 7e.Display the most frequently rented movies in descending order.

SELECT title, COUNT(f.film_id) AS 'Count_of_Rented_Movies'
FROM  film f
JOIN inventory i ON (f.film_id= i.film_id)
JOIN rental r ON (i.inventory_id=r.inventory_id)
GROUP BY title 
ORDER BY Count_of_Rented_Movies DESC;

-- 7f.Write a query to display how much business, in dollars, each store brought in.

SELECT s.store_id, SUM(p.amount) as 'Total Sales'
FROM payment p
JOIN staff s ON (p.staff_id=s.staff_id)
GROUP BY store_id;

-- 7g.Write a query to display for each store its store ID, city, and country.

SELECT store.store_id, city.city, country.country 
FROM store INNER JOIN address ON store.address_id = address.address_id 
INNER JOIN city ON address.city_id = city.city_id 
INNER JOIN country ON city.country_id = country.country_id;

-- 7h.List the top five genres in gross revenue in descending order. (**Hint**: you may 
-- need to use the following tables: category, film_category, inventory, payment, and rental.)

SELECT name as 'Genres', SUM(p.amount) AS 'Gross_Revenue' 
FROM category c 
INNER JOIN film_category fc ON fc.category_id = c.category_id 
INNER JOIN inventory i ON i.film_id = fc.film_id 
INNER JOIN rental r ON r.inventory_id = i.inventory_id 
RIGHT JOIN payment p ON p.rental_id = r.rental_id 
GROUP BY name 
ORDER BY Gross_Revenue 
DESC LIMIT 5;

-- 8a.In your new role as an executive, you would like to have an easy way of viewing the 
-- Top five genres by gross revenue. Use the solution from the problem above to create a view. 
-- If you haven't solved 7h, you can substitute another query to create a view.

CREATE VIEW Top_5_Genres AS 
SELECT name as 'Genres', SUM(p.amount) AS 'Gross_Revenue' 
FROM category c 
INNER JOIN film_category fc ON fc.category_id = c.category_id 
INNER JOIN inventory i ON i.film_id = fc.film_id 
INNER JOIN rental r ON r.inventory_id = i.inventory_id 
RIGHT JOIN payment p ON p.rental_id = r.rental_id 
GROUP BY name 
ORDER BY gross_revenue 
DESC LIMIT 5;


-- 8b.How would you display the view that you created in 8a?

SELECT * FROM Top_5_Genres;

-- 8c.You find that you no longer need the view `top_five_genres`. Write a query to delete it.

DROP VIEW Top_5_Genres;

## Appendix: List of Tables in the Sakila DB

-- * A schema is also available as `sakila_schema.svg`. See file in repository

-- ```sql
-- 'actor'
-- 'actor_info'
-- 'address'
-- 'category'
-- 'city'
-- 'country'
-- 'customer'
-- 'customer_list'
-- 'film'
-- 'film_actor'
-- 'film_category'
-- 'film_list'
-- 'film_text'
-- 'inventory'
-- 'language'
-- 'nicer_but_slower_film_list'
-- 'payment'
-- 'rental'
-- 'sales_by_film_category'
-- 'sales_by_store'
-- 'staff'
-- 'staff_list'
-- 'store'
-- ```