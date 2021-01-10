-- Составить общее текстовое описание БД и решаемых ею задач;

/* Смоделированная база данных на основе сервиса по обмену фото- и видеоматериалами Instagram 
 * предназначена для хранения информации о пользователях и размещаемом ими медиаконтенте.
 * Задачи, которые позволяет решать база данных:
 * 1. Хранение информации о пользователях.
 * 2. Обеспечение консистентности хранимых данных.
 * 3. Обеспечение непрерывного доступа к данным.
 * 4. Добавление, удаление, изменение данных.
 * 5. Обобщение статистических данных для составления отчетов.
 * 
 * Представленная база данных содержит 20 таблиц.
 * 
 * 1. Таблица пользователей. Содержит основную публичную информацию о пользователе, 
 * включая имя и логин пользователя, описание и фотографию профиля, вебсайт, признак приватности профиля, 
 * а также признак того, могут ли другие пользователи видеть статус данного пользователя в сети.
 * 
 * 2. Таблица полов пользователей. Содержит перечень полов.
 * 
 * 3. Таблица персональной информации пользователей. Содержит основную непубличную информацию о пользователе, 
 * включая электронную почту, телефон, пол и дату рождения. 
 * 
 * 4. Таблица взаимосвязи пользователей-подписчиков. Содержит связки подписчиков и подписок.
 * 
 * 5. Таблица типов медиафайлов. Содержит перечень типов медиафайлов.
 * 
 * 6. Таблица медиафайлов. Содержит основные характеристики сущности "Медиафайл",
 * включая id пользователя, путь к медиафайлу, его размер и тип, альтернативный текст и дополнительную метаинформацию в формате JSON.
 * 
 * 7. Таблица публикаций. Содержит основные характеристики сущности "Публикация",
 * включая id пользователя, описание публикации, отметка геолокации,
 * признак добавления публикации в "Архив", а также признак отключения комментариев к публикации.
 * 
 * 8. Таблица взаимосвязи публикаций и медиафайлов. Содержит связки публикаций и медиафайлов внутри публикаций.
 * 
 * 9. Таблица взаимосвязи отмеченных пользователей и медиафайлов. Содержит информацию об отмеченных пользователях на медиафайлах,
 * включая id пользователя, которого отметили, и id медиафайла, на котором отметили пользователя.
 * 
 * 10. Таблица публикаций, которые добавлены в категорию "Избранное". Содержит связки публикаций и пользователей, которые добавили
 * данные публикации к себе в категорию "Избранное".
 * 
 * 11. Таблица комментариев. Содержит основные характеристики сущности "Комментарий",
 * включая текст комментария, id пользователя, который его написал, id публикации, под которой оставили комментарий, 
 * id родительского комментария, если таковой имеется.
 * 
 * 12. Таблица сообщений. Содержит основные характеристики сущности "Сообщение",
 * включая id пользователя, который отправил сообщение, id пользователя, которому отправили сообщение, текст сообщения,
 * а также признак прочитанности сообщения.
 * 
 * 13. Таблица историй. Содержит основные характеристики сущности "История",
 * включая id пользователя, id загружаемого медиафайла, отметка геолокации и признак добавления публикации в категорию "Актуальное".
 * 
 * 14. Таблица взаимосвязи отмеченных пользователей и историй. Содержит информацию об отмеченных пользователях в историях,
 * включая id пользователя, которого отметили, и id истории.
 * 
 * 15. Таблица близких друзей. Содержит информацию о пользователях, которых добавили в категорию "Близкие друзья".
 * 
 * 16. Таблица типов лайков. Содержит перечень типов сущностей, которым можно поставить лайк (Публикация, Сообщение, Комментарий).
 *  
 * 17. Таблица лайков. Содержит основные характеристики сущности "Лайк",
 * включая id пользователя, который поставил лайк, id сущности, которой поставили лайк, и тип этой сущности.
 * 
 * 18. Таблица привязанных устройств. Содержит перечень устройств, которые привязаны к профилям пользователей. 
 * 
 * 19. Таблица входа пользователей в профиль с привязанных устройств. Содержит информацию о входах,
 * включая id пользователя, id устройства и отметку геолокации.
 * 
 * 20. Таблица архива входа пользователей в профиль с привязанных устройств. Содержит архивную информацию 
 * обо всех входах пользователя в профиль с привязанных устройств.
*/


-- скрипты создания структуры БД (с первичными ключами, индексами, внешними ключами);

DROP DATABASE IF EXISTS instagram_db;
CREATE DATABASE instagram_db;
USE instagram_db;


-- 1. Таблица пользователей
DROP TABLE IF EXISTS users;
CREATE TABLE users (
	id SERIAL PRIMARY KEY COMMENT 'Идентификационный номер',
	name VARCHAR(255) NOT NULL COMMENT 'Имя пользователя',
	login VARCHAR(100) NOT NULL UNIQUE COMMENT 'Логин пользователя',
	web_site VARCHAR(255) COMMENT 'Вебсайт пользователя',
	description VARCHAR(255) COMMENT 'Описание профиля',
	avatar VARCHAR(255) NOT NULL COMMENT 'Путь к медиафайлу (Фотография профиля)',
	is_open BOOLEAN DEFAULT TRUE COMMENT 'Флаг открытости аккаунта (Да/Нет)',
	is_show_online BOOLEAN DEFAULT TRUE COMMENT 'Флаг показа онлайн статуса другим пользователям (Да/Нет)',
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT 'Время создания строки',  
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Время обновления строки'
) COMMENT = 'Таблица пользователей' ENGINE=InnoDB;


-- 2. Таблица полов пользователей
DROP TABLE IF EXISTS users_genders;
CREATE TABLE users_genders (
	id SERIAL PRIMARY KEY COMMENT 'Идентификационный номер',
	name VARCHAR(50) COMMENT 'Название пола',
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT 'Время создания строки'
) COMMENT = 'Таблица полов пользователей' ENGINE=InnoDB;

 		
-- 3. Таблица персональной информации пользователей
DROP TABLE IF EXISTS users_personal_info;
CREATE TABLE users_personal_info (
	id SERIAL PRIMARY KEY COMMENT 'Идентификационный номер',
	user_id BIGINT UNSIGNED NOT NULL COMMENT 'Ссылка на пользователя',
	email VARCHAR(100) NOT NULL UNIQUE COMMENT 'Электронная почта пользователя',
	phone VARCHAR(100) UNIQUE COMMENT 'Телефон пользователя',
	gender_id BIGINT UNSIGNED NOT NULL COMMENT 'Пол пользователя',
	birthday DATE COMMENT 'Дата рождения пользователя',
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT 'Время создания строки',  
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Время обновления строки'
) COMMENT = 'Таблица персональной информации пользователей' ENGINE=InnoDB;
 										  

-- 4. Таблица взаимосвязи пользователей-подписчиков
DROP TABLE IF EXISTS followers;
CREATE TABLE followers (
	user_id BIGINT UNSIGNED NOT NULL COMMENT 'Ссылка на пользователя',
	followed_user_id BIGINT UNSIGNED NOT NULL COMMENT 'Ссылка на пользователя, на которого подписались',
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT 'Время создания строки',
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Время обновления строки',
	PRIMARY KEY (user_id, followed_user_id) COMMENT 'Составной первичный ключ'
) COMMENT 'Таблица взаимосвязи пользователей-подписчиков' ENGINE=InnoDB;


-- 5. Таблица типов медиафайлов
DROP TABLE IF EXISTS media_types;
CREATE TABLE media_types (
	id SERIAL PRIMARY KEY COMMENT 'Идентификационный номер',
	name VARCHAR(150) NOT NULL UNIQUE COMMENT 'Название типа медиафайла', 
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT 'Время создания строки'
) COMMENT = 'Таблица типов медиафайлов' ENGINE=InnoDB;


-- 6. Таблица медиафайлов
DROP TABLE IF EXISTS media;
CREATE TABLE media (
	id SERIAL PRIMARY KEY COMMENT 'Идентификационный номер',
	user_id BIGINT UNSIGNED NOT NULL COMMENT 'Ссылка на пользователя',
	file_name VARCHAR(255) NOT NULL COMMENT 'Путь к медиафайлу',
	file_size INT NOT NULL COMMENT 'Размер медиафайла',
	media_types_id BIGINT UNSIGNED NOT NULL COMMENT 'Тип медиафайла',
	metadata JSON COMMENT 'Дополнительная информация о медиафайле',
	alt_text VARCHAR(150) COMMENT 'Альтернативный текст медиафайла',
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT 'Время создания строки'
) COMMENT = 'Таблица медиафайлов' ENGINE=InnoDB;
 	

-- 7. Таблица публикаций
DROP TABLE IF EXISTS publications;
CREATE TABLE publications (
	id SERIAL PRIMARY KEY COMMENT 'Идентификационный номер',
	user_id BIGINT UNSIGNED NOT NULL COMMENT 'Ссылка на пользователя',
	body TEXT NOT NULL COMMENT 'Текст публикации',
	is_archived BOOLEAN DEFAULT FALSE COMMENT 'Флаг добавления публикации в "Архив" (Да/Нет)',
	is_comments_on BOOLEAN DEFAULT TRUE COMMENT 'Флаг отключения у публикации комментариев (Да/Нет)',
	geo VARCHAR(255) COMMENT 'Отметка геолокации',
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT 'Время создания строки',  
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Время обновления строки'
) COMMENT = 'Таблица публикаций' ENGINE=InnoDB;


-- 8. Таблица взаимосвязи публикаций и медиафайлов
DROP TABLE IF EXISTS publications_media;
CREATE TABLE publications_media (
	id SERIAL PRIMARY KEY COMMENT 'Идентификационный номер',
	media_id BIGINT UNSIGNED COMMENT 'Ссылка на медиафайл',
	publication_id BIGINT UNSIGNED COMMENT 'Ссылка на публикацию',
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT 'Время создания строки'
) COMMENT = 'Таблица взаимосвязи публикаций и медиафайлов' ENGINE=InnoDB;


-- 9. Таблица взаимосвязи отмеченных пользователей и медиафайлов
DROP TABLE IF EXISTS tag_users_media;
CREATE TABLE tag_users_media (
	tag_user_id BIGINT UNSIGNED NOT NULL COMMENT 'Ссылка на пользователя, которого отметили',
	media_id BIGINT UNSIGNED NOT NULL COMMENT 'Ссылка на медиафайл, на котором отметили пользователя',
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT 'Время создания строки',
	PRIMARY KEY (tag_user_id, media_id) COMMENT 'Составной первичный ключ'
) COMMENT 'Таблица взаимосвязи отмеченных пользователей и медиафайлов' ENGINE=InnoDB;


