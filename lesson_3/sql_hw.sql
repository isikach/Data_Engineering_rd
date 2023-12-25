/*
 Завдання на SQL до лекції 03.
 */
/*
1.
Вивести кількість фільмів в кожній категорії.
Результат відсортувати за спаданням.
*/

SELECT
    c.name,
    COUNT(f.film_id)
FROM category AS c
JOIN film_category AS f ON c.category_id = f.category_id
GROUP BY c.name
ORDER BY COUNT(f.film_id) DESC;

/*
2.
Вивести 10 акторів, чиї фільми брали на прокат найбільше.
Результат відсортувати за спаданням.
*/

SELECT 
	a.first_name
	, a.last_name
FROM actor a 
JOIN film_actor fa ON fa.actor_id = a.actor_id 
JOIN inventory i ON i.film_id = fa.film_id 
JOIN rental r ON r.inventory_id = i.inventory_id 
JOIN payment p ON p.rental_id = r.rental_id 
group by a.first_name, a.last_name
order by count(p.*) desc
LIMIT 10;

/*
3.
Вивести категорія фільмів, на яку було витрачено найбільше грошей
в прокаті
*/

WITH ranked_categories AS (
  SELECT
    c.name,
    SUM(p.amount) AS total_amount,
    RANK() OVER (ORDER BY SUM(p.amount) DESC) AS category_rank
  FROM
    category c
    JOIN film_category fc ON fc.category_id = c.category_id
    JOIN inventory i ON i.film_id = fc.film_id
    JOIN rental r ON r.inventory_id = i.inventory_id
    JOIN payment p ON r.rental_id = p.rental_id
  GROUP BY
    c.name
)
SELECT name
FROM ranked_categories
WHERE category_rank = 1;
/*
4.
Вивести назви фільмів, яких не має в inventory.
Запит має бути без оператора IN
*/

WITH count_inventory AS (
	SELECT f.title,
	COUNT(i.*) over(PARTITION BY i.film_id) AS film_count
	FROM inventory i
	RIGHT JOIN film f ON i.film_id = f.film_id
)
SELECT title 
FROM count_inventory 
WHERE film_count = 0;

/*
5.
Вивести топ 3 актори, які найбільше зʼявлялись в категорії фільмів “Children”.
*/
WITH name_count AS (
    SELECT
      DISTINCT CONCAT(a.first_name,' ', a.last_name) AS name,
      COUNT(c.name) OVER(PARTITION BY CONCAT(a.last_name, a.first_name)) as film_count
    FROM actor AS a
    JOIN film_actor fa ON fa.actor_id = a.actor_id
    JOIN film_category fc ON fc.film_id = fa.film_id
    JOIN category c ON fc.category_id = c.category_id
    WHERE c.name = 'Children')
SELECT name 
FROM name_count 
ORDER BY film_count DESC 
LIMIT 3;
