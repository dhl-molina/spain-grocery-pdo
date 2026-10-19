<?php
/*
 * Runs a more complex SQL query (two JOINs + a subquery with GROUP BY)
 * and renders the result set as an HTML table.
 * It lists products priced above the average of their own category.
 */

// Load the PDO connection ($pdo)
require_once 'dbconfig.php';

// Complex query: join items with categories and with a derived table of category averages
$sql = "SELECT
            gi.item_id,
            gi.item_name,
            gi.brand,
            c.category_name,
            gi.unit_size,
            gi.price_eur,
            ROUND(ca.avg_price, 2)                AS category_avg_eur,
            ROUND(gi.price_eur - ca.avg_price, 2) AS above_avg_by
        FROM grocery_items AS gi
        INNER JOIN categories AS c ON c.category_id = gi.category_id
        INNER JOIN (
            SELECT category_id, AVG(price_eur) AS avg_price
            FROM grocery_items
            GROUP BY category_id
        ) AS ca ON ca.category_id = gi.category_id
        WHERE gi.price_eur > ca.avg_price
        ORDER BY above_avg_by DESC
        LIMIT 15";

$stmt = $pdo->query($sql);
$rows = $stmt->fetchAll();   // all rows as an array of associative arrays
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Spanish Grocery Items</title>
    <style>
        table { border-collapse: collapse; width: 100%; font-family: Arial, sans-serif; }
        th, td { border: 1px solid #999; padding: 6px 10px; text-align: left; }
        th { background: #c60b1e; color: #fff; }           /* red from the Spanish flag */
        tr:nth-child(even) { background: #fff3cd; }        /* light yellow stripes */
    </style>
</head>
<body>
    <h1>Items priced above their category average</h1>

    <?php if (count($rows) > 0): ?>
    <table>
        <thead>
            <tr>
                <?php // The column names come from the keys of the first row ?>
                <?php foreach (array_keys($rows[0]) as $column): ?>
                    <th><?= htmlspecialchars($column) ?></th>
                <?php endforeach; ?>
            </tr>
        </thead>
        <tbody>
            <?php // One table row (<tr>) for every record in the result set ?>
            <?php foreach ($rows as $row): ?>
                <tr>
                    <?php foreach ($row as $value): ?>
                        <?php // htmlspecialchars() prevents HTML injection from database values ?>
                        <td><?= htmlspecialchars((string) $value) ?></td>
                    <?php endforeach; ?>
                </tr>
            <?php endforeach; ?>
        </tbody>
    </table>
    <?php else: ?>
        <p>No records found.</p>
    <?php endif; ?>
</body>
</html>