-- 10. Таблица публикаций, которые добавлены в категорию "Избранное"
DROP TABLE IF EXISTS publications_saved;
CREATE TABLE publications_saved (
	publication_id BIGINT UNSIGNED NOT NULL COMMENT 'Ссылка на публикацию',
	user_id BIGINT UNSIGNED NOT NULL COMMENT 'Ссылка на пользователя, который добавил публикацию в катеригорию "Избранное"',
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT 'Время создания строки',  
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Время обновления строки'
) COMMENT 'Таблица публикаций, которые добавлены в категорию "Избранное"' ENGINE=InnoDB;


-- 11. Таблица комментариев
DROP TABLE IF EXISTS comments;
CREATE TABLE comments (
	id SERIAL PRIMARY KEY COMMENT 'Идентификационный номер',
	body TEXT NOT NULL COMMENT 'Текст комментария',
	from_user_id BIGINT UNSIGNED NOT NULL COMMENT 'Ссылка на пользователя, который сделал комментарий',
	publication_id BIGINT UNSIGNED NOT NULL COMMENT 'Ссылка на публикацию, под которой был сделан комментарий',
	comment_id BIGINT UNSIGNED COMMENT 'Ссылка на родительский комментарий',
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT 'Время создания строки',  
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Время обновления строки'
) COMMENT = 'Таблица комментариев' ENGINE=InnoDB;


-- 12. Таблица сообщений
DROP TABLE IF EXISTS messages;
CREATE TABLE messages (
	id SERIAL PRIMARY KEY COMMENT 'Идентификационный номер',
	from_user_id BIGINT UNSIGNED NOT NULL COMMENT 'Ссылка на пользователя, который прислал сообщение',
	to_user_id BIGINT UNSIGNED NOT NULL COMMENT 'Ссылка на пользователя, который получил сообщение',
	body TEXT NOT NULL COMMENT 'Текст сообщения',
	is_read BOOLEAN COMMENT 'Флаг прочитанности сообщения',
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT 'Время создания строки',  
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Время обновления строки'
) COMMENT = 'Таблица сообщений' ENGINE=InnoDB;


-- 13. Таблица историй
DROP TABLE IF EXISTS stories;
CREATE TABLE stories (
	id SERIAL PRIMARY KEY COMMENT 'Идентификационный номер',
	user_id BIGINT UNSIGNED NOT NULL COMMENT 'Ссылка на пользователя',
	media_id BIGINT UNSIGNED NOT NULL COMMENT 'Ссылка на медиафайл',
	is_actual BOOLEAN COMMENT 'Флаг того, находится ли история в "Актуальном" (Видны всегда в профиле)',
	geo VARCHAR(255) COMMENT 'Отметка геолокации',
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT 'Время создания строки'
) COMMENT = 'Таблица историй' ENGINE=InnoDB;


-- 14. Таблица взаимосвязи отмеченных пользователей и историй
DROP TABLE IF EXISTS tag_users_stories;
CREATE TABLE tag_users_stories (
	tag_user_id BIGINT UNSIGNED NOT NULL COMMENT 'Ссылка на пользователя, которого отметили',
	story_id BIGINT UNSIGNED NOT NULL COMMENT 'Ссылка на историю, на которой отметили пользователя',
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT 'Время создания строки',
	PRIMARY KEY (tag_user_id, story_id) COMMENT 'Составной первичный ключ'
) COMMENT 'Таблица взаимосвязи отмеченных пользователей и историй' ENGINE=InnoDB;


-- 15. Таблица близких друзей
DROP TABLE IF EXISTS close_friends;
CREATE TABLE close_friends (
	user_id BIGINT UNSIGNED NOT NULL COMMENT 'Ссылка на пользователя',
	friend_id BIGINT UNSIGNED NOT NULL COMMENT 'Ссылка на пользователя, которого добавляют в категорию "Близкие друзья"',
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT 'Время создания строки',
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Время обновления строки',
	PRIMARY KEY (user_id, friend_id) COMMENT 'Составной первичный ключ'
) COMMENT = 'Таблица близких друзей' ENGINE=InnoDB;


-- 16. Таблица типов лайков
DROP TABLE IF EXISTS target_types;
CREATE TABLE target_types (
	id SERIAL PRIMARY KEY COMMENT 'Идентификационный номер',
	name VARCHAR(150) NOT NULL UNIQUE COMMENT 'Название типа сущности для лайка (Публикации, Сообщения, Комментарии)',
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT 'Время создания строки'
) COMMENT = 'Таблица типов лайков' ENGINE=InnoDB;


-- 17. Таблица лайков
DROP TABLE IF EXISTS likes;
CREATE TABLE likes (
	id SERIAL PRIMARY KEY COMMENT 'Идентификационный номер',
	user_id BIGINT UNSIGNED NOT NULL COMMENT 'Ссылка на пользователя',
	target_id BIGINT UNSIGNED NOT NULL COMMENT 'Ссылка на сущность, которой поставили лайк',
	target_type_id BIGINT UNSIGNED NOT NULL COMMENT 'Ссылка на тип сущности',
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT 'Время создания строки'
) COMMENT = 'Таблица лайков' ENGINE=InnoDB;


-- 18. Таблица привязанных устройств
DROP TABLE IF EXISTS devices;
CREATE TABLE devices (
	id SERIAL PRIMARY KEY COMMENT 'Идентификационный номер',
	name VARCHAR(255) NOT NULL UNIQUE COMMENT 'Название устройства (Модель)',
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT 'Время создания строки'
) COMMENT = 'Таблица привязанных устройств' ENGINE=InnoDB;


-- 19. Таблица входа пользователей в профиль с привязанных устройств
DROP TABLE IF EXISTS authorization_devices;
CREATE TABLE authorization_devices (
	id SERIAL PRIMARY KEY COMMENT 'Идентификационный номер',
	user_id BIGINT UNSIGNED NOT NULL COMMENT 'Ссылка на пользователя',
	device_id BIGINT UNSIGNED NOT NULL COMMENT 'Ссылка на привязанное устройство',
	geo VARCHAR(255) COMMENT 'Отметка геолокации',
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT 'Время создания строки',
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Время обновления строки'
) COMMENT 'Таблица входа пользователей в профиль с привязанных устройств' ENGINE=InnoDB;


-- 20. Таблица архива входа пользователей в профиль с привязанных устройств
DROP TABLE IF EXISTS authorization_devices_logs;
CREATE TABLE authorization_devices_logs (
	user_id BIGINT UNSIGNED NOT NULL COMMENT 'Ссылка на пользователя',
	device_id BIGINT UNSIGNED NOT NULL COMMENT 'Ссылка на привязанное устройство',
	geo VARCHAR(255) COMMENT 'Отметка геолокации',
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT 'Время создания строки'
) COMMENT 'Таблица архива входа пользователей в профиль с привязанных устройств' ENGINE=Archive;


-- Внешние ключи и индексы

-- 3. Таблица персональной информации пользователей
-- Внешние ключи для полей user_id и gender_id
ALTER TABLE users_personal_info
	ADD CONSTRAINT users_personal_info_user_id_fk
 		FOREIGN KEY (user_id) REFERENCES users (id)
 			ON DELETE CASCADE,
 	ADD CONSTRAINT users_personal_info_gender_id_fk
 		FOREIGN KEY (gender_id) REFERENCES users_genders (id);
-- ALTER TABLE users_personal_info DROP FOREIGN KEY users_personal_info_user_id_fk;
-- ALTER TABLE users_personal_info DROP FOREIGN KEY users_personal_info_gender_id_fk;
 	
-- Индекс для поля email
CREATE UNIQUE INDEX users_email_idx ON users_personal_info (email);
-- Индекс для поля birthday
CREATE UNIQUE INDEX users_birthday_idx ON users_personal_info (birthday);


-- 4. Таблица взаимосвязи пользователей-подписчиков
-- Внешние ключи для полей user_id и followed_user_id
ALTER TABLE followers
	ADD CONSTRAINT followers_user_id_fk
 		FOREIGN KEY (user_id) REFERENCES users (id)
 			ON DELETE CASCADE,
 	ADD CONSTRAINT followers_followed_user_id_fk
 		FOREIGN KEY (followed_user_id) REFERENCES users (id)
 			ON DELETE CASCADE;
-- ALTER TABLE followers DROP FOREIGN KEY followers_user_id_fk;
-- ALTER TABLE followers DROP FOREIGN KEY followers_followed_user_id_fk;

 		
-- 6. Таблица медиафайлов
-- Внешние ключи для полей user_id и media_types_id
ALTER TABLE media
	ADD CONSTRAINT media_user_id_fk
 		FOREIGN KEY (user_id) REFERENCES users (id)
 			ON DELETE CASCADE,
 	ADD CONSTRAINT media_media_types_id_fk
 		FOREIGN KEY (media_types_id) REFERENCES media_types (id);
-- ALTER TABLE media DROP FOREIGN KEY media_user_id_fk; 
-- ALTER TABLE media DROP FOREIGN KEY media_media_types_id_fk; 
 	
 		
-- 7. Таблица публикаций
-- Внешний ключ для поля user_id
ALTER TABLE publications
	ADD CONSTRAINT publications_user_id_fk
 		FOREIGN KEY (user_id) REFERENCES users (id)
 			ON DELETE CASCADE;
-- ALTER TABLE publications DROP FOREIGN KEY publications_user_id_fk;
 	
-- Индекс для поля geo
CREATE INDEX users_geo_idx ON publications (geo);


-- 8. Таблица взаимосвязи публикации и количества вложенных медиафайлов
-- Внешний ключ для поля media_id
ALTER TABLE publications_media
	ADD CONSTRAINT publications_media_id_fk
 		FOREIGN KEY (media_id) REFERENCES media (id);  
-- ALTER TABLE publications_media DROP FOREIGN KEY publications_media_id_fk;
 	

-- 9. Таблица взаимосвязи отмеченных пользователей и медиафайлов
-- Внешние ключи для полей tag_user_id и media_id
ALTER TABLE tag_users_media
	ADD CONSTRAINT tag_users_tag_user_id_fk
 		FOREIGN KEY (tag_user_id) REFERENCES users (id),
 	ADD CONSTRAINT tag_users_media_media_id_fk
 		FOREIGN KEY (media_id) REFERENCES media (id)
 			ON DELETE CASCADE;
-- ALTER TABLE tag_users_media DROP FOREIGN KEY tag_users_tag_user_id_fk; 
-- ALTER TABLE tag_users_media DROP FOREIGN KEY tag_users_media_media_id_fk; 


-- 10. Таблица публикаций, которые добавлены в категорию "Избранное"
-- Внешние ключи для полей user_id и publication_id
ALTER TABLE publications_saved
	ADD CONSTRAINT publications_saved_user_id_fk
 		FOREIGN KEY (user_id) REFERENCES users (id),
 	ADD CONSTRAINT publications_saved_publication_id_fk
 		FOREIGN KEY (publication_id) REFERENCES publications (id)
 			ON DELETE CASCADE;
