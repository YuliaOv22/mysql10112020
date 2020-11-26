-- Практическое задание по теме «Операторы, фильтрация, сортировка и ограничение»
-- 1. Пусть в таблице users поля created_at и updated_at оказались незаполненными. Заполните их текущими датой и временем.

SELECT * FROM users;
-- Очищаем поля created_at и updated_at для выполнения условий задачи.
UPDATE users SET created_at = NULL, updated_at = NULL;
-- Заполняем поля created_at и updated_at текущими датой и временем.
UPDATE users SET created_at = NOW(), updated_at = NOW();


-- 2. Таблица users была неудачно спроектирована. 
-- Записи created_at и updated_at были заданы типом VARCHAR и в них долгое время помещались значения в формате 20.10.2017 8:10. 
-- Необходимо преобразовать поля к типу DATETIME, сохранив введённые ранее значения.

DESC users;
-- Задаем полям created_at и updated_at тип VARCHAR для выполнения условий задачи.
ALTER TABLE users MODIFY COLUMN created_at VARCHAR(100);
ALTER TABLE users MODIFY COLUMN updated_at VARCHAR(100);
SELECT * FROM users;
-- Заполняем поля created_at и updated_at значениями в формате 20.10.2017 8:10 для выполнения условий задачи.
UPDATE users SET created_at = '20.10.2017 8:10', updated_at = '20.10.2017 8:10';
-- Преобразуем поля created_at и updated_at к типу DATETIME, сохранив введённые ранее значения, через создание новой таблицы.
-- Создаем новую таблицу.
CREATE TABLE users_new (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) COMMENT 'Имя покупателя',
  birthday_at DATE COMMENT 'Дата рождения',
  created_at DATETIME,
  updated_at DATETIME
) COMMENT = 'Покупатели';
DESC users_new;
SELECT * FROM users_new;
-- Копируем в новую таблицу данные из старой таблицы с преобразованием полей created_at и updated_at.
INSERT INTO 
  users_new
SELECT
  id, name, birthday_at, STR_TO_DATE(created_at, '%d.%m.%Y %T'), STR_TO_DATE(updated_at, '%d.%m.%Y %T')
FROM 
  users;
-- Удаляем старую таблицу.
DROP TABLE users;
-- Переименовываем новую таблицу со старым названием.
ALTER TABLE users_new RENAME users;
SELECT * FROM users;
DESC users;
-- Добавляем настройки к полям created_at и updated_at.
ALTER TABLE users MODIFY COLUMN created_at DATETIME DEFAULT CURRENT_TIMESTAMP;
ALTER TABLE users MODIFY COLUMN updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;
-- Проверяем таблицу на новых данных.
INSERT INTO users (name, birthday_at) VALUES ('Vasya', '1999-02-23');


-- 3. В таблице складских запасов storehouses_products в поле value могут встречаться самые разные цифры: 0, 
-- если товар закончился и выше нуля, если на складе имеются запасы. Необходимо отсортировать записи таким образом, 
-- чтобы они выводились в порядке увеличения значения value. Однако нулевые запасы должны выводиться в конце, после всех записей.

DESC storehouses_products;
SELECT * FROM storehouses_products;
-- Заполняем таблицу значениями.
INSERT INTO 
  storehouses_products (id, storehouse_id, product_id, value, created_at, updated_at) 
VALUES 
  ('1', 9, 8, 0, '1984-04-26 01:28:03', '2011-11-27 11:57:17'),
  ('2', 6, 9, 4, '1988-06-19 16:30:04', '2004-05-18 17:02:42'),
  ('3', 2, 2, 250, '1989-08-13 23:14:06', '1997-05-11 05:11:53'),
  ('4', 7, 5, 6, '2011-07-07 03:47:06', '1989-02-05 05:06:44'),
  ('5', 6, 9, 3, '1987-02-26 12:12:43', '1970-06-18 20:06:47'),
  ('6', 7, 2, 1000, '2018-12-19 16:03:02', '1997-12-09 10:04:58'),
  ('7', 1, 1, 0, '1984-06-30 11:55:47', '1976-12-25 04:57:32'),
  ('8', 9, 2, 1, '2000-06-28 22:24:17', '2008-01-15 05:02:23'),
  ('9', 8, 3, 20, '2016-02-28 01:23:41', '1974-10-25 09:27:33'),
  ('10', 7, 9, 0, '1994-07-30 22:29:27', '2013-07-28 21:39:01');
-- Сортируем согласно условиям задачи.
SELECT id, storehouse_id, product_id, value, created_at, updated_at FROM storehouses_products ORDER BY FIELD(value, 0), value;


-- 4. (по желанию) Из таблицы users необходимо извлечь пользователей, родившихся в августе и мае. 
-- Месяцы заданы в виде списка английских названий (may, august).

