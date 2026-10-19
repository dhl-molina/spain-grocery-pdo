-- =====================================================================
-- PDO METHODS ACTIVITY - Spanish Grocery Database
-- Country: Spain
-- Prices are in euros (EUR) and are illustrative sample data.
-- Tested for MySQL 8 / MariaDB 10.5+
-- =====================================================================

DROP DATABASE IF EXISTS spain_grocery;
CREATE DATABASE spain_grocery
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE spain_grocery;

SET NAMES utf8mb4;

-- ---------------------------------------------------------------------
-- Table 1: categories (lookup table, one row per grocery aisle)
-- ---------------------------------------------------------------------
CREATE TABLE categories (
    category_id    INT UNSIGNED NOT NULL AUTO_INCREMENT,
    category_name  VARCHAR(60)  NOT NULL,   -- English name
    category_name_es VARCHAR(60) NOT NULL,  -- Spanish name
    PRIMARY KEY (category_id),
    UNIQUE KEY uq_category_name (category_name)
) ENGINE=InnoDB;

-- ---------------------------------------------------------------------
-- Table 2: grocery_items (main table, 10 columns, 100+ rows)
-- ---------------------------------------------------------------------
CREATE TABLE grocery_items (
    item_id        INT UNSIGNED  NOT NULL AUTO_INCREMENT,
    item_name      VARCHAR(100)  NOT NULL,
    brand          VARCHAR(60)   NOT NULL,
    category_id    INT UNSIGNED  NOT NULL,
    unit_size      VARCHAR(30)   NOT NULL,
    price_eur      DECIMAL(6,2)  NOT NULL,
    stock_quantity INT UNSIGNED  NOT NULL DEFAULT 0,
    expiry_date    DATE          NULL,
    is_alcoholic   TINYINT(1)    NOT NULL DEFAULT 0,
    created_at     TIMESTAMP     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (item_id),
    KEY idx_items_category (category_id),
    KEY idx_items_brand (brand),
    CONSTRAINT fk_items_category
        FOREIGN KEY (category_id) REFERENCES categories (category_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    CONSTRAINT chk_price_positive CHECK (price_eur > 0)
) ENGINE=InnoDB;

-- ---------------------------------------------------------------------
-- Records: categories
-- ---------------------------------------------------------------------
INSERT INTO categories (category_id, category_name, category_name_es) VALUES
(1,  'Dairy & Eggs',               'Lácteos y Huevos'),
(2,  'Meat & Charcuterie',         'Carne y Embutidos'),
(3,  'Seafood & Canned Fish',      'Pescado y Conservas'),
(4,  'Oils, Sauces & Condiments',  'Aceites, Salsas y Condimentos'),
(5,  'Rice, Pasta & Legumes',      'Arroz, Pasta y Legumbres'),
(6,  'Biscuits, Sweets & Snacks',  'Galletas, Dulces y Aperitivos'),
(7,  'Breakfast & Spreads',        'Desayuno y Untables'),
(8,  'Beverages',                  'Bebidas'),
(9,  'Bakery',                     'Panadería y Bollería'),
(10, 'Soups & Ready Meals',        'Sopas y Platos Preparados');

-- ---------------------------------------------------------------------
-- Records: grocery_items
-- Column order: item_name, brand, category_id, unit_size, price_eur,
--               stock_quantity, expiry_date, is_alcoholic
-- ---------------------------------------------------------------------
INSERT INTO grocery_items
    (item_name, brand, category_id, unit_size, price_eur, stock_quantity, expiry_date, is_alcoholic)
VALUES
-- 1) Dairy & Eggs ------------------------------------------------------
('Leche Entera',                          'Pascual',                   1, '1 L',        1.15, 240, '2027-03-15', 0),
('Leche Semidesnatada',                   'Central Lechera Asturiana', 1, '1 L',        1.29, 210, '2027-02-20', 0),
('Leche Desnatada con Calcio',            'Puleva',                    1, '1 L',        1.39, 180, '2027-03-01', 0),
('Leche Sin Lactosa',                     'Kaiku',                     1, '1 L',        1.49, 150, '2027-02-10', 0),
('Yogur Natural Pack 4',                  'Pascual',                   1, '4 x 125 g',  1.59, 120, '2026-12-20', 0),
('Mantequilla Sin Sal',                   'Reny Picot',                1, '250 g',      2.95,  70, '2027-01-18', 0),
('Queso Manchego Curado Cuña',            'García Baquero',            1, '250 g',      5.95,  55, '2027-04-30', 0),
('Queso Fresco de Burgos',                'Hacendado',                 1, '500 g',      3.25,  60, '2026-12-05', 0),
('Huevos Camperos Talla L',               'Hacendado',                 1, '12 uds',     3.10, 140, '2026-11-25', 0),
('Bebida de Almendra Sin Azúcar',         'Hacendado',                 1, '1 L',        1.35,  95, '2027-05-12', 0),

