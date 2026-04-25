CREATE TABLE detailed_report(
    rental_id INTEGER,
    film_title VARCHAR(255),
    category_name VARCHAR(25),
    payment_amount VARCHAR(20),
    rental_date TIMESTAMP,
    rental_month VARCHAR(20)
);

CREATE TABLE summary_report (
    category_name VARCHAR(50),
    rental_month VARCHAR(20),
    total_revenue NUMERIC(10,2)
);