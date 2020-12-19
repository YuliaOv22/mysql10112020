-- Практическое задание по теме “Оптимизация запросов”

-- 1. Создайте таблицу logs типа Archive. 
-- Пусть при каждом создании записи в таблицах users, catalogs и products в таблицу logs помещается время и дата создания записи, 
-- название таблицы, идентификатор первичного ключа и содержимое поля name.

-- Создаем таблицу logs типа Archive
DROP TABLE IF EXISTS logs;
CREATE TABLE logs (
  created_at DATETIME COMMENT 'Время и дата создания записи',
  table_name VARCHAR(255) COMMENT 'Название таблицы',
  table_id INT UNSIGNED COMMENT 'Идентификатор первичного ключа таблицы',
  name_text VARCHAR(255) COMMENT 'Содержимое поля name таблицы'
) COMMENT = 'Архив записей таблиц users, catalogs и products' ENGINE=Archive;

-- Создаем триггер для вставки записей из таблицы users
DROP TRIGGER IF EXISTS users_insert;
DELIMITER //
CREATE TRIGGER users_insert AFTER INSERT ON users
FOR EACH ROW
BEGIN
	INSERT INTO logs SELECT created_at, 'users', id, name FROM users WHERE id = NEW.id;
END//

-- Создаем триггер для вставки записей из таблицы catalogs
DROP TRIGGER IF EXISTS catalogs_insert;
DELIMITER //
CREATE TRIGGER catalogs_insert AFTER INSERT ON catalogs
FOR EACH ROW
BEGIN
	INSERT INTO logs SELECT NOW(), 'catalogs', id, name FROM catalogs WHERE id = NEW.id;
END//

-- Создаем триггер для вставки записей из таблицы products
DROP TRIGGER IF EXISTS products_insert;
DELIMITER //
CREATE TRIGGER products_insert AFTER INSERT ON products
FOR EACH ROW
BEGIN
	INSERT INTO logs SELECT created_at, 'products', id, name FROM products WHERE id = NEW.id;
END//

-- Проверочные вставки
INSERT INTO users (name, birthday_at) VALUES
  ('Геннадий', '1990-10-05');
 
INSERT INTO catalogs VALUES
  (NULL, 'Процессоры');
 
INSERT INTO products
  (name, description, price, catalog_id)
VALUES
  ('Intel Core i3-8100', 'Процессор для настольных персональных компьютеров, основанных на платформе Intel.', 7890.00, 1);

SELECT * FROM logs;


-- 2. (по желанию) Создайте SQL-запрос, который помещает в таблицу users миллион записей.

-- Создаем процедуру для вставки записей
DROP PROCEDURE IF EXISTS users_insert;
DELIMITER //
CREATE PROCEDURE users_insert (IN value INT)
BEGIN
	DECLARE i INT DEFAULT 1;
    WHILE i <= value DO
	  INSERT INTO users (id) VALUES (NULL);
      SET i = i + 1;
    END WHILE;
END//

-- Вызываем процедуру на вставку миллиона записей
CALL users_insert(1000000);

SELECT * FROM users ORDER BY id DESC;

