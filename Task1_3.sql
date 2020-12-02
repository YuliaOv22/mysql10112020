-- Тема "Сложные запросы"
-- 1. Составьте список пользователей users, которые осуществили хотя бы один заказ orders в интернет магазине.

SELECT 
  u.name, 
  COUNT(*) AS quant_orders
FROM 
  users u
JOIN 
  orders o
ON 
  u.id = o.user_id 
GROUP BY 
  u.name 
ORDER BY 
  name;


-- 2. Выведите список товаров products и разделов catalogs, который соответствует товару.

SELECT 
  p.name AS product_name, 
  c.name AS catalog_name 
FROM 
  products p 
JOIN 
  catalogs c
ON 
  p.catalog_id = c.id;


-- 3. (по желанию) Пусть имеется таблица рейсов flights (id, from, to) и таблица городов cities (label, name). 
-- Поля from, to и label содержат английские названия городов, поле name — русское. 
-- Выведите список рейсов flights с русскими названиями городов.

CREATE TABLE flights (
  id SERIAL PRIMARY KEY,
  from_city VARCHAR(255) COMMENT 'Откуда вылет',
  to_city VARCHAR(255) COMMENT 'Куда вылет'
) COMMENT = 'Авиарейсы';

INSERT INTO flights (from_city, to_city) VALUES
  ('moscow', 'omsk'),
  ('novgorod', 'kazan'),
  ('irkutsk', 'moscow'),
  ('omsk', 'irkutsk'),
  ('moscow', 'kazan');

CREATE TABLE cities (
  label VARCHAR(255) COMMENT 'Английский названия городов',
  name VARCHAR(255) COMMENT 'Русские названия городов'
) COMMENT = 'Города';

INSERT INTO cities (label, name) VALUES
  ('moscow', 'Москва'),
  ('irkutsk', 'Иркутск'),
  ('novgorod', 'Новгород'),
  ('kazan', 'Казань'),
  ('omsk', 'Омск');

SELECT 
  id, 
  c.name AS from_city, 
  c2.name AS to_city
FROM 
  flights f 
JOIN 
  cities c 
ON 
  f.from_city = c.label
JOIN 
  cities c2
ON 
  f.to_city = c2.label
ORDER BY 
  id;
 