-- ALTER TABLE publications_saved DROP FOREIGN KEY publications_saved_user_id_fk; 
-- ALTER TABLE publications_saved DROP FOREIGN KEY publications_saved_publication_id_fk; 


-- 11. Таблица комментариев
-- Внешние ключи для полей from_user_id, publication_id и comment_id
ALTER TABLE comments
	ADD CONSTRAINT comments_from_user_id_fk
 		FOREIGN KEY (from_user_id) REFERENCES users (id)
 			ON DELETE CASCADE,
 	ADD CONSTRAINT comments_publication_id_fk
 		FOREIGN KEY (publication_id) REFERENCES publications (id)
 			ON DELETE CASCADE,
 	ADD CONSTRAINT comments_comment_id_fk
 		FOREIGN KEY (comment_id) REFERENCES comments (id)
 			ON DELETE CASCADE; 
-- ALTER TABLE comments DROP FOREIGN KEY comments_from_user_id_fk; 
-- ALTER TABLE comments DROP FOREIGN KEY comments_publication_id_fk; 
-- ALTER TABLE comments DROP FOREIGN KEY comments_comment_id_fk; 


-- 12. Таблица сообщений
-- Внешние ключи для полей from_user_id и to_user_id
ALTER TABLE messages
	ADD CONSTRAINT messages_from_user_id_fk
 		FOREIGN KEY (from_user_id) REFERENCES users (id),
 	ADD CONSTRAINT messages_to_user_id_fk
 		FOREIGN KEY (to_user_id) REFERENCES users (id);
-- ALTER TABLE messages DROP FOREIGN KEY messages_from_user_id_fk; 
-- ALTER TABLE messages DROP FOREIGN KEY messages_to_user_id_fk;


-- 13. Таблица историй
-- Внешние ключи для полей user_id и media_id
ALTER TABLE stories
	ADD CONSTRAINT stories_user_id_fk
 		FOREIGN KEY (user_id) REFERENCES users (id)
 			ON DELETE CASCADE,
 	ADD CONSTRAINT stories_media_id_fk
 		FOREIGN KEY (media_id) REFERENCES media (id);     
-- ALTER TABLE stories DROP FOREIGN KEY stories_user_id_fk; 
-- ALTER TABLE stories DROP FOREIGN KEY stories_media_id_fk; 

-- Индекс для поля geo
CREATE INDEX stories_geo_idx ON stories (geo);


-- 14. Таблица взаимосвязи отмеченных пользователей и историй
-- Внешние ключи для полей tag_user_id и story_id
ALTER TABLE tag_users_stories
	ADD CONSTRAINT tag_users_stories_tag_user_id_fk
 		FOREIGN KEY (tag_user_id) REFERENCES users (id),
 	ADD CONSTRAINT tag_users_stories_story_id_fk
 		FOREIGN KEY (story_id) REFERENCES stories (id)
 			ON DELETE CASCADE;
-- ALTER TABLE tag_users_stories DROP FOREIGN KEY tag_users_stories_tag_user_id_fk; 
-- ALTER TABLE tag_users_stories DROP FOREIGN KEY tag_users_stories_story_id_fk;


-- 15. Таблица близких друзей
-- Внешние ключи для полей user_id и friend_id
ALTER TABLE close_friends
	ADD CONSTRAINT close_friends_user_id_fk
 		FOREIGN KEY (user_id) REFERENCES users (id)
 			ON DELETE CASCADE,
 	ADD CONSTRAINT close_friends_friend_id_fk
 		FOREIGN KEY (friend_id) REFERENCES users (id)
 			ON DELETE CASCADE;
-- ALTER TABLE close_friends DROP FOREIGN KEY close_friends_user_id_fk; 
-- ALTER TABLE close_friends DROP FOREIGN KEY close_friends_friend_id_fk;


-- 17. Таблица лайков
-- Внешние ключи для полей user_id и target_type_id
ALTER TABLE likes
	ADD CONSTRAINT likes_user_id_fk
 		FOREIGN KEY (user_id) REFERENCES users (id)
 			ON DELETE CASCADE,
 	ADD CONSTRAINT likes_target_type_id_fk
 		FOREIGN KEY (target_type_id) REFERENCES target_types (id); 
-- ALTER TABLE likes DROP FOREIGN KEY likes_user_id_fk; 
-- ALTER TABLE likes DROP FOREIGN KEY likes_target_type_id_fk; 


-- 19. Таблица входа пользователей в профиль с привязанных устройств
-- Внешние ключи для полей user_id и device_id
ALTER TABLE authorization_devices
	ADD CONSTRAINT authorization_devices_user_id_fk
 		FOREIGN KEY (user_id) REFERENCES users (id)
 			ON DELETE CASCADE,
 	ADD CONSTRAINT authorization_devices_device_id_fk
 		FOREIGN KEY (device_id) REFERENCES devices (id);
-- ALTER TABLE authorization_devices DROP FOREIGN KEY authorization_devices_user_id_fk; 
-- ALTER TABLE authorization_devices DROP FOREIGN KEY authorization_devices_device_id_fk;

-- Индекс для поля geo
CREATE INDEX authorization_devices_geo_idx ON authorization_devices (geo);


-- создать ERDiagram для БД;
/* Диаграмма подгружена отдельным файлом "ERDiagram_instagram_db.png"
 */


-- скрипты наполнения БД данными / корректировка автоматизированных данных;

-- 1. Таблица пользователей
INSERT INTO `users` VALUES 
('1','Betsy Conroy','wlittel','','','','1','0','2019-11-09 05:04:52','2020-08-30 20:46:32'),
('2','Cathryn Reilly','hzboncak','','','','1','1','2015-05-23 13:40:27','2020-10-02 09:47:26'),
('3','Jaiden Kuphal','thompson.providenci','http://www.mcglynnpfeffer.net/','Perferendis est rem impedit consequatur. Perspiciatis illum voluptatem delectus debitis quos laborum earum.','','1','1','2018-12-12 05:41:50','2020-06-06 15:56:06'),
('4','Seth Bogan','aharris','http://gusikowskikozey.info/','','','0','0','2012-03-23 04:57:52','2020-06-12 20:59:43'),
('5','Zakary Waters','hwindler','','','','0','0','2014-09-29 01:46:49','2020-10-27 11:03:43'),
('6','Karson Aufderhar','hoeger.laney','','','','0','0','2018-05-31 15:43:45','2020-04-30 18:05:14'),
('7','Jeffery Runolfsson Sr.','riley.effertz','http://price.com/','','','0','0','2012-02-26 06:42:57','2020-07-01 21:15:28'),
('8','Norris Sanford','fdietrich','http://www.lang.com/','','','1','1','2020-05-08 06:59:30','2021-01-02 02:28:07'),
('9','Mr. Tyrique Gutkowski Sr.','herdman','http://osinski.com/','','','1','0','2020-12-20 19:02:41','2020-11-25 22:16:10'),
('10','Mr. Glen Sipes I','reichel.jesse','http://www.oconnerbaumbach.com/','','','0','1','2014-01-25 14:25:05','2020-03-05 04:49:57'),
('11','Prof. Otilia Labadie','lfunk','','','','1','0','2011-12-11 00:00:31','2020-06-02 11:20:21'),
('12','Miss Lauretta Gutkowski','johnathan.sipes','http://ratkegulgowski.com/','','','0','0','2016-03-17 00:22:09','2020-12-26 23:59:32'),
('13','Ms. Kathryn D\'Amore PhD','nstark','http://www.reichel.com/','Eius nihil totam aut dolore eligendi. Molestiae aut dolores quidem rerum nihil. Autem et laborum magnam unde nisi consectetur. Commodi sunt dolore qui et nulla.','','1','0','2019-03-14 04:18:31','2020-08-12 20:15:56'),
('14','Keven Veum','hahn.angel','http://schroederspinka.com/','','','0','0','2013-11-02 22:01:35','2020-07-03 16:42:16'),
('15','Jimmie Jaskolski DVM','gborer','http://hintzbrown.com/','','','0','0','2016-07-03 09:37:14','2020-02-25 07:51:43'),
('16','Brionna Hauck','zachery28','http://nitzsche.info/','Nostrum animi et non dolorem. Vel placeat maxime iste.','','0','0','2011-05-11 03:48:57','2020-08-20 12:44:27'),
('17','Garrison Predovic','brigitte.johns','','Ad eius corrupti vel aut. Sit autem voluptatem et amet ipsum voluptatem. Et corporis dicta voluptates esse. Quia voluptas et fuga quo. Vitae adipisci libero ut quia veniam itaque.','','0','0','2016-10-17 00:53:18','2020-06-13 23:51:28'),
('18','Dave Feeney','wunsch.roy','http://www.mrazmurphy.com/','Expedita exercitationem ratione repellat sint consequatur atque qui. At quia natus quia non. Aut dolores et corrupti numquam et neque. Animi debitis corporis mollitia veniam tenetur. Mollitia sed soluta non facere odit mollitia.','','0','0','2015-05-02 05:18:28','2020-09-22 07:18:31'),
('19','Richard Hilll','kbeer','http://hauck.com/','','','0','0','2011-08-06 09:02:04','2020-10-24 05:48:23'),
('20','Mafalda Monahan PhD','teagan.kovacek','','','','0','1','2015-12-10 17:02:53','2020-09-11 05:00:07'); 

SELECT * FROM users;
-- TRUNCATE users;

-- Корректировка поля avatar
UPDATE users SET avatar = CONCAT('https://instagram.com/upload/avatars/', FLOOR(1 + RAND() * 1000000), '.jpeg');
-- Корректировка поля updated_at
UPDATE users SET updated_at = NOW();

 		
-- 2. Таблица полов пользователей
INSERT INTO users_genders (name) VALUES 
  ('Male'),
  ('Female'),
  ('Other'),
  ('I prefer not to specify');

SELECT * FROM users_genders;
-- TRUNCATE users_genders;


