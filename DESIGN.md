
#  Union Square Donuts: Database Design Documentation  
By **Lydia Oyediran**

---

##  Problem Statement

The goal of this project is to design a normalised SQLite database for a donut shop that can track raw ingredients, menu items (donuts), customer accounts, and sales orders.

---

##  Scope

### In Scope

The scope of this database includes:

- **People:** Customers who buy the donuts  
- **Things:** Menu donuts, raw ingredients (like Cocoa and sugar) 
- **Recipes:** The exact ingredients linked to a specific donut  

---

### Outside Scope

This database does not track:

- Shop employees  
- Payroll systems  
- Payment processing  
- Physical inventory stock levels  
- Bakery kitchen equipment  
- Daily store utilities  

---

##  Functional Requirements

### What Users Should Be Able to Do

Users should be able to:

-  View a complete recipe list (ingredients) for any given donut on the menu.
-  Log a new customer profile and keep a historical log of their purchases.
-  Calculate the exact total cost of a customer's order by multiplying item quantities against live menu prices.
-  Filter the menu for gluten-free options  

---

### Out of Scope

Users cannot:

- Process live credit card payments  
- Track delivery routes or logistics  
- Automatically update ingredient inventory after a sale  

---

##  Representation

### Entities

This section defines all tables in the database, including their attributes and constraints. It also explicitly identifies which tables function as junction tables and how primary keys are referenced through foreign keys.

---

#### `ingredients`

- **Attributes:**  
  `id` (INTEGER, PRIMARY KEY)  
  `name` (TEXT, NOT NULL, UNIQUE)  
  `unit` (TEXT, NOT NULL)  
  `price_per_unit` (NUMERIC, NOT NULL)  

- **Why these types?**  
  Text is used for descriptive fields such as ingredient names and measurement units. `NUMERIC` is used for pricing to allow decimal precision.

- **Why these constraints?**  
  - `PRIMARY KEY(id)` ensures each ingredient is uniquely identifiable  
  - `UNIQUE(name)` prevents duplicate ingredient entries  
  - `NOT NULL` ensures required data is always provided  
  - `CHECK(price_per_unit > 0)` enforces valid pricing  

---

#### `donuts`

- **Attributes:**  
  `id` (INTEGER, PRIMARY KEY)  
  `name` (TEXT, NOT NULL, UNIQUE)  
  `is_gluten_free` (INTEGER, NOT NULL)  
  `price` (NUMERIC, NOT NULL)  

- **Why these types?**  
  SQLite does not support a native boolean type, so `INTEGER` is used for `is_gluten_free` where 0 = false and 1 = true. `NUMERIC` is used for monetary values.

- **Why these constraints?**  
  - `PRIMARY KEY(id)` uniquely identifies each donut  
  - `UNIQUE(name)` prevents duplicate menu items  
  - `CHECK(is_gluten_free IN (0,1))` enforces boolean integrity  
  - `CHECK(price > 0)` ensures valid pricing  

---

#### `customers`

- **Attributes:**  
  `id` (INTEGER, PRIMARY KEY)  
  `first_name` (TEXT, NOT NULL)  
  `last_name` (TEXT, NOT NULL)  

- **Why these types?**  
  Names are stored as text to support flexible human name formats.

- **Why these constraints?**  
  - `PRIMARY KEY(id)` ensures each customer is uniquely identifiable  
  - `NOT NULL` ensures customer identity is always recorded  

---

#### `orders`

- **Attributes:**  
  `id` (INTEGER, PRIMARY KEY)  
  `customer_id` (INTEGER, FOREIGN KEY)  

- **Why these types?**  
  `customer_id` is an integer referencing the `customers` table.

- **Why these constraints?**  
  - `PRIMARY KEY(id)` uniquely identifies each order  
  - `FOREIGN KEY(customer_id) REFERENCES customers(id)` ensures every order belongs to a valid customer that has been registered 

---

#### `donut_ingredients` (Junction Table)

- **Attributes:**  
  `donut_id` (INTEGER, FOREIGN KEY)  
  `ingredient_id` (INTEGER, FOREIGN KEY)  

- **Why these types?**  
  Both fields are integers because they reference primary keys in parent tables.

- **Why these constraints?**  
  - `PRIMARY KEY(donut_id, ingredient_id)` prevents duplicate ingredient assignments  
  - `FOREIGN KEY(donut_id) REFERENCES donuts(id)` links to donuts table  
  - `FOREIGN KEY(ingredient_id) REFERENCES ingredients(id)` links to ingredients table  

- **Mapping Explanation:**  
  - `donut_id` → references `donuts(id)`  
  - `ingredient_id` → references `ingredients(id)`  

---

#### `order_items` (Junction Table)

- **Attributes:**  
  `id` (INTEGER, PRIMARY KEY)  
  `order_id` (INTEGER, FOREIGN KEY)  
  `donut_id` (INTEGER, FOREIGN KEY)  
  `quantity` (INTEGER, NOT NULL, DEFAULT 1)  

- **Why these types?**  
  Integer keys link orders and donuts efficiently. Quantity tracks how many items were purchased.

- **Why these constraints?**  
  - `PRIMARY KEY(id)` uniquely identifies each order item  
  - `FOREIGN KEY(order_id) REFERENCES orders(id)` links item to an order  
  - `FOREIGN KEY(donut_id) REFERENCES donuts(id)` links item to a donut  
  - `NOT NULL` ensures quantity is always defined  
  - `DEFAULT 1` ensures logical default ordering  

- **Mapping Explanation:**  
  - `order_id` → references `orders(id)`  
  - `donut_id` → references `donuts(id)`  

---

### Summary of Junction Tables

- `donut_ingredients` connects:
  - `donuts(id)` ↔ `ingredients(id)`

- `order_items` connects:
  - `orders(id)` ↔ `donuts(id)`

---

##  Relationships

### Entity Relationship Diagram (ERD)

![Union Square Donuts ERD](./Donut%20Orders%20ERD.png)

---

### Descriptions

- **Donuts ↔ Ingredients (Many-to-Many):**  
  One donut contains multiple ingredients, and one ingredient can be used in many donuts. This is resolved using the `donut_ingredients` bridge table.

- **Customers → Orders (One-to-Many):**  
  One customer can place multiple orders over time.

- **Orders ↔ Donuts (Many-to-Many):**  
  One order can include multiple donuts, and a donut can appear in many orders. This is resolved using the `order_items` table.

---

##  Optimizations

The following optimization was implemented:

- A **composite primary key** on the `donut_ingredients` table (`donut_id`, `ingredient_id`)

**Why?**

- Prevents duplicate ingredient assignments to the same donut  
- Automatically creates an index for faster lookups  
- Improves join performance when querying recipes  

---

##  Limitations

### Design Limitations

- The database does not store the price of a donut at the time of purchase.

---

### Representation Limitations

If the price of a donut changes (e.g., from $4.00 to $5.00), historical queries will reflect the new price instead of the original purchase price hence, making past financial records inaccurate. To fix this in a production environment, a `price_at_purchase` column would need to be added directly to the `order_items` table.
