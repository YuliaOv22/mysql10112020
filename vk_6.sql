-- Практическое задание по теме “Операторы, фильтрация, сортировка и ограничение. Агрегация данных”
-- Работаем с БД vk и тестовыми данными, которые вы сгенерировали ранее:

-- 1. Создать и заполнить таблицы лайков и постов.

-- Таблица лайков
DROP TABLE IF EXISTS likes;
CREATE TABLE likes (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  user_id INT UNSIGNED NOT NULL,
  target_id INT UNSIGNED NOT NULL,
  target_type_id INT UNSIGNED NOT NULL,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
) COMMENT='Таблица лайков';

-- Таблица типов лайков
DROP TABLE IF EXISTS target_types;
CREATE TABLE target_types (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(255) NOT NULL UNIQUE,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
) COMMENT='Таблица типов лайков';

INSERT INTO target_types (name) VALUES 
  ('Messages'),
  ('Users'),
  ('Media'),
  ('Posts');

-- Заполняем лайки
INSERT INTO likes 
  SELECT 
    id, 
    FLOOR(1 + (RAND() * 100)), 
    FLOOR(1 + (RAND() * 100)),
    FLOOR(1 + (RAND() * 4)),
    CURRENT_TIMESTAMP 
  FROM messages;

-- Проверим
SELECT * FROM likes LIMIT 10;

