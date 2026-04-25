CREATE OR REPLACE FUNCTION dollar_fmt(amount NUMERIC)
RETURNS VARCHAR(20)
LANGUAGE plpgsql
AS
$$
BEGIN
    RETURN TO_CHAR(amount, 'L99,999.00');
END;
$$;

CREATE OR REPLACE FUNCTION rental_month(rental_date TIMESTAMP)
RETURNS VARCHAR
LANGUAGE plpgsql
AS
$$
DECLARE month_of_rental VARCHAR;
BEGIN
    month_of_rental := TO_CHAR (rental_date, 'FMMonth');
    RETURN month_of_rental;
END;
$$;