-- 3. Таблица персональной информации пользователей
INSERT INTO `users_personal_info` VALUES 
('1','20','nabshire@example.org','','2','1971-06-20','2020-02-23 13:15:05','2020-12-24 22:48:10'),
('2','7','terrence42@example.net','1-508-529-8642','1','2000-05-10','2018-12-25 01:11:17','2020-12-10 19:06:20'),
('3','15','runolfsdottir.marlen@example.com','305.293.1814','2','1978-04-13','2018-02-17 21:22:28','2021-01-07 03:47:51'),
('4','5','von.renee@example.com','1-142-600-6352x957','2','1974-01-30','2011-05-24 21:52:28','2020-12-20 01:58:55'),
('5','2','koch.arturo@example.org','+99(1)5846576480','2','1972-07-13','2020-02-21 11:22:33','2020-12-10 08:12:23'),
('6','12','wyman.jovan@example.org','633.420.0234','2','2001-06-26','2020-04-07 15:30:11','2020-12-10 10:39:14'),
('7','4','christine.nitzsche@example.org','1-114-567-4445','1','1981-12-01','2013-11-23 14:18:29','2020-12-27 06:54:29'),
('8','13','vondricka@example.org','1-631-972-8960x10931','1','2011-01-30','2015-04-24 10:33:25','2020-12-23 05:26:35'),
('9','1','marvin.gino@example.org','(330)069-7092x6816','1','1990-03-13','2012-07-01 14:51:54','2021-01-08 05:21:31'),
('10','17','frami.pamela@example.org','292.283.0858x6186','1','2009-05-01','2013-11-19 21:14:25','2020-12-30 03:29:03'),
('11','14','arianna82@example.org','720.032.2431x7625','2','1978-03-19','2018-06-11 17:53:39','2020-12-31 03:21:19'),
('12','9','casandra80@example.net','384-671-3213x6766','2','1987-01-11','2019-07-29 21:21:22','2020-12-10 23:52:46'),
('13','3','stanton.garnett@example.org','1-131-338-4271','2','1999-06-17','2020-07-13 05:24:30','2020-12-19 07:41:25'),
('14','10','gardner82@example.com','(204)391-0208','1','2017-05-20','2014-08-01 23:49:02','2020-12-26 05:58:54'),
('15','18','gjacobi@example.org','1-212-686-0995','1','2010-11-22','2015-11-03 22:48:56','2020-12-25 11:11:58'),
('16','8','hrodriguez@example.org','1-764-792-1789','2','2012-06-26','2017-01-15 17:52:16','2021-01-07 00:57:12'),
('17','16','dnolan@example.com','(365)680-5755x509','1','2011-02-12','2020-09-24 22:34:08','2021-01-04 13:37:20'),
('18','6','lambert03@example.org','120-426-5335x36607','2','2005-02-09','2016-03-15 05:16:32','2020-12-14 05:05:53'),
('19','11','ahowe@example.com','541-110-5070x47256','2','1989-03-04','2014-12-31 21:24:37','2020-12-28 17:27:57'),
('20','19','cstanton@example.org','(944)566-2944','1','1994-06-27','2020-05-01 02:20:21','2020-12-13 16:43:11'); 

SELECT * FROM users_personal_info;
-- TRUNCATE users_personal_info;

-- Корректировка поля updated_at
UPDATE users_personal_info SET updated_at = NOW();
-- Корректировка поля phone
UPDATE users_personal_info SET phone = CONCAT('+7 (9', FLOOR(1 + RAND() * 9), 
					   								   FLOOR(1 + RAND() * 9), ') ',
					 							   	   FLOOR(1 + RAND() * 9),
											   		   FLOOR(1 + RAND() * 9),
													   FLOOR(1 + RAND() * 9),
													   FLOOR(1 + RAND() * 9),
													   FLOOR(1 + RAND() * 9),
											 		   FLOOR(1 + RAND() * 9),
					 								   FLOOR(1 + RAND() * 9));
											  
			 								  
-- 4. Таблица взаимосвязи пользователей-подписчиков
INSERT INTO `followers` VALUES 
('2','19','2020-09-03 20:41:26','2020-12-15 23:26:51'),
('5','12','2020-07-17 10:11:25','2020-12-17 12:51:35'),
('6','9','2020-11-27 16:32:04','2020-12-12 05:00:10'),
('7','10','2020-08-16 14:37:51','2020-12-24 22:56:58'),
('8','14','2020-05-17 09:19:03','2020-12-13 06:35:58'),
('13','1','2020-07-26 11:23:46','2020-12-23 02:31:04'),
('15','11','2020-12-28 12:14:45','2020-12-25 14:49:50'),
('17','3','2020-11-28 18:11:21','2021-01-04 06:53:03'),
('18','1','2020-03-10 23:24:29','2021-01-04 09:14:02'),
('1','20','2020-10-10 23:44:37','2020-12-26 22:45:12'),
('1','4','2020-10-11 02:26:31','2021-01-06 14:52:16'),
('4','16','2020-02-19 15:10:06','2020-12-28 18:50:27'),
('10','11','2020-06-19 05:55:41','2020-12-13 02:12:44'),
('3','7','2020-12-06 06:22:51','2020-12-12 14:29:54'),
('5','19','2020-11-10 08:15:04','2020-12-20 00:44:46'); 

SELECT * FROM followers;
-- TRUNCATE followers;

-- Корректировка поля updated_at
UPDATE followers SET updated_at = NOW();


-- 5. Таблица типов медиафайлов
INSERT INTO media_types (name) VALUES 
  ('image'),
  ('video');
 
SELECT * FROM media_types;
-- TRUNCATE media_types;


-- 6. Таблица медиафайлов
INSERT INTO `media` VALUES 
('1','3','e591e590-d89c-31fc-8e42-8a59db7dc413','50251','1',NULL,'','2020-03-29 04:21:18'),
('2','3','367ea73a-f9aa-3ccb-810c-24c10ff5a949','8976','2',NULL,'','2020-11-13 11:32:45'),
('3','17','f5b52ec9-a46b-38a5-a7a8-55ae21d5cec1','8622117','2',NULL,'','2020-11-03 03:54:39'),
('4','2','15c37782-1b45-3f5a-81a1-1119f12d5ba5','320','1',NULL,'','2020-12-08 14:21:56'),
('5','7','e1991ae8-2e00-3989-b7e9-a0f67f7c995f','2','2',NULL,'Ut fuga et quod in ut.','2020-12-30 12:14:42'),
('6','12','03ed3fec-fa18-37f7-abc7-f9705ef626a6','0','1',NULL,'Sit voluptates voluptas fugiat eos consectetur.','2020-10-03 04:14:26'),
('7','2','132ca629-e7e4-38ee-9fbb-093c71f87a9e','31900','1',NULL,'','2020-10-29 19:22:44'),
('8','9','a6b1aaa5-666c-3a7d-911c-26355996ba81','881726623','1',NULL,'','2020-02-01 21:38:19'),
('9','17','dd360913-7ba7-3a3c-97c0-a10ac80643e5','7851094','1',NULL,'','2020-07-16 21:03:40'),
('10','18','2714d56b-ee5e-37be-ab66-b1b32f8b8008','343','2',NULL,'Et non consequatur officiis quia modi.','2020-08-05 11:37:34'),
('11','9','26c58088-c36a-37bc-bb59-6b7e81d107ce','0','2',NULL,'','2020-07-24 00:35:17'),
('12','11','8144b9b9-496b-3dcd-9526-775e69a4a58f','832','1',NULL,'A sit temporibus est ea reprehenderit.','2020-06-02 22:00:44'),
('13','7','dc301d57-8a34-3ba6-8985-bc6d06307c77','5','2',NULL,'Tempore facere exercitationem atque et harum natus.','2020-09-18 21:34:02'),
('14','8','854f1881-a468-3bce-849c-90b51d5cf464','9011811','2',NULL,'','2020-04-12 16:51:22'),
('15','5','12b21674-abab-30ed-968d-854cadcee9f0','16','2',NULL,'','2020-10-20 23:25:04'),
('16','7','36e451f8-90a8-38ab-981f-a2ab62a8fb09','98','2',NULL,'Occaecati dolorum consequuntur minus ut atque totam libero saepe.','2020-06-17 12:52:17'),
('17','6','f1b818a4-3ca5-3514-96f7-342c4fb4a262','2261932','2',NULL,'Et aliquam expedita ut illum molestiae.','2020-09-08 11:41:57'),
('18','4','0b55b0da-87b1-354a-a966-a49b95a550f3','0','1',NULL,'Saepe totam qui eius id atque doloribus.','2020-04-24 09:17:47'),
('19','1','860abde4-9114-3702-b9ee-238164e6d101','432148739','2',NULL,'Assumenda sequi ab provident aliquid.','2020-09-20 10:45:50'),
('20','2','d851d4b6-c1de-3443-9685-337fcde4ba5c','3440','2',NULL,'','2020-11-26 19:33:10'),
('21','1','77b3a40a-103e-3bd6-bc21-be60cd8d2a0c','4767942','2',NULL,'','2020-09-11 21:12:03'),
('22','11','80f69594-2e55-3fd5-8d5e-f14706c95169','16641','2',NULL,'','2020-07-07 22:04:19'),
('23','7','e3fc4239-6382-3842-8805-d8b5d66b7ce9','6080137','1',NULL,'Deleniti voluptas quis modi voluptas distinctio consequatur sunt dolores.','2020-10-11 19:15:52'),
('24','11','f5b8e369-9371-3275-a453-75be906db514','4677','2',NULL,'Vel quasi laboriosam ipsa iusto dolores facilis eum repellat.','2020-02-04 23:19:54'),
('25','20','83268260-3fa8-32bf-9624-825896056422','6228','2',NULL,'','2020-07-24 09:05:58'),
('26','2','6617e127-ac5a-3b99-ad15-051ed9bfe9db','194918','1',NULL,'','2020-09-16 13:15:44'),
('27','1','99c86307-1e76-3b40-8605-10bbb111e124','15014391','1',NULL,'','2020-04-10 01:18:11'),
('28','18','e9956605-6db2-3904-8b2f-307f6ed8abc4','869963167','2',NULL,'Nisi amet ut autem vero illum.','2020-04-25 03:26:01'),
('29','19','be449e56-b6c5-3cec-ab4c-a312a4aa4312','92','1',NULL,'','2020-04-06 14:30:44'),
('30','18','29e237e9-0b3f-307c-8870-4daa69a51ad7','58','2',NULL,'Esse voluptatem aliquid at.','2020-01-18 23:37:27'),
('31','9','eba40e7d-861e-3b3d-9e4b-e20923c085f8','8','1',NULL,'Delectus ab omnis nemo odit.','2020-02-07 12:37:23'),
('32','10','f03b79ee-f999-3adb-9538-b05edd3f03b7','0','1',NULL,'','2020-08-09 06:35:04'),
('33','4','1d6cc7f0-42ff-3dd3-a864-19cc934a00ff','330898','2',NULL,'','2020-02-17 21:38:41'),
('34','1','323bfd79-e051-3057-b0fa-364c0ac0ade2','378','1',NULL,'','2020-07-26 06:45:19'),
('35','4','020ba8c0-556e-3b60-a6d5-35422f04f1f0','28690','1',NULL,'','2020-04-11 16:11:22'),
('36','12','b56cd91f-c3bd-31aa-be60-f2d53cadfa58','65426093','1',NULL,'Asperiores consequuntur optio repudiandae quod aut ut.','2020-03-10 07:56:20'),
('37','10','02d7f9fa-8afe-3f2a-b0c5-1c212bba73fc','58','1',NULL,'Perspiciatis et sunt voluptates quasi.','2020-03-10 05:12:29'),
('38','7','9f12bbdf-632b-321f-8624-b726e7a98691','9414651','1',NULL,'Occaecati ut magnam dolore et.','2020-05-15 22:36:00'),
('39','10','b0efffaa-275e-3cfe-af81-e45a45384b68','7562934','1',NULL,'Occaecati quo nisi voluptatum consequatur dolore.','2020-12-03 02:29:00'),
('40','6','c6752748-ef63-3a17-a10c-cffa408b238f','670259085','1',NULL,'','2020-08-29 05:30:31'),
('41','5','e143a141-1319-3f47-842e-f9c25549cbaf','99','1',NULL,'Quo deserunt tempora quae inventore qui consectetur.','2020-01-25 08:26:00'),
('42','19','13e958bb-35db-3dd6-b7b1-cd232611c61d','3319','2',NULL,'Autem quisquam nostrum quam pariatur quia quisquam quos dolores.','2020-03-10 03:46:44'),
('43','13','e06c63c0-2e2b-3386-b3dc-e8c02aad6b33','47423','1',NULL,'Nihil voluptate nihil dolorum repudiandae minus temporibus.','2020-02-06 21:43:04'),
('44','11','393e40cd-16be-34ea-8cd6-b00c5896324d','8574','2',NULL,'','2020-12-09 23:15:33'),
('45','4','16f20c24-d810-396f-aa65-7786af007652','56065940','1',NULL,'','2020-03-16 13:52:24'),
('46','1','8a640002-d010-3ccf-b4fb-20445f79ce7d','382','1',NULL,'','2020-03-16 02:56:32'),
('47','4','4a6d84c8-c25a-330f-b902-f78b758f360e','8','1',NULL,'Vero harum maiores ut ab vel.','2020-04-27 00:24:43'),
('48','5','86d7cd71-266b-355e-b323-d60237b405f3','8931654','2',NULL,'','2020-12-11 02:10:01'),
('49','8','20bc462a-6a84-3a56-8d38-936a655f2fd9','281','2',NULL,'Reprehenderit et omnis quaerat quas.','2020-12-05 14:12:34'),
('50','1','7777795a-8029-328f-a405-0bdbdf4b30d5','1','2',NULL,'Nemo temporibus quas non mollitia.','2020-09-27 01:35:41');