-- 2) Meat & Charcuterie ------------------------------------------------
('Chorizo Cular Extra',                   'Campofrío',                 2, '200 g',      3.45,  85, '2027-02-28', 0),
('Salchichón Extra',                      'Campofrío',                 2, '200 g',      3.39,  80, '2027-02-28', 0),
('Pechuga de Pavo en Lonchas',            'Campofrío',                 2, '140 g',      1.99, 100, '2026-12-14', 0),
('Jamón Cocido Extra en Lonchas',         'ElPozo',                    2, '200 g',      2.79,  95, '2026-12-10', 0),
('Jamón Serrano en Lonchas',              'ElPozo',                    2, '150 g',      3.49,  90, '2027-01-25', 0),
('Fuet Espetec',                          'Casademont',                2, '150 g',      2.69, 130, '2027-03-31', 0),
('Sobrasada de Mallorca',                 'Camp Mallorquí',            2, '250 g',      3.95,  65, '2027-04-15', 0),
('Chorizo Sarta Dulce',                   'Palacios',                  2, '225 g',      3.29,  88, '2027-03-10', 0),
('Chorizo Sarta Picante',                 'Palacios',                  2, '225 g',      3.29,  84, '2027-03-10', 0),
('Jamón Ibérico de Bellota en Lonchas',   'Cinco Jotas',               2, '80 g',      14.95,  30, '2027-05-20', 0),
('Paleta Ibérica de Bellota en Lonchas',  'Joselito',                  2, '70 g',       9.95,  28, '2027-05-20', 0),
('Chorizo Ibérico Cular',                 'Revilla',                   2, '200 g',      4.59,  52, '2027-03-25', 0),

-- 3) Seafood & Canned Fish --------------------------------------------
('Atún Claro en Aceite de Oliva',         'Calvo',                     3, 'Pack 3 x 65 g', 4.45, 200, '2030-01-01', 0),
('Atún Claro al Natural',                 'Calvo',                     3, 'Pack 3 x 52 g', 3.99, 190, '2030-01-01', 0),
('Bonito del Norte en Aceite de Oliva',   'Ortiz',                     3, '112 g',      4.25,  70, '2030-06-01', 0),
('Anchoas del Cantábrico en Aceite',      'Ortiz',                     3, '47 g',       4.95,  60, '2029-11-01', 0),
('Sardinillas en Aceite de Oliva',        'Ramón Peña',                3, '70 g',       2.35,  80, '2030-03-01', 0),
('Berberechos al Natural',                'Rianxeira',                 3, '63 g',       3.45,  65, '2030-02-01', 0),
('Mejillones en Escabeche',               'Escuris',                   3, '69 g',       1.89,  90, '2030-02-01', 0),
('Pulpo en Aceite de Oliva',              'Frinsa',                    3, '111 g',      3.75,  45, '2030-04-01', 0),
('Merluza en Rodajas Congelada',          'Pescanova',                 3, '600 g',      6.49,  40, '2027-06-30', 0),
('Gambas Peladas Congeladas',             'Pescanova',                 3, '400 g',      7.99,  35, '2027-06-30', 0),
('Calamares a la Romana',                 'Pescanova',                 3, '400 g',      4.69,  50, '2027-06-30', 0),

-- 4) Oils, Sauces & Condiments ----------------------------------------
('Aceite de Oliva Virgen Extra',          'Carbonell',                 4, '1 L',        9.95, 120, '2028-03-01', 0),
('Aceite de Oliva Virgen Extra',          'Hojiblanca',                4, '1 L',        9.49, 110, '2028-02-01', 0),
('Aceite de Oliva Intenso',               'Ybarra',                    4, '1 L',        8.75, 105, '2028-01-01', 0),
('Aceite de Oliva Virgen Extra',          'Coosur',                    4, '1 L',        9.29,  98, '2028-04-01', 0),
('Aceite de Oliva Virgen Extra',          'Borges',                    4, '1 L',        9.85,  90, '2028-03-01', 0),
('Aceite de Girasol',                     'Hacendado',                 4, '1 L',        1.89, 220, '2027-09-01', 0),
('Mayonesa',                              'Ybarra',                    4, '450 ml',     2.39, 100, '2027-04-10', 0),
('Aceitunas Manzanilla Rellenas de Anchoa','Serpis',                   4, '350 g',      1.79, 130, '2028-02-01', 0),
('Pimentón de la Vera Dulce',             'Carmencita',                4, '75 g',       2.15,  80, '2028-06-01', 0),
('Azafrán en Hebras',                     'Carmencita',                4, '0,5 g',      2.45,  60, '2029-01-01', 0),
('Tomate Frito',                          'Hacendado',                 4, '400 g',      1.05, 160, '2028-03-01', 0),

