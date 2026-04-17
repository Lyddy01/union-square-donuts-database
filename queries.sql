-- ===================================================
-- 1. INSERT SAMPLE DATA (INSERT STATEMENTS)

-- ===================================================

-- Insert Ingredients
INSERT INTO "ingredients" ("name", "unit", "price_per_unit") VALUES ('Cocoa', 'pound', 5.00);
INSERT INTO "ingredients" ("name", "unit", "price_per_unit") VALUES ('Sugar', 'pound', 2.00);
INSERT INTO "ingredients" ("name", "unit", "price_per_unit") VALUES ('Flour', 'pound', 1.50);
INSERT INTO "ingredients" ("name", "unit", "price_per_unit") VALUES ('Buttermilk', 'gallon', 3.00);
INSERT INTO "ingredients" ("name", "unit", "price_per_unit") VALUES ('Sprinkles', 'pound', 4.00);

-- Insert Donut type
INSERT INTO "donuts" ("name", "is_gluten_free", "price") VALUES ('Belgian Dark Chocolate', 0, 4.00);
INSERT INTO "donuts" ("name", "is_gluten_free", "price") VALUES ('Back-To-School Sprinkles', 0, 4.00);

-- Map Ingredients to Donuts (Recipes)
INSERT INTO "donut_ingredients" ("donut_id", "ingredient_id") VALUES (1, 1), (1, 2), (1, 3), (1, 4);
INSERT INTO "donut_ingredients" ("donut_id", "ingredient_id") VALUES (2, 2), (2, 3), (2, 4), (2, 5);

-- Insert Customer's name
INSERT INTO "customers" ("first_name", "last_name") VALUES ('Lydia', 'Oyediran');

-- Insert customer id into "Orders" table
INSERT INTO "orders" ("customer_id") VALUES (1);

-- Add Items to the Order
INSERT INTO "order_items" ("order_id", "donut_id", "quantity") VALUES (1, 1, 3);
INSERT INTO "order_items" ("order_id", "donut_id", "quantity") VALUES (1, 2, 2);


-- ===================================================
-- 2. QUERIES FOR USERS
-- =================================================

-- Query to calculate the total number of donuts sold by type
--from the highest to the lowest
SELECT 
    "d"."name" AS "donut_name",
    SUM("oi"."quantity") AS "total_sold"
FROM "order_items" AS "oi"
JOIN "donuts" AS "d" ON "oi"."donut_id" = "d"."id"
GROUP BY "d"."name"
ORDER BY "total_sold" DESC;

-- Query to find all gluten-free donuts
SELECT "name", "price" FROM "donuts" WHERE "is_gluten_free" = 1;

-- Query to calculate the total price of Lydia's order with an id of 1
SELECT SUM("oi"."quantity" * "d"."price") AS "total_order_price"
FROM "order_items" AS "oi"
JOIN "donuts" AS "d" ON "oi"."donut_id" = "d"."id"
WHERE "oi"."order_id" = 1;