SELECT * FROM media;
-- TRUNCATE media;

-- Временная таблица форматов медиафайлов
DROP TABLE IF EXISTS extensions;
CREATE TEMPORARY TABLE extensions (name VARCHAR(10));
-- Заполнение данными
INSERT INTO extensions VALUES ('jpeg'), ('png'), ('mp4'), ('mov');
SELECT * FROM extensions;
-- Корректировка ссылок на медиафайл
UPDATE media SET file_name = CONCAT(
  'https://instagram.com/upload/avatars/',
  (SELECT login FROM users WHERE id = user_id ORDER BY RAND() LIMIT 1),
  '/',
  file_name,  
  '.',
  (SELECT name FROM extensions ORDER BY RAND() LIMIT 1)
);
-- Уточнение форматов медиафайлов
UPDATE media SET media_types_id = 1 WHERE SUBSTRING_INDEX(file_name, '.', -1) IN ('jpeg', 'png');
UPDATE media SET media_types_id = 2 WHERE SUBSTRING_INDEX(file_name, '.', -1) IN ('mp4', 'mov');
-- Обновление размера медиафайлов
UPDATE media SET file_size = FLOOR(10000 + (RAND() * 1000000)) WHERE media_types_id = 1;
UPDATE media SET file_size = FLOOR(10000 + (RAND() * 1000000000)) WHERE media_types_id = 2;
-- Заполнение метаданных
UPDATE media SET metadata = CONCAT('{"Владелец":"', 
  (SELECT name FROM users WHERE id = user_id),
  '"}');  
 	

-- 7. Таблица публикаций
INSERT INTO `publications` VALUES 
('1','4','Laborum ut ducimus voluptate quia libero vitae modi. Repellendus illum non perspiciatis eaque. Non et illum repudiandae officia voluptas. Molestiae rerum sint rerum ipsum perspiciatis voluptate.','1','0',NULL,'2012-12-25 15:39:16','2020-12-10 03:41:23'),
('2','15','Beatae minus velit dolorem nobis et. Soluta qui voluptas explicabo. Sequi illo distinctio quia reiciendis voluptas optio vero facilis. Cum sint reiciendis sed mollitia nesciunt minus.','0','0',NULL,'2012-12-07 12:20:45','2021-01-09 08:55:13'),
('3','12','','1','0',NULL,'2016-05-26 23:23:13','2020-12-22 21:28:47'),
('4','10','','0','0',NULL,'2017-02-19 04:57:28','2021-01-02 01:36:37'),
('5','15','Voluptatem earum et corporis dolores non eius magnam eius. Molestiae ipsum aspernatur labore autem ut. Minus ratione voluptatibus soluta ut veritatis fugiat sint.','1','0',NULL,'2017-06-02 18:33:55','2020-12-27 14:19:56'),
('6','7','','0','1',NULL,'2016-08-02 21:03:03','2020-12-27 04:18:55'),
('7','14','Provident aut mollitia praesentium et. Distinctio sit eum aut omnis recusandae. Totam eligendi et neque id. Facere quaerat molestias cumque maxime quis.','0','0',NULL,'2015-04-29 13:21:57','2020-12-26 11:36:23'),
('8','20','In quibusdam sit amet molestiae. Autem tempore et vero illum. Voluptate maiores eveniet et doloribus.','0','0',NULL,'2013-05-31 10:46:19','2020-12-21 10:00:18'),
('9','2','Quo praesentium dignissimos praesentium qui. Tenetur laboriosam tempore et nemo. Numquam soluta sed sed blanditiis dolore nisi. Sapiente provident qui dolore ut. Numquam molestiae sit necessitatibus dolore officia perferendis.','0','0',NULL,'2011-05-09 10:36:38','2020-12-16 22:51:03'),
('10','18','','0','0',NULL,'2014-12-24 10:37:54','2020-12-11 02:57:06'),
('11','12','Repellat vitae aut voluptas harum et. In eveniet illo repellendus quibusdam. Fugiat dolor aperiam facilis quidem. A voluptatum repellat exercitationem. Velit ea sit aut dolor.','0','0',NULL,'2017-02-08 16:00:18','2021-01-07 08:32:04'),
('12','20','','0','0',NULL,'2019-05-05 17:26:47','2020-12-09 12:49:21'),
('13','6','Repellendus sint totam iste ut. Molestiae molestias dolor ex. Perspiciatis aut sed officia perferendis velit iusto autem. Sed est ipsum rem ab molestiae.','0','0',NULL,'2020-05-02 20:22:42','2020-12-17 18:26:48'),
('14','10','','1','0',NULL,'2019-06-19 15:21:32','2020-12-27 10:13:19'),
('15','6','','0','0',NULL,'2019-06-10 09:06:04','2021-01-05 04:58:51'),
('16','11','','1','0',NULL,'2012-08-09 08:33:35','2020-12-23 22:28:30'),
('17','6','Iusto tempora cupiditate assumenda ut magni. Et minus dolorem atque. Dolor iure perferendis deserunt voluptas. Quam explicabo voluptatem nulla ut cum fuga.','1','0',NULL,'2018-07-12 01:37:28','2020-12-19 09:48:09'),
('18','7','','1','1',NULL,'2012-12-21 06:39:17','2020-12-26 19:57:28'),
('19','15','','0','0',NULL,'2016-08-20 13:25:03','2020-12-19 19:59:26'),
('20','12','Nemo numquam labore ut voluptas. Atque ad voluptas quas enim error quam at. Id officiis adipisci praesentium iste quia maiores labore.','0','0',NULL,'2013-08-05 21:32:45','2020-12-23 17:00:07'); 

SELECT * FROM publications;
-- TRUNCATE publications;

-- Заполнение данными поля geo
UPDATE publications SET geo = CONCAT(1 + RAND() * 100, ' ', 1 + RAND() * 200);
-- Корректировка поля updated_at
UPDATE publications SET updated_at = NOW();


-- 8. Таблица взаимосвязи публикации и количества вложенных медиафайлов
INSERT INTO `publications_media` VALUES 
(NULL,'3','12','2015-06-07 19:12:31'),
(NULL,'4','2','2020-07-18 09:42:03'),
(NULL,'5','13','2015-11-06 18:58:13'),
(NULL,'6','12','2015-09-25 10:06:10'),
(NULL,'9','19','2015-01-24 05:21:21'),
(NULL,'10','1','2012-06-06 17:51:40'),
(NULL,'12','6','2020-07-31 18:12:44'),
(NULL,'12','12','2016-07-22 10:33:15'),
(NULL,'15','18','2020-04-18 12:43:21'),
(NULL,'16','16','2015-01-07 19:14:58'),
(NULL,'17','5','2012-02-18 01:55:48'),
(NULL,'18','3','2014-11-09 18:09:06'),
(NULL,'18','11','2013-06-12 19:29:01'),
(NULL,'21','8','2018-05-09 19:44:43'),
(NULL,'22','5','2015-02-10 05:28:01'),
(NULL,'24','8','2014-09-23 06:43:03'),
(NULL,'25','5','2017-06-20 11:45:24'),
(NULL,'27','4','2018-10-18 13:30:24'),
(NULL,'27','20','2017-05-05 18:56:45'),
(NULL,'29','7','2019-03-04 22:24:15'),
(NULL,'39','13','2014-11-16 21:13:09'),
(NULL,'40','17','2011-01-10 14:42:05'),
(NULL,'42','9','2015-02-27 09:51:57'),
(NULL,'44','10','2016-10-12 04:32:14'),
(NULL,'44','13','2013-09-28 15:00:52'); 

SELECT * FROM publications_media;
-- TRUNCATE publications_media;


-- 9. Таблица взаимосвязи отмеченных пользователей и медиафайлов
INSERT INTO `tag_users_media` VALUES 
('5','28','2020-01-15 23:41:20'),
('7','40','2020-11-21 20:21:19'),
('9','38','2020-07-31 22:24:42'),
('9','48','2020-04-11 19:07:12'),
('12','32','2020-08-24 17:05:12'),
('13','3','2020-01-28 19:59:28'),
('13','9','2020-12-31 08:27:18'),
('14','7','2020-09-25 05:22:55'),
('14','49','2020-06-22 01:11:15'),
('17','7','2020-05-09 23:11:50'); 

SELECT * FROM tag_users_media;
-- TRUNCATE tag_users_media;
 

