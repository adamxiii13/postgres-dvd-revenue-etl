-- The Trigger Function
CREATE OR REPLACE FUNCTION update_summary_report()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
DECLARE
    -- Variable needs to hold a numeric amount with no dollar sign to fix a crash due to formatting differences between payment_amount and total_revenue
    raw_amount NUMERIC;
BEGIN
    -- 1. Remove the '$' and commas (converts '$1,000.00' to numeric 1000.00)
    -- We use TRANSLATE to remove the '$' and ',' characters
    raw_amount := CAST(TRANSLATE(NEW.payment_amount, '$,', '') AS NUMERIC);

    -- 2. update the existing row
    UPDATE summary_report
    SET total_revenue = total_revenue + raw_amount
    WHERE category_name = NEW.category_name
    AND rental_month = NEW.rental_month;

    -- 3. If no row exists, insert a new one
    IF NOT FOUND THEN
        INSERT INTO summary_report(category_name, rental_month, total_revenue)
        VALUES (NEW.category_name, NEW.rental_month, raw_amount);
    END IF;

    RETURN NEW;
END;
$$;

-- The Trigger Statement
CREATE TRIGGER refresh_summary_trigger
AFTER INSERT ON detailed_report
FOR EACH ROW
EXECUTE FUNCTION update_summary_report();