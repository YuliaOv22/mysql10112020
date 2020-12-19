-- Практическое задание по теме “NoSQL”

-- 1. В базе данных Redis подберите коллекцию для подсчета посещений с определенных IP-адресов.

HSET visits '192.168.1.2' 1
HINCRBY visits '192.168.1.2' 1
HGET visits '192.168.1.2'
HGETALL visits

HSET visits '192.168.1.7' 1
HINCRBY visits '192.168.1.7' 1
HGET visits '192.168.1.7'
HGETALL visits


-- 2. При помощи базы данных Redis решите задачу поиска имени пользователя по электронному адресу и наоборот, 
-- поиск электронного адреса пользователя по его имени.

HSET user 'Vera Smith' 'vera@gmail.com'
HSET user 'John Cage' 'johnc@gmail.com'
HGET user 'Vera Smith'

HSET email 'vera@gmail.com' 'Vera Smith'
HSET email 'em89@yandex.ru' 'Emily Strong'
HGET email 'em89@yandex.ru'

 
-- 3. Организуйте хранение категорий и товарных позиций учебной базы данных shop в СУБД MongoDB.

db.createCollection('catalogs')
db.createCollection('products')

db.catalogs.insert({name: 'Процессоры'})
db.catalogs.insert({name: 'Мат.платы'})

db.catalogs.find()

db.products.insert({
    name: 'Intel Core i3-8100',
    description: 'Процессор для настольных персональных компьютеров, основанных на платформе Intel.',
    price: 7890.00,
    catalogs: 'Процессоры'});

db.products.insert({
    name: 'Intel Core i5-7400',
    description: 'Процессор для настольных персональных компьютеров, основанных на платформе Intel.',
    price: 12700.00,
    catalogs: 'Процессоры'});

db.products.insert({
    name: 'ASUS ROG MAXIMUS X HERO',
    description: 'Материнская плата ASUS ROG MAXIMUS X HERO, Z370, Socket 1151-V2, DDR4, ATX',
    price: 19310.00,
    catalogs: 'Мат.платы'});

db.products.find()