-- 10. Таблица публикаций, которые добавлены в категорию "Избранное"
INSERT INTO `publications_saved` VALUES 
('16','1','2020-11-09 17:13:22','2020-12-10 19:01:37'),
('8','10','2020-12-26 14:49:19','2020-12-25 10:20:31'),
('2','10','2020-06-19 20:36:10','2020-12-28 00:43:24'),
('4','18','2020-04-21 13:22:11','2020-12-14 04:32:08'),
('13','15','2020-10-22 14:08:35','2020-12-24 14:08:13'),
('1','7','2020-07-09 01:58:55','2020-12-12 02:34:57'),
('9','4','2020-06-19 16:09:32','2020-12-28 03:23:53'),
('18','14','2020-07-10 23:51:13','2020-12-27 00:06:58'),
('11','13','2020-01-14 10:05:44','2020-12-14 20:33:56'),
('20','1','2020-07-23 04:54:32','2020-12-19 05:58:42'); 

SELECT * FROM publications_saved;
-- TRUNCATE publications_saved;

-- Корректировка поля updated_at
UPDATE publications_saved SET updated_at = NOW();


-- 11. Таблица комментариев
INSERT INTO `comments` VALUES 
('1','Quis ut omnis saepe ex temporibus ipsa sint. Autem cum asperiores eos odit provident. Fuga voluptates occaecati omnis est quia aut voluptatem. Rem omnis suscipit commodi quas ducimus.','18','1',NULL,'2020-08-23 19:43:44','2020-12-24 22:18:16'),
('2','Ipsum voluptatibus eos qui architecto. Dolorum quia non beatae laudantium mollitia. Autem nam quo voluptate alias enim atque. Ad alias id fugiat dolorem.','8','10',NULL,'2020-05-11 08:16:38','2020-12-20 17:34:05'),
('3','Sunt dolorem saepe dolorem ut ea error. Sunt ut dolorum doloribus fugiat minima. Hic et harum culpa velit. Eveniet cupiditate autem maiores.','13','18',NULL,'2020-09-08 10:04:41','2020-12-25 17:11:09'),
('4','Qui et modi rerum accusamus. Officia et porro cum vero enim illum vel natus. Et tempore tenetur non similique fugiat ad nihil.','13','3',NULL,'2020-09-21 22:08:08','2020-12-24 05:01:30'),
('5','Excepturi cumque repudiandae temporibus quia sed natus. Eos aut illum iste corrupti. Sapiente voluptatem ipsam voluptas ut reprehenderit quis dolor. Voluptatem necessitatibus dolor provident eum.','7','8',NULL,'2020-12-05 18:38:14','2020-12-29 12:59:30'),
('6','Quae voluptates quaerat qui nemo odio consequatur repellendus. Nam non inventore officia vitae modi. Quam et eius rerum nostrum ut eius modi.','5','18','5','2020-06-26 19:01:35','2021-01-01 19:39:09'),
('7','Asperiores ut magnam nihil est. Libero id sit possimus necessitatibus harum quis. Consequatur quis est aut voluptas. Harum dolorem rerum illum excepturi.','7','11',NULL,'2020-03-03 18:03:22','2020-12-27 02:28:04'),
('8','Porro laborum eius maiores. Vitae voluptas vel laborum aut dolor ea rerum enim. Quis consectetur nisi voluptates ipsam. Nam modi recusandae rerum deleniti.','1','16',NULL,'2020-03-15 11:40:26','2020-12-19 20:05:00'),
('9','Minima qui expedita id suscipit ea ea assumenda. Similique eius et sequi beatae. Quia qui veritatis ad sit voluptas rerum.','20','1',NULL,'2020-09-16 12:44:16','2020-12-08 17:53:23'),
('10','Excepturi possimus praesentium sed ipsa libero saepe consectetur voluptas. Dolor beatae ratione corporis pariatur ex excepturi iusto ea. Itaque dolores est libero sint voluptatem ut ut. Explicabo explicabo vero qui qui.','15','13','3','2020-05-04 10:24:28','2020-12-18 18:46:41'),
('11','Atque quia eligendi non culpa reprehenderit. Rerum facilis tenetur enim labore enim excepturi dolorem aut. Facilis saepe dolore molestias eos officia rerum quasi. Eos quia voluptatum ullam consequuntur eum odio.','14','5',NULL,'2020-03-29 13:43:21','2020-12-29 05:47:07'),
('12','Labore delectus sapiente et qui. Quod qui impedit quod veritatis sed molestiae fugiat. Dolore quae ducimus est consequatur corporis recusandae magnam. In dolore aut est blanditiis quasi.','8','8',NULL,'2020-07-31 03:42:53','2020-12-16 14:39:02'),
('13','Iure quis architecto in fuga praesentium. Qui et optio dolore quibusdam. Iste aut in ut autem voluptas. Sit placeat omnis ut labore qui libero consequatur.','15','1','1','2020-01-12 19:55:53','2020-12-27 11:18:12'),
('14','Sunt veritatis omnis mollitia aliquid. Sed consequatur ducimus ipsam culpa non aliquid est. Dolorem eaque consequatur voluptatem ducimus provident. Molestiae corporis nihil numquam assumenda nulla quia laboriosam.','5','7','2','2020-06-19 02:11:40','2020-12-13 14:50:41'),
('15','Nesciunt eveniet eum culpa et omnis ullam voluptas. Aut omnis dolorem facilis aliquam voluptate impedit. Quam voluptatem quaerat dolores exercitationem neque est voluptatem. Sunt hic in rerum voluptas deleniti.','4','4','10','2020-04-08 14:56:25','2020-12-31 14:15:36'); 

SELECT * FROM comments;
-- TRUNCATE comments;

-- Корректировка поля updated_at
UPDATE comments SET updated_at = NOW();
 		 		

-- 12. Таблица сообщений
INSERT INTO `messages` VALUES 
('1','4','2','Quidem voluptatem mollitia unde cumque eligendi. Vitae reiciendis aut nobis qui. Aspernatur repudiandae voluptates sit.','1','2020-11-04 13:31:00','2020-12-23 01:01:27'),
('2','5','19','Quibusdam vel odit enim aliquam. Sunt accusamus quasi est magni qui. Facere et doloribus ipsum laboriosam doloribus a.','0','2020-10-26 05:14:34','2020-12-24 06:14:58'),
('3','7','2','Magni exercitationem et blanditiis soluta velit blanditiis consequatur. Inventore voluptatem eos ut. Ipsam et ea illo dolores voluptatem. Voluptas dolores perspiciatis doloribus corrupti et.','0','2020-09-05 12:48:35','2020-12-24 19:08:17'),
('4','11','17','Qui eos et nihil neque et et consequatur. Praesentium optio quaerat quod magnam. Velit vero blanditiis doloremque dolor odit.','0','2020-03-22 11:16:33','2020-12-27 07:09:26'),
('5','15','3','Dolores est voluptas minus quisquam. Rerum blanditiis non iste. Fuga eum aut nemo ex. Tempore quo aperiam harum maxime.','0','2020-01-21 08:41:44','2020-12-18 09:57:43'),
('6','18','19','Ex et nisi placeat est. Rerum quaerat est dolor perferendis quos. Ipsam ut qui ut est hic maiores eaque molestiae. Voluptatibus est aspernatur aliquid animi et.','1','2020-10-07 20:25:12','2020-12-12 07:21:02'),
('7','17','14','In beatae nostrum sit unde. Qui corrupti mollitia ab accusantium sed. Dolores architecto qui ut provident qui. Ullam est voluptas excepturi occaecati.','1','2020-07-18 03:42:46','2020-12-25 00:37:25'),
('8','14','10','Reprehenderit temporibus molestiae qui omnis minima. Est quaerat quidem veritatis quia dolores tempora hic placeat. Nisi at nostrum facilis quos voluptas est. Provident autem velit eum sequi facere.','0','2020-12-18 00:50:28','2020-12-29 01:01:11'),
('9','14','19','Quasi quia assumenda porro autem. Rem numquam aut iure sit aut iusto aut. Aut eaque dolore et dignissimos maxime. Quasi expedita ut voluptas autem ut expedita.','0','2020-07-16 21:47:06','2020-12-25 11:59:57'),
('10','9','9','Non eos mollitia qui sed sit quod dolores. Deserunt incidunt officia incidunt accusamus sit quia. Enim iusto dolores unde ullam amet odio magnam. Asperiores alias atque hic consequatur repudiandae.','0','2020-12-07 09:47:10','2020-12-24 18:21:17'),
('11','13','12','Et nihil et est voluptas iure ut repellendus. Ipsa delectus voluptas sed qui aspernatur voluptates. Sint unde nihil at deserunt sit suscipit sunt.','0','2020-11-13 17:10:55','2020-12-13 14:44:09'),
('12','1','12','Asperiores accusantium sapiente quis ea et animi. Nihil beatae blanditiis ut reiciendis voluptatem impedit optio ut. Non aut rerum doloremque aut id eligendi. Qui sapiente error vel architecto consequatur nesciunt. Aut omnis culpa velit hic reprehenderit consequatur.','1','2020-08-22 03:03:17','2020-12-10 19:56:13'),
('13','11','17','Dicta sequi similique dolore explicabo ut dolores maiores eum. Et consequatur tempore sint corrupti et voluptates sit.','0','2020-08-30 22:30:14','2021-01-04 15:13:09'),
('14','17','1','Minus in aliquam nisi. Maiores consequatur in sed nesciunt voluptatibus velit voluptatem. Numquam qui itaque voluptatem qui labore numquam ad. At similique sed aliquam dolorem ad.','0','2020-09-14 09:57:37','2021-01-01 06:25:11'),
('15','8','20','Quidem vel et quia minima sint quos natus. Aperiam aspernatur quaerat beatae error. Laboriosam tempore sunt fugit qui. Doloribus enim odio distinctio dolor.','0','2020-06-19 22:44:24','2020-12-23 09:47:06'),
('16','7','14','Tempore unde molestiae quia nihil. Adipisci ex amet expedita mollitia commodi sed. Doloremque laboriosam accusamus tempora amet. Delectus dolor unde sit perferendis. Quia ut culpa consequatur fugit eum.','0','2021-01-02 09:15:32','2020-12-28 09:01:21'),
('17','20','7','Molestiae voluptas vel alias dolor delectus. Excepturi nihil id consequatur voluptatem. Tempore voluptate aut temporibus ut aut sunt in voluptas. Qui natus dolores perspiciatis ut.','1','2020-03-15 22:48:15','2020-12-08 01:29:49'),
('18','3','19','Illum et ut iusto similique perferendis sed. Aliquid expedita et aperiam dolores. Ea voluptas amet in quas. Hic fugit quia in quisquam praesentium voluptas fugit.','0','2020-03-30 19:50:56','2020-12-31 12:51:22'),
('19','16','6','Porro consequatur possimus non. Veritatis eos velit est. Debitis labore similique ab natus aut id voluptatum. Incidunt molestiae quia iure veritatis.','0','2020-03-23 13:56:50','2020-12-11 02:28:04'),
('20','6','7','Id dolorum accusantium vel reprehenderit consectetur voluptatem. Ut qui enim odio qui tempore.','0','2020-11-03 20:25:01','2020-12-22 19:10:43'),
('21','6','4','Sed totam iste voluptas qui magni cupiditate similique suscipit. Repellendus asperiores ea quia non. Voluptatem explicabo dolor iusto vero rerum excepturi beatae omnis. Quos quas aut error.','1','2020-05-17 01:29:23','2020-12-21 19:20:28'),
('22','17','11','Possimus fugit iste dolores. Enim non dignissimos asperiores velit possimus quas et. Ab et mollitia eos fugit perspiciatis ea nemo. Voluptas veritatis quas et et.','0','2020-12-15 23:11:54','2020-12-15 03:46:45'),
('23','9','9','Ratione voluptas nisi omnis illum perspiciatis. Labore inventore nobis minus dolorum facere magnam. Dolores reprehenderit laboriosam ipsum expedita rerum laborum eum.','0','2020-11-16 17:12:13','2020-12-28 07:33:09'),
('24','15','1','Magnam ut debitis omnis quibusdam distinctio alias. Numquam nihil in iure rerum cum distinctio repudiandae.','0','2020-09-06 00:46:06','2020-12-08 04:21:27'),
('25','10','19','Et delectus repudiandae sapiente. Pariatur tenetur et voluptatem reiciendis nisi sed totam sint. Ab nihil veritatis cumque. At nihil id qui aperiam porro in voluptatibus.','1','2020-03-09 03:26:25','2020-12-26 07:15:29'),
('26','8','15','Inventore dolor sequi nesciunt qui natus molestiae doloribus. Dignissimos ex doloribus maxime et voluptatem nesciunt voluptatem. Explicabo pariatur itaque voluptas facilis. Aut repudiandae aut aliquam dignissimos sed ratione molestias.','1','2020-08-09 18:13:20','2020-12-11 23:08:22'),
('27','14','6','Itaque in sequi possimus molestiae. Itaque alias ipsum quis eum et. Cumque rem eum itaque commodi molestiae. Ullam sed ullam similique beatae eos molestiae est.','0','2020-07-01 01:19:15','2020-12-29 06:15:55'),
('28','19','20','Dolores itaque non aut mollitia distinctio atque. Modi est aut quia vitae sapiente a dolores. Possimus voluptate deleniti ratione ea sed aliquam quo dolores. Nihil distinctio soluta recusandae voluptatum amet nam unde.','1','2020-11-25 23:15:19','2020-12-29 04:59:03'),
('29','18','11','Et voluptas quibusdam ut dolore ab est. Temporibus excepturi dolores incidunt quo. Excepturi et nostrum eligendi sequi rerum ad ullam. Cumque distinctio repellat odio at.','0','2020-03-18 02:48:08','2020-12-27 20:38:43'),
('30','11','16','Perferendis cum dolor facilis ut voluptatum in optio. Autem sunt consequatur et in nesciunt libero. Dolor id dolores maxime mollitia enim quam nam rerum. Amet omnis numquam aspernatur inventore illum ratione molestias rerum.','1','2020-03-26 10:01:07','2021-01-01 21:02:49'); 	