-- 5) Rice, Pasta & Legumes --------------------------------------------
('Arroz Bomba D.O. Valencia',             'La Fallera',                5, '1 kg',       3.95, 150, '2028-05-01', 0),
('Arroz Redondo',                         'Brillante',                 5, '1 kg',       1.99, 170, '2028-06-01', 0),
('Arroz Largo',                           'SOS',                       5, '1 kg',       2.09, 160, '2028-06-01', 0),
('Arroz Bomba D.O. Calasparra',           'Nomen',                     5, '1 kg',       4.25,  85, '2028-05-01', 0),
('Espaguetis',                            'Gallo',                     5, '500 g',      1.35, 200, '2028-09-01', 0),
('Macarrones',                            'Gallo',                     5, '500 g',      1.35, 195, '2028-09-01', 0),
('Fideos Finos Nº 0',                     'Gallo',                     5, '500 g',      1.29, 140, '2028-09-01', 0),
('Garbanzos Cocidos',                     'Luengo',                    5, '400 g',      1.29, 125, '2028-01-01', 0),
('Alubias Blancas Cocidas',               'Luengo',                    5, '400 g',      1.29, 118, '2028-01-01', 0),
('Lentejas Pardinas',                     'Luengo',                    5, '500 g',      2.35, 100, '2028-08-01', 0),
('Fabada Asturiana',                      'Litoral',                   5, '440 g',      2.89,  90, '2029-03-01', 0),

-- 6) Biscuits, Sweets & Snacks ----------------------------------------
('Galletas María Dorada',                 'Cuétara',                   6, '800 g',      2.89, 140, '2027-08-01', 0),
('Galletas María',                        'Fontaneda',                 6, '800 g',      2.95, 135, '2027-08-01', 0),
('Galletas Digestive',                    'Fontaneda',                 6, '425 g',      2.19, 110, '2027-07-01', 0),
('Galletas Chiquilín',                    'Gullón',                    6, '250 g',      1.69, 150, '2027-09-01', 0),
('Galletas Digestive Avena',              'Gullón',                    6, '400 g',      2.09, 115, '2027-07-01', 0),
('Galletas Dinosaurus Cereales',          'Artiach',                   6, '500 g',      2.79,  90, '2027-06-01', 0),
('Lacasitos',                             'Lacasa',                    6, '100 g',      1.45, 180, '2027-10-01', 0),
('Chupa Chups Surtido',                   'Chupa Chups',               6, '12 uds',     2.35, 160, '2028-02-01', 0),
('Turrón de Jijona',                      'El Almendro',               6, '250 g',      5.25,  70, '2027-06-30', 0),
('Turrón de Alicante',                    '1880',                      6, '250 g',      5.45,  66, '2027-06-30', 0),
('Patatas Fritas Lisas',                  'Matutano',                  6, '170 g',      2.05, 175, '2027-02-15', 0),
('Patatas Fritas Campesinas',             'Matutano',                  6, '170 g',      2.15, 160, '2027-02-15', 0),

-- 7) Breakfast & Spreads ----------------------------------------------
('Cacao Soluble Original',                'Cola Cao',                  7, '760 g',      5.45, 130, '2028-01-01', 0),
('Crema de Cacao Original',               'Nocilla',                   7, '190 g',      2.15, 120, '2027-08-01', 0),
('Crema de Cacao y Avellanas 2 Sabores',  'Nocilla',                   7, '190 g',      2.25, 100, '2027-08-01', 0),
('Café Molido Natural',                   'Marcilla',                  7, '250 g',      3.65, 130, '2028-02-01', 0),
('Café Molido Descafeinado',              'Marcilla',                  7, '250 g',      3.75,  85, '2028-02-01', 0),
('Café Molido Mezcla',                    'Saimaza',                   7, '250 g',      3.25,  95, '2028-02-01', 0),
('Café Molido Natural',                   'Cafés Candelas',            7, '250 g',      3.85,  72, '2028-03-01', 0),
('Mermelada de Fresa',                    'Hacendado',                 7, '410 g',      1.55, 105, '2028-04-01', 0),
('Miel Milflores',                        'Hacendado',                 7, '500 g',      3.95,  68, '2029-01-01', 0),

