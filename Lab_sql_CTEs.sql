use sakila;

-- Step 1: Create a View
-- First, create a view that summarizes rental information for each customer. 
-- The view should include the customer's ID, name, email address, and total number of rentals (rental_count).
CREATE VIEW view_1 AS
WITH summ_rental AS (
SELECT sr.customer_id,
CONCAT(sc.first_name," ", sc.last_name) as name,
sc.email,
COUNT(sr.rental_id) as rental_count
FROM sakila.rental AS sr
JOIN sakila.customer AS sc ON sr.customer_id = sc.customer_id
GROUP BY sr.customer_id
)
SELECT
customer_id,
name,
email,
rental_count
FROM summ_rental;


-- Step 2: Create a Temporary Table
-- Next, create a Temporary Table that calculates the total amount paid by each customer (total_paid). 
-- The Temporary Table should use the rental summary view created in Step 1 to join with the payment
 -- table and calculate the total amount paid by each customer.
CREATE TEMPORARY TABLE total_amount1
SELECT sre.customer_id,
sre.name,
SUM(amount) as total_paid
FROM view_1 as sre
JOIN sakila.payment as sp on sre.customer_id = sp.customer_id
GROUP BY sre.customer_id;
SELECT * from total_amount1;

-- Step 3: Create a CTE and the Customer Summary Report
WITH CTE_combined_data AS (
    SELECT 
        v.customer_id,
        v.name,
        v.email,
        v.rental_count,
        ta.total_paid,
        ROUND(ta.total_paid/v.rental_count,2) AS average_payment_per_rental
    FROM view_1 AS v
    JOIN total_amount1 AS ta ON v.customer_id = ta.customer_id
)
-- Seleccionar los datos combinados
SELECT 
    name,
    email,
    rental_count,
    total_paid,
    average_payment_per_rental
FROM CTE_combined_data;