SELECT * FROM messages;
-- TRUNCATE messages;

-- Корректировка поля updated_at
UPDATE messages SET updated_at = NOW();


-- 13. Таблица историй
INSERT INTO `stories` VALUES 
('1','4','2','0',NULL,'2020-02-11 15:53:39'),
('2','12','18','0',NULL,'2020-09-23 22:44:26'),
('3','8','12','1',NULL,'2020-11-05 19:42:16'),
('4','17','13','0',NULL,'2020-12-13 23:49:49'),
('5','18','36','0',NULL,'2020-08-19 08:41:21'),
('6','15','32','0',NULL,'2020-02-13 09:31:42'),
('7','19','27','1',NULL,'2020-03-11 16:59:03'),
('8','1','5','1',NULL,'2020-10-13 06:28:15'),
('9','14','38','1',NULL,'2020-05-21 07:41:59'),
('10','11','22','0',NULL,'2020-03-07 07:00:52'),
('11','2','40','0',NULL,'2020-03-16 16:20:31'),
('12','3','47','0',NULL,'2020-04-18 16:06:33'),
('13','13','13','0',NULL,'2020-06-11 19:55:14'),
('14','12','37','0',NULL,'2020-06-03 21:15:01'),
('15','13','48','0',NULL,'2020-11-14 11:34:49'); 

SELECT * FROM stories;
-- TRUNCATE stories;

-- Заполнение данными поля geo
UPDATE stories SET geo = CONCAT(1 + RAND() * 100, ' ', 1 + RAND() * 200);


-- 14. Таблица взаимосвязи отмеченных пользователей и историй
INSERT INTO `tag_users_stories` VALUES 
('1','7','2020-12-27 01:41:22'),
('3','10','2020-12-29 06:14:51'),
('4','11','2021-01-01 22:07:27'),
('12','2','2020-12-22 15:30:55'),
('19','9','2020-12-19 20:55:13'); 

SELECT * FROM tag_users_stories;
-- TRUNCATE tag_users_stories;


-- 15. Таблица близких друзей
INSERT INTO `close_friends` VALUES 
('3','3','2018-04-02 08:38:38','2020-06-19 20:18:32'),
('5','4','2019-09-27 12:17:09','2020-03-29 12:10:01'),
('5','7','2015-11-17 18:45:42','2020-12-20 13:58:14'),
('5','14','2019-05-04 02:57:52','2020-04-06 04:14:29'),
('5','20','2015-09-20 10:07:53','2020-05-31 18:01:47'),
('11','12','2013-05-01 00:00:33','2020-07-18 11:57:13'),
('12','7','2019-10-05 09:31:40','2020-01-08 14:46:36'),
('12','10','2011-03-07 07:54:32','2020-06-22 03:38:59'),
('12','13','2016-06-26 05:54:04','2020-02-13 16:12:37'),
('14','13','2018-12-23 17:34:45','2020-07-26 20:48:02'),
('19','15','2015-01-10 03:55:11','2020-02-05 09:38:37'),
('20','20','2016-09-26 11:50:32','2020-11-06 13:55:02'); 	

SELECT * FROM close_friends;
-- TRUNCATE close_friends;

-- Корректировка поля updated_at
UPDATE close_friends SET updated_at = NOW();
 		

-- 16. Таблица типов лайков
INSERT INTO target_types (name) VALUES 
  ('publications'),
  ('messages'),
  ('comments');
 
SELECT * FROM target_types;
-- TRUNCATE target_types;


-- 17. Таблица лайков
INSERT INTO `likes` VALUES 
('1','4','13','3','2020-12-09 18:46:40'),
('2','15','10','3','2020-12-08 11:22:04'),
('3','12','2','3','2020-12-16 09:40:24'),
('4','7','7','2','2020-12-28 14:45:54'),
('5','11','11','1','2020-12-27 16:59:56'),
('6','16','3','1','2020-12-30 14:34:24'),
('7','19','3','3','2020-12-28 07:07:10'),
('8','18','19','3','2020-12-14 21:10:28'),
('9','11','20','3','2020-12-13 08:02:43'),
('10','16','5','2','2020-12-21 13:11:43'),
('11','1','19','3','2020-12-08 16:34:41'),
('12','8','2','1','2021-01-02 17:40:55'),
('13','4','3','1','2020-12-31 10:10:05'),
('14','13','14','2','2020-12-15 14:58:50'),
('15','7','2','2','2020-12-29 18:51:39'),
('16','9','20','2','2020-12-29 10:10:54'),
('17','2','1','2','2020-12-17 20:12:58'),
('18','2','3','2','2020-12-16 18:34:11'),
('19','17','6','1','2020-12-13 17:39:52'),
('20','16','3','3','2021-01-01 19:36:24'),
('21','4','12','1','2021-01-01 05:23:18'),
('22','3','16','1','2020-12-19 22:53:02'),
('23','20','1','3','2020-12-24 14:44:55'),
('24','7','17','2','2020-12-09 08:20:17'),
('25','14','16','1','2021-01-03 09:08:39'); 

SELECT * FROM likes;
-- TRUNCATE likes;


-- 18. Таблица привязанных устройств
INSERT INTO devices (name) VALUES 
  ('Apple'),
  ('ASUS'),
  ('BlackBerry'),
  ('Huawei'),
  ('Lenovo'),
  ('LG'),
  ('Linux'),
  ('MacOS'),
  ('Motorola'),
  ('Microsoft'),
  ('Nokia'),
  ('OnePlus'),
  ('Samsung'),
  ('SonyEricsson'),
  ('Windows'),
  ('Xiaomi');
 
SELECT * FROM devices;
-- TRUNCATE devices;


-- 19. Таблица входа пользователей в профиль с привязанных устройств
INSERT INTO `authorization_devices` VALUES 
('1','18','3',NULL,'2020-10-17 10:41:31','2020-12-22 15:16:24'),
('2','14','7',NULL,'2020-10-26 22:44:46','2021-01-04 13:12:05'),
('3','17','2',NULL,'2020-03-25 13:23:05','2020-12-08 07:50:38'),
('4','16','4',NULL,'2020-10-28 16:08:04','2021-01-07 17:00:04'),
('5','2','10',NULL,'2020-11-16 06:59:33','2020-12-11 12:40:49'),
('6','10','1',NULL,'2020-07-01 03:32:00','2020-12-17 14:09:08'),
('7','3','8',NULL,'2020-11-30 02:21:17','2020-12-16 09:18:03'),
('8','18','12',NULL,'2020-11-24 01:41:12','2020-12-22 01:14:26'),
('9','5','11',NULL,'2020-05-07 10:43:42','2020-12-17 20:42:08'),
('10','7','8',NULL,'2020-08-21 20:08:32','2020-12-19 17:46:46'),
('11','2','9',NULL,'2020-02-05 23:01:41','2021-01-07 18:01:16'),
('12','12','12',NULL,'2020-03-31 02:59:15','2020-12-16 19:16:28'),
('13','4','14',NULL,'2020-06-11 10:18:43','2020-12-31 03:52:48'),
('14','20','8',NULL,'2020-10-12 10:36:40','2020-12-08 17:17:58'),
('15','12','1',NULL,'2020-06-09 09:27:14','2020-12-23 18:06:47'),
('16','6','6',NULL,'2020-06-28 06:43:30','2020-12-12 17:24:59'),
('17','7','16',NULL,'2020-05-26 13:14:13','2020-12-24 09:31:47'),
('18','10','4',NULL,'2020-04-23 08:27:14','2020-12-27 16:35:14'),
('19','19','16',NULL,'2020-01-30 10:01:01','2021-01-02 02:03:54'),
('20','17','5',NULL,'2020-06-25 07:35:14','2021-01-03 11:36:53'),
('21','2','9',NULL,'2020-12-19 04:25:44','2020-12-19 17:43:56'),
('22','15','14',NULL,'2020-09-18 01:28:29','2021-01-03 14:26:41'),
('23','2','9',NULL,'2020-10-25 09:46:43','2020-12-17 07:07:30'),
('24','4','10',NULL,'2020-10-04 10:09:19','2021-01-03 09:16:41'),
('25','20','5',NULL,'2020-04-10 11:56:40','2020-12-31 19:39:06'),
('26','10','9',NULL,'2020-07-07 23:50:47','2020-12-20 19:27:56'),
('27','15','9',NULL,'2020-02-11 04:04:55','2020-12-30 21:10:24'),
('28','20','5',NULL,'2020-08-30 11:46:04','2020-12-16 04:33:06'),
('29','12','6',NULL,'2020-12-29 22:52:33','2021-01-04 13:24:29'),
('30','19','10',NULL,'2020-06-15 10:26:09','2021-01-05 11:51:05'); 

