-- Procedure to refresh rental reports
-- This procedure should be executed MONTHLY to track sales
CREATE OR REPLACE PROCEDURE refresh_rental_reports()
LANGUAGE plpgsql
AS $$
BEGIN
    -- 1. Clear existing data
    TRUNCATE TABLE detailed_report;
    TRUNCATE TABLE summary_report;

    -- 2. Extract and insert raw data into the detailed table
    INSERT INTO detailed_report (rental_id, film_title, category_name, payment_amount, rental_date, rental_month)
    SELECT
        payment.rental_id,
        film.title,
        category.name,
        dollar_fmt(payment.amount),
        rental.rental_date,
        rental_month(rental.rental_date)
    FROM payment
    JOIN rental ON payment.rental_id = rental.rental_id
    JOIN inventory ON rental.inventory_id = inventory.inventory_id
    JOIN film ON inventory.film_id = film.film_id
    JOIN film_category ON film.film_id = film_category.film_id
    JOIN category ON film_category.category_id = category.category_id;

    -- Note: The trigger 'refresh_summary_trigger' will automatically
    -- populate the summary_report table during this INSERT

    COMMIT;
END;
$$;