SELECT * FROM users;
DESC users;
SELECT * FROM users WHERE MONTHNAME(birthday_at) = 'may' OR MONTHNAME(birthday_at) = 'august';


-- 5. (по желанию) Из таблицы catalogs извлекаются записи при помощи запроса. 
-- SELECT * FROM catalogs WHERE id IN (5, 1, 2); Отсортируйте записи в порядке, заданном в списке IN.

SELECT * FROM catalogs;
SELECT * FROM catalogs WHERE id IN (5, 1, 2) ORDER BY FIELD(id, 5, 1, 2);





CREATE DATABASE homework3;
SHOW DATABASES;
USE homework3;
SHOW TABLES;

DROP TABLE IF EXISTS catalogs;
CREATE TABLE catalogs (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) COMMENT 'Название раздела',
  UNIQUE unique_name(name(10))
) COMMENT = 'Разделы интернет-магазина';

INSERT INTO catalogs VALUES
  (NULL, 'Процессоры'),
  (NULL, 'Материнские платы'),
  (NULL, 'Видеокарты'),
  (NULL, 'Жесткие диски'),
  (NULL, 'Оперативная память');

DROP TABLE IF EXISTS users;
CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) COMMENT 'Имя покупателя',
  birthday_at DATE COMMENT 'Дата рождения',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT = 'Покупатели';

INSERT INTO users (name, birthday_at) VALUES
  ('Геннадий', '1990-10-05'),
  ('Наталья', '1984-11-12'),
  ('Александр', '1985-05-20'),
  ('Сергей', '1988-02-14'),
  ('Иван', '1998-01-12'),
  ('Мария', '1992-08-29');

DROP TABLE IF EXISTS products;
CREATE TABLE products (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) COMMENT 'Название',
  description TEXT COMMENT 'Описание',
  price DECIMAL (11,2) COMMENT 'Цена',
  catalog_id INT UNSIGNED,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  KEY index_of_catalog_id (catalog_id)
) COMMENT = 'Товарные позиции';

INSERT INTO products
  (name, description, price, catalog_id)
VALUES
  ('Intel Core i3-8100', 'Процессор для настольных персональных компьютеров, основанных на платформе Intel.', 7890.00, 1),
  ('Intel Core i5-7400', 'Процессор для настольных персональных компьютеров, основанных на платформе Intel.', 12700.00, 1),
  ('AMD FX-8320E', 'Процессор для настольных персональных компьютеров, основанных на платформе AMD.', 4780.00, 1),
  ('AMD FX-8320', 'Процессор для настольных персональных компьютеров, основанных на платформе AMD.', 7120.00, 1),
  ('ASUS ROG MAXIMUS X HERO', 'Материнская плата ASUS ROG MAXIMUS X HERO, Z370, Socket 1151-V2, DDR4, ATX', 19310.00, 2),
  ('Gigabyte H310M S2H', 'Материнская плата Gigabyte H310M S2H, H310, Socket 1151-V2, DDR4, mATX', 4790.00, 2),
  ('MSI B250M GAMING PRO', 'Материнская плата MSI B250M GAMING PRO, B250, Socket 1151, DDR4, mATX', 5060.00, 2);

DROP TABLE IF EXISTS orders;
CREATE TABLE orders (
  id SERIAL PRIMARY KEY,
  user_id INT UNSIGNED,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  KEY index_of_user_id(user_id)
) COMMENT = 'Заказы';

DROP TABLE IF EXISTS orders_products;
CREATE TABLE orders_products (
  id SERIAL PRIMARY KEY,
  order_id INT UNSIGNED,
  product_id INT UNSIGNED,
  total INT UNSIGNED DEFAULT 1 COMMENT 'Количество заказанных товарных позиций',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT = 'Состав заказа';

DROP TABLE IF EXISTS discounts;
CREATE TABLE discounts (
  id SERIAL PRIMARY KEY,
  user_id INT UNSIGNED,
  product_id INT UNSIGNED,
  discount FLOAT UNSIGNED COMMENT 'Величина скидки от 0.0 до 1.0',
  started_at DATETIME,
  finished_at DATETIME,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  KEY index_of_user_id(user_id),
  KEY index_of_product_id(product_id)
) COMMENT = 'Скидки';

DROP TABLE IF EXISTS storehouses;
CREATE TABLE storehouses (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) COMMENT 'Название',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT = 'Склады';

DROP TABLE IF EXISTS storehouses_products;
CREATE TABLE storehouses_products (
  id SERIAL PRIMARY KEY,
  storehouse_id INT UNSIGNED,
  product_id INT UNSIGNED,
  value INT UNSIGNED COMMENT 'Запас товарной позиции на складе',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT = 'Запасы на складе';