-- 8) Beverages ----------------------------------------------------------
('Agua Mineral Natural',                  'Font Vella',                8, '1,5 L',      0.62, 300, '2028-01-01', 0),
('Agua Mineral Natural',                  'Lanjarón',                  8, '1,5 L',      0.66, 280, '2028-01-01', 0),
('Agua Mineral Natural',                  'Solán de Cabras',           8, '1,5 L',      0.79, 160, '2028-01-01', 0),
('Agua Mineral con Gas',                  'Vichy Catalán',             8, '1 L',        1.25,  90, '2028-01-01', 0),
('Cerveza Lager',                         'Estrella Damm',             8, 'Pack 6 x 33 cl', 5.25, 150, '2027-06-30', 1),
('Cerveza Cinco Estrellas',               'Mahou',                     8, 'Pack 6 x 33 cl', 4.99, 145, '2027-06-30', 1),
('Cerveza Especial',                      'San Miguel',                8, 'Pack 6 x 33 cl', 4.85, 140, '2027-06-30', 1),
('Cerveza Especial',                      'Cruzcampo',                 8, 'Pack 6 x 33 cl', 4.69, 135, '2027-06-30', 1),
('Cerveza Lager',                         'Estrella Galicia',          8, 'Pack 6 x 33 cl', 5.19, 120, '2027-06-30', 1),
('Cerveza Sin Alcohol 0,0',               'Mahou',                     8, 'Pack 6 x 25 cl', 3.99,  90, '2027-06-30', 0),
('Vino Tinto Rioja Crianza',              'Marqués de Cáceres',        8, '75 cl',      7.45,  60, '2030-01-01', 1),
('Vino Tinto Rioja Crianza',              'Campo Viejo',               8, '75 cl',      6.95,  70, '2030-01-01', 1),
('Vino Blanco Verdejo D.O. Rueda',        'Marqués de Riscal',         8, '75 cl',      9.95,  45, '2029-01-01', 1),
('Cava Carta Nevada Brut',                'Freixenet',                 8, '75 cl',      6.49,  80, '2029-06-01', 1),
('Tinto de Verano',                       'Don Simón',                 8, '1 L',        1.49, 130, '2027-08-01', 1),
('Zumo de Naranja',                       'Don Simón',                 8, '1 L',        1.45, 160, '2027-05-01', 0),
('Horchata de Chufa',                     'Chufamix',                  8, '1 L',        2.19,  85, '2027-04-01', 0),
('Batido de Cacao',                       'Cacaolat',                  8, 'Pack 6 x 200 ml', 4.25, 95, '2027-03-01', 0),
('Refresco de Naranja',                   'Kas',                       8, 'Pack 6 x 33 cl', 3.29, 110, '2027-10-01', 0),

-- 9) Bakery -------------------------------------------------------------
('Donuts Originales',                     'Donuts',                    9, '6 uds',      2.69,  90, '2026-12-30', 0),
('Bollycao Chocolate',                    'Bollycao',                  9, '6 uds',      2.45,  85, '2026-12-28', 0),
('Phoskitos Cacao',                       'Phoskitos',                 9, '6 uds',      2.35,  80, '2026-12-28', 0),
('Magdalenas Tradicionales',              'Dulcesol',                  9, '12 uds',     2.29, 100, '2027-01-10', 0),
('Palmeritas de Hojaldre',                'Dulcesol',                  9, '150 g',      1.99,  75, '2027-01-10', 0),
('Pan de Molde Integral',                 'Hacendado',                 9, '460 g',      1.45,  95, '2026-11-30', 0),
('Picos de Pan Rústicos',                 'Hacendado',                 9, '200 g',      1.25,  70, '2027-03-15', 0),
('Mini Croissants',                       'Hacendado',                 9, '10 uds',     1.75,  60, '2026-12-15', 0),

-- 10) Soups & Ready Meals --------------------------------------------
('Caldo de Pollo',                        'Gallina Blanca',           10, '1 L',        1.89, 120, '2027-06-01', 0),
('Caldo de Carne',                        'Gallina Blanca',           10, '1 L',        1.89, 110, '2027-06-01', 0),
('Pastillas de Caldo de Pollo',           'Avecrem',                  10, '12 pastillas', 1.99, 130, '2028-03-01', 0),
('Gazpacho Original',                     'Alvalle',                  10, '1 L',        2.35, 100, '2027-01-15', 0),
('Salmorejo',                             'Alvalle',                  10, '1 L',        2.49,  90, '2027-01-15', 0),
('Tortilla de Patata con Cebolla',        'Hacendado',                10, '500 g',      3.45,  70, '2026-12-01', 0),
('Croquetas de Jamón',                    'Hacendado',                10, '500 g',      3.25,  65, '2027-05-01', 0),
('Paella Mixta Congelada',                'Hacendado',                10, '600 g',      4.95,  45, '2027-06-01', 0),
('Pizza Jamón y Queso',                   'Casa Tarradellas',         10, '400 g',      3.19,  80, '2027-03-01', 0);