-- Создадим таблицу постов
DROP TABLE IF EXISTS posts;
CREATE TABLE posts (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  user_id INT UNSIGNED NOT NULL,
  community_id INT UNSIGNED,
  head VARCHAR(255),
  body TEXT NOT NULL,
  media_id INT UNSIGNED,
  is_public BOOLEAN DEFAULT TRUE,
  is_archived BOOLEAN DEFAULT FALSE,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT='Посты пользователя';


-- 2. Создать все необходимые внешние ключи и диаграмму отношений.

-- Создаем внешние ключи для таблицы профилей
ALTER TABLE profiles
  ADD CONSTRAINT profiles_user_id_fk 
    FOREIGN KEY (user_id) REFERENCES users(id)
      ON DELETE CASCADE,
  ADD CONSTRAINT profiles_gender_id_fk 
    FOREIGN KEY (gender_id) REFERENCES user_genders(id)
      ON DELETE SET NULL,
  ADD CONSTRAINT profiles_photo_id_fk
    FOREIGN KEY (photo_id) REFERENCES media(id)
      ON DELETE SET NULL,
  ADD CONSTRAINT profiles_status_id_fk 
    FOREIGN KEY (status_id) REFERENCES user_statuses(id)
      ON DELETE SET NULL,
  ADD CONSTRAINT profiles_city_id_fk 
    FOREIGN KEY (city_id) REFERENCES cities(id)
      ON DELETE SET NULL,
  ADD CONSTRAINT profiles_country_id_fk 
    FOREIGN KEY (country_id) REFERENCES countries(id)
      ON DELETE SET NULL; 

ALTER TABLE profiles MODIFY COLUMN user_id BIGINT UNSIGNED NOT NULL;
ALTER TABLE profiles MODIFY COLUMN gender_id BIGINT UNSIGNED;
ALTER TABLE profiles MODIFY COLUMN photo_id BIGINT UNSIGNED;
ALTER TABLE profiles MODIFY COLUMN status_id INT UNSIGNED;
ALTER TABLE profiles MODIFY COLUMN city_id BIGINT UNSIGNED;
ALTER TABLE profiles MODIFY COLUMN country_id BIGINT UNSIGNED;


-- Создаем внешние ключи для таблицы дружбы
ALTER TABLE friendships
  ADD CONSTRAINT friendships_user_id_fk 
    FOREIGN KEY (user_id) REFERENCES users(id)
      ON DELETE CASCADE,
  ADD CONSTRAINT friendships_friend_id_fk 
    FOREIGN KEY (friend_id) REFERENCES users(id)
      ON DELETE CASCADE,
  ADD CONSTRAINT friendships_status_id_fk 
    FOREIGN KEY (status_id) REFERENCES friendship_statuses(id)
      ON DELETE SET NULL;

ALTER TABLE friendships MODIFY COLUMN user_id BIGINT UNSIGNED NOT NULL;
ALTER TABLE friendships MODIFY COLUMN friend_id BIGINT UNSIGNED NOT NULL;
ALTER TABLE friendships MODIFY COLUMN status_id BIGINT UNSIGNED;


-- Создаем внешние ключи для таблицы сообщений
ALTER TABLE messages 
  ADD CONSTRAINT messages_from_user_id_fk 
    FOREIGN KEY (from_user_id) REFERENCES users(id)
      ON DELETE NO ACTION,
  ADD CONSTRAINT messages_to_user_id_fk 
    FOREIGN KEY (to_user_id) REFERENCES users(id)
      ON DELETE NO ACTION;

ALTER TABLE messages MODIFY COLUMN from_user_id BIGINT UNSIGNED NOT NULL;
ALTER TABLE messages MODIFY COLUMN to_user_id BIGINT UNSIGNED NOT NULL;
 

-- Создаем внешние ключи для таблицы постов
ALTER TABLE posts 
  ADD CONSTRAINT posts_user_id_fk 
    FOREIGN KEY (user_id) REFERENCES users(id)
      ON DELETE NO ACTION,
  ADD CONSTRAINT posts_community_id_fk 
    FOREIGN KEY (community_id) REFERENCES communities(id)
      ON DELETE NO ACTION,
  ADD CONSTRAINT posts_media_id_fk 
    FOREIGN KEY (media_id) REFERENCES media(id)
      ON DELETE SET NULL;

DESC posts; 
ALTER TABLE posts MODIFY COLUMN user_id BIGINT UNSIGNED NOT NULL;
ALTER TABLE posts MODIFY COLUMN community_id BIGINT UNSIGNED;
ALTER TABLE posts MODIFY COLUMN media_id BIGINT UNSIGNED;


-- Создаем внешние ключи для таблицы связи сообществ и пользователей
ALTER TABLE communities_users 
  ADD CONSTRAINT communities_users_user_id_fk 
    FOREIGN KEY (user_id) REFERENCES users(id)
      ON DELETE CASCADE,
  ADD CONSTRAINT communities_users_community_id_fk 
    FOREIGN KEY (community_id) REFERENCES communities(id)
      ON DELETE CASCADE;

ALTER TABLE communities_users MODIFY COLUMN user_id BIGINT UNSIGNED NOT NULL;
ALTER TABLE communities_users MODIFY COLUMN community_id BIGINT UNSIGNED NOT NULL;


-- Создаем внешние ключи для таблицы медиа
ALTER TABLE media 
  ADD CONSTRAINT media_user_id_fk 
    FOREIGN KEY (user_id) REFERENCES users(id)
      ON DELETE CASCADE,
  ADD CONSTRAINT media_media_type_id_fk 
    FOREIGN KEY (media_type_id) REFERENCES media_types(id)
      ON DELETE CASCADE;

DESC media; 
ALTER TABLE media MODIFY COLUMN user_id BIGINT UNSIGNED NOT NULL;
ALTER TABLE media MODIFY COLUMN media_type_id BIGINT UNSIGNED NOT NULL;


-- 3. Определить кто больше поставил лайков (всего) - мужчины или женщины?

SELECT
  (SELECT name FROM user_genders WHERE id=(SELECT gender_id FROM profiles WHERE user_id = likes.user_id)) AS gender,
  COUNT(*) AS total
FROM likes
GROUP BY gender
ORDER BY total DESC 
LIMIT 1; 


-- 4. Подсчитать количество лайков которые получили 10 самых молодых пользователей. 

SELECT SUM(get_likes) AS sum_likes FROM (
  SELECT 
    (SELECT CONCAT(first_name, ' ', last_name) FROM users WHERE users.id = likes.target_id) AS name,
    (SELECT TIMESTAMPDIFF(YEAR, birthday, NOW()) FROM profiles WHERE profiles.user_id = likes.target_id) AS age,
    COUNT(*) AS get_likes
  FROM likes WHERE target_type_id = 2
  GROUP BY target_id 
  ORDER BY age 
  LIMIT 10) 
AS tbl;


-- 5. Найти 10 пользователей, которые проявляют наименьшую активность в использовании социальной сети
-- (критерии активности необходимо определить самостоятельно).

-- Обозначим 3 критерия наименьшей активности для пользователя:
-- 1. Количество написанных сообщений = 0
-- 2. Количество поставленных лайков = 0
-- 3. Количество написанных постов = 0

SELECT name, quant_mess, quant_likes, quant_posts FROM (
SELECT 
    CONCAT(first_name, ' ', last_name) AS name,
    (SELECT COUNT(from_user_id) AS quant FROM messages WHERE messages.from_user_id = users.id) AS quant_mess,
    (SELECT COUNT(user_id) AS quant FROM likes WHERE likes.user_id = users.id) AS quant_likes,
    (SELECT COUNT(user_id) AS quant FROM posts WHERE posts.user_id = users.id) AS quant_posts
FROM users) tbl WHERE quant_mess = 0 AND quant_likes = 0 AND quant_posts = 0 ORDER BY name LIMIT 10;
