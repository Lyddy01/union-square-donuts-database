-- Represents raw materials purchased by the shop
CREATE TABLE "ingredients" (
    "id" INTEGER,
    "name" TEXT NOT NULL UNIQUE,
    "unit" TEXT NOT NULL, 
    "price_per_unit" NUMERIC NOT NULL CHECK ("price_per_unit" > 0),
    PRIMARY KEY("id")
);

-- Represents the past and present donuts on the menu
CREATE TABLE "donuts" (
    "id" INTEGER,
    "name" TEXT NOT NULL UNIQUE,
    "is_gluten_free" INTEGER NOT NULL CHECK ("is_gluten_free" IN (0, 1)), 
    "price" NUMERIC NOT NULL CHECK ("price" > 0),
    PRIMARY KEY("id")
);

-- Bridge table connecting donuts to their ingredient recipes
CREATE TABLE "donut_ingredients" (
    "donut_id" INTEGER,
    "ingredient_id" INTEGER,
    PRIMARY KEY("donut_id", "ingredient_id"),
    FOREIGN KEY("donut_id") REFERENCES "donuts"("id"),
    FOREIGN KEY("ingredient_id") REFERENCES "ingredients"("id")
);

-- Represents the shop's customers
CREATE TABLE "customers" (
    "id" INTEGER,
    "first_name" TEXT NOT NULL,
    "last_name" TEXT NOT NULL ,
    PRIMARY KEY ("id")
);

-- Represents a checkout transaction header
CREATE TABLE "orders" (
    "id" INTEGER,
    "customer_id" INTEGER,
    PRIMARY KEY("id"),
    FOREIGN KEY("customer_id") REFERENCES "customers"("id")
);

-- Represents specific items and quantities contained in a given order
CREATE TABLE "order_items" (
    "id" INTEGER,
    "order_id" INTEGER,
    "donut_id" INTEGER,
    "quantity" INTEGER NOT NULL DEFAULT 1,
    PRIMARY KEY("id"),
    FOREIGN KEY("order_id") REFERENCES "orders"("id"),
    FOREIGN KEY("donut_id") REFERENCES "donuts"("id")
);