SELECT * FROM authorization_devices;
-- TRUNCATE authorization_devices;

-- Заполнение данными поля geo
UPDATE authorization_devices SET geo = CONCAT(1 + RAND() * 100, ' ', 1 + RAND() * 200);
-- Корректировка поля updated_at
UPDATE authorization_devices SET updated_at = NOW();


-- 20. Таблица архива входа пользователей в профиль с привязанных устройств
SELECT * FROM authorization_devices_logs;


-- скрипты характерных выборок (включающие группировки, JOIN'ы, вложенные таблицы);

-- 1. Запрос данных пользователя
SELECT
	(SELECT name FROM users WHERE id = user_id) AS name,
	(SELECT login FROM users WHERE id = user_id) AS login,
	email,
 	(SELECT name FROM users_genders WHERE id = gender_id) As gender,
 	birthday
FROM users_personal_info 
WHERE id = 16;

-- 2. Запрос данных о загрузке видео пользователя
SELECT 
	(SELECT login FROM users WHERE id = user_id) AS login,
	file_size,
	media_types_id
FROM media
WHERE user_id = 4 
AND media_types_id = (SELECT id FROM media_types WHERE name = 'video');
       

-- 3. Запрос истории, на кого подписывался пользователь
SELECT CONCAT(
	'Пользователь ', 
	(SELECT CONCAT(login) FROM users WHERE id = user_id),
	' подписался на пользователя ', 
	(SELECT CONCAT(login) FROM users WHERE id = followed_user_id),
	' ', 
	created_at) AS history
FROM followers 
WHERE user_id = 5;
   
    
-- 4. Запрос сообщений, которые не прочитаны пользователем
SELECT from_user_id, 
	to_user_id, 
	body, 
IF(is_read, 'read', 'not read') AS status 
FROM messages
WHERE (to_user_id = 9) AND is_read = False;
    

-- 5. Запрос количества публикаций пользователя, на которого подписался другой пользователь
SELECT 
	u.id AS user, 
	f.followed_user_id AS followed_user, 
	COUNT(*) AS total_publications 
FROM users u 
JOIN followers f 
	ON u.id = f.user_id
JOIN publications p
	ON f.followed_user_id = p.user_id 
WHERE u.id = 5 AND f.followed_user_id = 12
GROUP BY f.followed_user_id;

-- 6. Запрос медиафайлов, на которых отметили пользователя
SELECT 
	m.id AS media, m.user_id AS user_who_tags, m.file_name, mt.name 
FROM media m
JOIN tag_users_media tum 
	ON m.id = tum.media_id
JOIN media_types mt 
	ON m.media_types_id = mt.id 
WHERE tum.tag_user_id = 9;

-- 7. Запрос комментариев пользователя
SELECT c.body, c.publication_id, c.created_at
FROM comments c
JOIN publications p
	ON c.publication_id = p.id
WHERE c.from_user_id = 7;

-- 8. Запрос количества близких друзей у пользователей
SELECT u.id, u.login, COUNT(cf.user_id) AS total_close_friends
FROM users u
JOIN close_friends cf 
	ON u.id = cf.user_id
GROUP BY u.id
ORDER BY total_close_friends DESC
LIMIT 5;
 
-- 9. Запрос количества подписок (followed_user) и подписчиков (following_user) у пользователя
SELECT u2.id, followed_user, following_user
FROM users u2
LEFT JOIN
	(SELECT u.id, COUNT(f.user_id) AS followed_user
	FROM users u
	LEFT JOIN followers f
		ON u.id = f.user_id 
	GROUP BY u.id) AS t
ON u2.id = t.id
LEFT JOIN
	(SELECT u.id, COUNT(f2.followed_user_id) AS following_user
	FROM users u
	LEFT JOIN followers f2
		ON u.id = f2.followed_user_id 
	GROUP BY u.id) AS t2
ON u2.id = t2.id
WHERE u2.id = 5;

-- 10. Запрос публикаций пользователя с количеством лайков
SELECT u.login AS owner, p.id AS publication, COUNT(DISTINCT(l.target_id)) AS total_likes
FROM users u
LEFT JOIN publications p
	ON u.id = p.user_id 
LEFT JOIN likes l
	ON p.id = l.target_id 
WHERE u.id = 7 
GROUP BY p.id;
 
-- 11. Запрос количества публикаций каждого пользователя от общего числа всех публикаций
SELECT DISTINCT 
	u.login,
	COUNT(p.id) OVER w AS total_by_user,
	COUNT(p.id) OVER() AS total,
	COUNT(p.id) OVER w / COUNT(p.id) OVER() AS 'percent'
FROM publications p
	JOIN users u
		ON p.user_id = u.id 
	WINDOW w AS (PARTITION BY p.user_id)
ORDER BY total_by_user DESC;


-- представления (минимум 2);

-- 1. Представление с объединенной информацией из таблиц users и users_personal_info
CREATE VIEW users_info AS
	SELECT u.id, u.name, u.login, upi.email, upi.phone, upi.gender_id 
	FROM users u
	JOIN users_personal_info upi
		ON u.id = upi.user_id;

-- Проверка представления users_info
SELECT * FROM users_info LIMIT 5;


-- 2. Представление с информацией о входах пользователей за последние 14 дней
CREATE VIEW last_authorization AS
	SELECT u.login, d2.name, ad.updated_at 
	FROM authorization_devices ad 
	JOIN users u
		ON ad.user_id = u.id 
	JOIN devices d2 
		ON d2.id = ad.device_id 
	WHERE ad.updated_at > (NOW() - INTERVAL 14 DAY);

-- Проверка представления last_authorization
SELECT * FROM last_authorization LIMIT 5;


-- 3. Представление с объединенной информацией из таблиц publications и stories для пользователя
CREATE VIEW users_publications_stories AS
SELECT 
	u.id AS user, p.id AS publication, 
	p.created_at AS created_pubs, 
	s.id AS story, 
	s.created_at AS created_at_story
FROM users u
LEFT JOIN publications p 
	ON u.id = p.user_id 
LEFT JOIN stories s 
	ON u.id = s.user_id;

-- Проверка представления users_publications_stories
SELECT * FROM users_publications_stories WHERE user = 20;


-- хранимые процедуры / триггеры;

-- 1. Триггер на вставку данных в таблицу authorization_devices, данные добавляются в архивную таблицу authorization_devices_logs
DELIMITER //
-- DROP TRIGGER insert_authorization_devices;
CREATE TRIGGER insert_authorization_devices AFTER INSERT ON authorization_devices
FOR EACH ROW 
BEGIN
	INSERT INTO authorization_devices_logs VALUES (NEW.user_id, NEW.device_id, NEW.geo, NOW());
END//

DELIMITER ;
-- Проверочные вставки данных
INSERT INTO authorization_devices VALUES  
(NULL, '18', '3', '54.56464646 60.545872134', NOW(), NOW()),
(NULL, '2', '9', '54.56464646 60.545872134', NOW(), NOW());

SELECT * FROM authorization_devices ad ORDER BY id DESC LIMIT 5;
SELECT * FROM authorization_devices_logs ad ORDER BY created_at DESC;

-- 2. Триггер на вставку данных в таблицу likes, проверка существования target_id (Публикации)
DELIMITER //
-- DROP TRIGGER insert_likes_publications;
CREATE TRIGGER insert_likes_publications BEFORE INSERT ON likes
FOR EACH ROW 
BEGIN
	IF (SELECT id FROM publications WHERE NEW.target_id = id) IS NULL AND NEW.target_type_id = 1 THEN
	SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Вставка отменена. Публикации с введенным id не существует.';
  END IF;
END//

DELIMITER ;
-- Проверочные вставки данных
INSERT INTO likes VALUES  
(NULL,'2','50','1','2020-12-09 18:46:40');
INSERT INTO likes VALUES  
(NULL,'2','3','1','2020-12-09 18:46:40');

SELECT * FROM likes ORDER BY id DESC LIMIT 1;

-- 3. Триггер на вставку данных в таблицу likes, проверка существования target_id (Сообщения)
DELIMITER //
-- DROP TRIGGER insert_likes_messages;
CREATE TRIGGER insert_likes_messages BEFORE INSERT ON likes
FOR EACH ROW 
BEGIN
	IF (SELECT id FROM messages WHERE NEW.target_id = id) IS NULL AND NEW.target_type_id = 2 THEN
	SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Вставка отменена. Сообщений с введенным id не существует.';
  END IF;
END//

DELIMITER ;
-- Проверочные вставки данных
INSERT INTO likes VALUES  
(NULL,'2','50','2','2020-12-09 18:46:40');
INSERT INTO likes VALUES  
(NULL,'2','4','2','2020-12-09 18:46:40');

SELECT * FROM likes ORDER BY id DESC LIMIT 1;

-- 4. Триггер на вставку данных в таблицу likes, проверка существования target_id (Комментарии)
DELIMITER //
-- DROP TRIGGER insert_likes_comments;
CREATE TRIGGER insert_likes_comments BEFORE INSERT ON likes
FOR EACH ROW 
BEGIN
	IF (SELECT id FROM comments WHERE NEW.target_id = id) IS NULL AND NEW.target_type_id = 3 THEN
	SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Вставка отменена. Комментария с введенным id не существует';
  END IF;
END//

DELIMITER ;
-- Проверочные вставки данных
INSERT INTO likes VALUES  
(NULL,'2','50','3','2020-12-09 18:46:40');
INSERT INTO likes VALUES  
(NULL,'2','5','3','2020-12-09 18:46:40');

SELECT * FROM likes ORDER BY id DESC LIMIT 1;