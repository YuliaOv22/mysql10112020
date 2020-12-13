-- Практическое задание по теме “Транзакции, переменные, представления”

-- 1. В базе данных shop и sample присутствуют одни и те же таблицы, учебной базы данных. 
-- Переместите запись id = 1 из таблицы shop.users в таблицу sample.users. Используйте транзакции.

START TRANSACTION;
INSERT INTO sample.users SELECT NULL, name, birthday_at, created_at, updated_at FROM shop.users WHERE id = 1;
DELETE FROM shop.users WHERE id = 1;
COMMIT;


-- 2. Создайте представление, которое выводит название name товарной позиции из таблицы products 
-- и соответствующее название каталога name из таблицы catalogs.

DROP VIEW IF EXISTS prod; 

CREATE VIEW prod (product_name, catalog_name) 
  AS SELECT p.name, c.name 
    FROM products AS p 
    LEFT JOIN catalogs AS c 
    ON p.catalog_id = c.id;
SELECT * FROM prod ORDER BY product_name;


-- 3. (по желанию) Пусть имеется таблица с календарным полем created_at. 
-- В ней размещены разряженые календарные записи за август 2018 года '2018-08-01', '2016-08-04', '2018-08-16' и 2018-08-17. 
-- Составьте запрос, который выводит полный список дат за август, выставляя в соседнем поле значение 1, 
-- если дата присутствует в исходном таблице и 0, если она отсутствует.

CREATE TABLE dates (
created_at DATETIME
);
SHOW TABLES;

SELECT * FROM dates;

INSERT INTO dates VALUES 
('2018-08-01'),
('2018-08-04'),
('2018-08-16'),
('2018-08-17');

SET @date_start = '2018-08-01';

SELECT 
t.august, 
NOT ISNULL(t.august = d.created_at) check_dates
FROM (
SELECT august FROM (
SELECT adddate(@date_start, CAST(concat(j, i) AS UNSIGNED)) august FROM
(SELECT 0 i UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) t0,
(SELECT 0 j UNION SELECT 1 UNION SELECT 2 UNION SELECT 3) t1
) date_list 
WHERE august BETWEEN @date_start AND adddate(@date_start, INTERVAL 30 DAY)) t
LEFT JOIN dates d
ON t.august = d.created_at
ORDER BY t.august;


-- 4. (по желанию) Пусть имеется любая таблица с календарным полем created_at. 
-- Создайте запрос, который удаляет устаревшие записи из таблицы, оставляя только 5 самых свежих записей.

DROP TABLE IF EXISTS posts;

CREATE TABLE IF NOT EXISTS posts (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255),
  created_at DATE NOT NULL
);

INSERT INTO posts VALUES
(NULL, 'Первая запись', '2018-11-01'),
(NULL, 'Вторая запись', '2018-11-02'),
(NULL, 'Третья запись', '2018-11-03'),
(NULL, 'Четвертая запись', '2018-11-04'),
(NULL, 'Пятая запись', '2018-11-05'),
(NULL, 'Шестая запись', '2018-11-06'),
(NULL, 'Седьмая запись', '2018-11-07'),
(NULL, 'Восьмая запись', '2018-11-08'),
(NULL, 'Девятая запись', '2018-11-09'),
(NULL, 'Десятая запись', '2018-11-10');

SELECT * FROM posts;

SET @s = (SELECT created_at FROM posts ORDER BY created_at LIMIT 5, 1);

DELETE FROM posts WHERE created_at < @s;
