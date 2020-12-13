-- Практическое задание по теме “Хранимые процедуры и функции, триггеры"

-- 1. Создайте хранимую функцию hello(), которая будет возвращать приветствие, в зависимости от текущего времени суток. 
-- С 6:00 до 12:00 функция должна возвращать фразу "Доброе утро", 
-- с 12:00 до 18:00 функция должна возвращать фразу "Добрый день", 
-- с 18:00 до 00:00 — "Добрый вечер", с 00:00 до 6:00 — "Доброй ночи".

DROP FUNCTION IF EXISTS hello;

DELIMITER //
CREATE FUNCTION hello () 
RETURNS TEXT NO SQL
BEGIN
  CASE 
	WHEN DATE_FORMAT(NOW(), "%H:%i:%s") BETWEEN DATE_FORMAT(NOW(), "06:00:00") AND DATE_FORMAT(NOW(), "12:00:00") THEN
  	  RETURN "Доброе утро!";
    WHEN DATE_FORMAT(NOW(), "%H:%i:%s") BETWEEN DATE_FORMAT(NOW(), "12:00:01") AND DATE_FORMAT(NOW(), "18:00:00") THEN
  	  RETURN "Добрый день!";
    WHEN DATE_FORMAT(NOW(), "%H:%i:%s") BETWEEN DATE_FORMAT(NOW(), "18:00:01") AND DATE_FORMAT(NOW(), "00:00:00") THEN
  	  RETURN "Добрый вечер!";
	ELSE
  	  RETURN "Доброй ночи!";
  END CASE;
END//

SELECT hello();


-- 2. В таблице products есть два текстовых поля: name с названием товара и description с его описанием. 
-- Допустимо присутствие обоих полей или одно из них. 
-- Ситуация, когда оба поля принимают неопределенное значение NULL неприемлема. 
-- Используя триггеры, добейтесь того, чтобы одно из этих полей или оба поля были заполнены. 
-- При попытке присвоить полям NULL-значение необходимо отменить операцию.


-- Первый вариант
DELIMITER //
DROP TRIGGER check_name_description_insert;
CREATE TRIGGER check_name_description_insert BEFORE INSERT ON products
FOR EACH ROW 
BEGIN
  DECLARE name VARCHAR(255);
  DECLARE description TEXT;
  IF ISNULL(name) OR ISNULL(description) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'INSERT canceled. Check fields "name" or "description". They should not be empty.';
  END IF;
END//

-- Второй вариант
DELIMITER //
DROP TRIGGER check_name_description_insert;
CREATE TRIGGER check_name_description_insert BEFORE INSERT ON products
FOR EACH ROW 
BEGIN
  IF NEW.name IS NULL OR NEW.description IS NULL THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'INSERT canceled. Check fields "name" or "description". They should not be empty.';
  END IF;
END//

-- Проверочные вставки данных
INSERT INTO products VALUES 
	(NULL, 'Intel Core i5-7400', 'Процессор для настольных персональных компьютеров, основанных на платформе Intel.', 12000, 1, NOW(), NOW()),
	(NULL, 'Intel Core i5-7400', NULL, 12000, 1, NOW(), NOW()),
	(NULL, NULL, 'Процессор для настольных персональных компьютеров, основанных на платформе Intel.', 12000, 1, NOW(), NOW());

INSERT INTO products VALUES (NULL, 'Intel Core i5-7400', NULL, 12000, 1, NOW(), NOW());

INSERT INTO products VALUES	(NULL, NULL, 'Процессор для настольных персональных компьютеров, основанных на платформе Intel.', 12000, 1, NOW(), NOW());

INSERT INTO products VALUES (NULL, NULL, NULL, 12000, 1, NOW(), NOW());


-- 3. (по желанию) Напишите хранимую функцию для вычисления произвольного числа Фибоначчи. 
-- Числами Фибоначчи называется последовательность в которой число равно сумме двух предыдущих чисел. 
-- Вызов функции FIBONACCI(10) должен возвращать число 55.


DROP FUNCTION IF EXISTS FIBONACCI;

DELIMITER //
CREATE FUNCTION FIBONACCI (n INT)
RETURNS INT DETERMINISTIC
BEGIN
 DECLARE a INT DEFAULT 0;
 DECLARE b INT DEFAULT 1;
 DECLARE c INT;
 DECLARE i INT DEFAULT 1;
  WHILE i < n DO
    SET c = a + b;
    SET a = b;
    SET b = c;
	SET i = i + 1;
  END WHILE;
RETURN c;
END//

SELECT FIBONACCI(10);

