-- Практическое задание по теме “Администрирование MySQL” (эта тема изучается по вашему желанию)

-- 1. Создайте двух пользователей которые имеют доступ к базе данных shop. 
-- Первому пользователю shop_read должны быть доступны только запросы на чтение данных, 
-- второму пользователю shop — любые операции в пределах базы данных shop.

DROP USER shop_read@'localhost';
CREATE USER shop_read@'localhost' IDENTIFIED WITH sha256_password BY 'pass1';
GRANT SELECT ON shop.* TO shop_read@'localhost';
SHOW GRANTS FOR shop_read@'localhost';

DROP USER shop@'localhost';
CREATE USER shop@'localhost' IDENTIFIED WITH sha256_password BY 'pass2';
GRANT ALL ON shop.* TO shop@'localhost';
SHOW GRANTS FOR shop@'localhost';


-- 2. (по желанию) Пусть имеется таблица accounts содержащая три столбца id, name, password, 
-- содержащие первичный ключ, имя пользователя и его пароль. 
-- Создайте представление username таблицы accounts, предоставляющий доступ к столбца id и name. 
-- Создайте пользователя user_read, который бы не имел доступа к таблице accounts, однако, мог бы извлекать записи из представления username.

DROP TABLE IF EXISTS accounts;
CREATE TABLE accounts (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255),
  password VARCHAR(255)
);

INSERT INTO accounts (name, password) VALUES
  ('Геннадий', 'Qt3X08VetW'),
  ('Наталья', 'hvg0b057Br'),
  ('Александр', 'a4YGUJjRLk'),
  ('Сергей', 'YYug1IeyWl'),
  ('Иван', 'oKoo7KXvTE'),
  ('Мария', 'w5r4yvfo9f');

CREATE VIEW username AS SELECT id, name FROM accounts;
DROP VIEW IF EXISTS username;

DROP USER user_read@'localhost';
CREATE USER user_read@'localhost' IDENTIFIED WITH sha256_password BY 'pass2';
GRANT USAGE, SELECT ON shop.username TO user_read@'localhost';
SHOW GRANTS FOR user_read@'localhost';

SELECT Host, User FROM mysql.user;
