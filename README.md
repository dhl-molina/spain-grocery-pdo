# PDO Methods Activity: Spanish Grocery Database

Country chosen: **Spain**. I have been studying Spanish for over a year and I have relatives there I want to visit someday.

The grocery data uses real products from Spanish brands such as Pascual, Central Lechera Asturiana, Campofrío, ElPozo, Cola Cao, Nocilla, Calvo, Ortiz, Carbonell, Estrella Damm and Hacendado. Prices are in euros and are illustrative sample data.

## 1. Columns of the `grocery_items` table

| Column           | Data type        | Notes                                       |
|------------------|------------------|---------------------------------------------|
| `item_id`        | INT UNSIGNED     | Primary key, AUTO_INCREMENT                 |
| `item_name`      | VARCHAR(100)     | Product name in Spanish                     |
| `brand`          | VARCHAR(60)      | Brand name (Pascual, Calvo, ...)            |
| `category_id`    | INT UNSIGNED     | Foreign key to `categories.category_id`     |
| `unit_size`      | VARCHAR(30)      | For example `1 L`, `250 g`, `Pack 6 x 33 cl`|
| `price_eur`      | DECIMAL(6,2)     | Price in euros, must be greater than 0      |
| `stock_quantity` | INT UNSIGNED     | Units in stock, default 0                   |
| `expiry_date`    | DATE             | Can be NULL                                 |
| `is_alcoholic`   | TINYINT(1)       | 1 = alcoholic, 0 = not                      |
| `created_at`     | TIMESTAMP        | Defaults to the current time                |

The `categories` lookup table has `category_id` (INT UNSIGNED), `category_name` (VARCHAR(60)) and `category_name_es` (VARCHAR(60)).

## 2. Files

| File               | Purpose                                                              |
|--------------------|----------------------------------------------------------------------|
| `grocery_spain.sql`| Schema for both tables plus 10 categories and 100+ grocery records   |
| `queries.sql`      | Five complex queries: JOIN, GROUP BY/HAVING, subqueries, CTE, window function, CASE  |
| `dbconfig.php`     | PDO connection used by every other file                              |
| `fetchall.php`     | `fetchAll()` with `print_r()` inside `<pre>`                         |
| `fetch.php`        | `fetch()` with `print_r()` inside `<pre>`                            |
| `insert.php`       | INSERT with a prepared statement                                     |
| `delete.php`       | DELETE with a prepared statement                                     |
| `update.php`       | UPDATE with a prepared statement                                     |
| `table.php`        | Complex query rendered as an HTML table                              |

## 3. How to run it (XAMPP)

1. Start Apache and MySQL.
2. Open phpMyAdmin, go to the **Import** tab and import `grocery_spain.sql`. It creates the `spain_grocery` database.
3. Copy this folder into `htdocs` (XAMPP).
4. Open `http://localhost/spain-grocery-pdo/fetchall.php`, then the other pages.
5. If your MySQL user or password is different, edit them in `dbconfig.php`.

Suggested order for the demos: `fetchall.php`, `fetch.php`, `insert.php`, `update.php`, `delete.php`, `table.php`. `insert.php` adds a sample row each time it loads, and `delete.php` removes that sample row.
