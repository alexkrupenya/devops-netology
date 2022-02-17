# Task 1

*Используя docker поднимите инстанс PostgreSQL (версию 12) c 2 volume, в который будут складываться данные БД и бэкапы.*

*Приведите получившуюся команду или docker-compose манифест.*

Решение:
Забираю образ докера с версией Postgres 12.
```
[alexvk@archbox 6.2]$ docker pull postgres:12
12: Pulling from library/postgres
[skipped]
Digest: sha256:505d023f030cdea84a42d580c2a4a0e17bbb3e91c30b2aea9c02f2dfb10325ba
Status: Downloaded newer image for postgres:12
docker.io/library/postgres:12
```
Создаю тома для Postgres с дефолтным расположением:
```
[alexvk@archbox 6.2]$ docker volume create volume01 && docker volume create volume02
volume01
volume02
```
Создаю контейнер с сервером Postgres:
```
[alexvk@archbox 6.2]$ docker run --name some-postgres -e POSTGRES_PASSWORD=mysecret -v volume01:/var/lib/postgresql/data -v volume02:/var/lib/postgresql/backup  -d postgres:12
```
Подключаюсь к контейнеру и просматриваю содержимое:
```
alexvk@archbox 6.2]$ docker exec -it some-postgres bash
root@3bcf5e4aa575:/# psql -U postgres
psql (12.10 (Debian 12.10-1.pgdg110+1))
Type "help" for help.

postgres=# \l
                                 List of databases
   Name    |  Owner   | Encoding |  Collate   |   Ctype    |   Access privileges  
 
-----------+----------+----------+------------+------------+-----------------------
 postgres  | postgres | UTF8     | en_US.utf8 | en_US.utf8 | 
 template0 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +
           |          |          |            |            | postgres=CTc/postgres
 template1 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +
           |          |          |            |            | postgres=CTc/postgres
(3 rows)

postgres=# 
```
Задание выполнено.

# Task 2

*В БД из задачи 1:*

* *создайте пользователя test-admin-user и БД test_db*
* *в БД test_db создайте таблицу orders и clients (спeцификация таблиц ниже)*
* *предоставьте привилегии на все операции пользователю test-admin-user на таблицы БД test_db*
* *создайте пользователя test-simple-user*
* *предоставьте пользователю test-simple-user права на SELECT/INSERT/UPDATE/DELETE данных таблиц БД test_db*

Создаю суперпользователя БД:
```
postgres=# CREATE ROLE "test-admin-user" SUPERUSER NOINHERIT LOGIN;
CREATE ROLE
postgres=# CREATE DATABASE test_db;
CREATE DATABASE
postgres=# \dg
                                      List of roles
    Role name    |                         Attributes                         | Member of 
-----------------+------------------------------------------------------------+-----------
 postgres        | Superuser, Create role, Create DB, Replication, Bypass RLS | {}
 test-admin-user | Superuser, No inheritance                                  | {}

postgres=# \l
                                 List of databases
   Name    |  Owner   | Encoding |  Collate   |   Ctype    |   Access privileges   
-----------+----------+----------+------------+------------+-----------------------
 postgres  | postgres | UTF8     | en_US.utf8 | en_US.utf8 | 
 template0 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +
           |          |          |            |            | postgres=CTc/postgres
 template1 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +
           |          |          |            |            | postgres=CTc/postgres
 test_db   | postgres | UTF8     | en_US.utf8 | en_US.utf8 | 
(4 rows)
```
Создаю таблицу orders:
```
test_db=# CREATE TABLE orders ( id integer, name text, price integer, PRIMARY KEY (id) );

test_db=# \d orders
               Table "public.orders"
 Column |  Type   | Collation | Nullable | Default 
--------+---------+-----------+----------+---------
 id     | integer |           | not null | 
 name   | text    |           |          | 
 price  | integer |           |          | 
Indexes:
    "orders_pkey" PRIMARY KEY, btree (id)
```

Создаю таблицу clients:
```
test_db=# CREATE TABLE clients ( id integer PRIMARY KEY, surname text, country text,	booking integer, FOREIGN KEY (booking) REFERENCES orders (id) );
CREATE TABLE
test_db=# \d clients
               Table "public.clients"
 Column  |  Type   | Collation | Nullable | Default 
---------+---------+-----------+----------+---------
 id      | integer |           | not null | 
 surname | text    |           |          | 
 country | text    |           |          | 
 booking | integer |           |          | 
Indexes:
    "clients_pkey" PRIMARY KEY, btree (id)
Foreign-key constraints:
    "clients_booking_fkey" FOREIGN KEY (booking) REFERENCES orders(id)
```

Создаю пользователя по заданию:
```
postgres=# CREATE ROLE "test-simple-user" NOSUPERUSER LOGIN NOINHERIT NOCREATEDB NOCREATEROLE;
CREATE ROLE
```

Даю все права на test_db для test-admin-user:
```
test_db=# GRANT ALL ON DATABASE test_db TO "test-admin-user" ;
GRANT
```

И права пользователя test-simple-user на таблицы:
```
test_db=# GRANT SELECT ON clients TO "test-simple-user" ;
GRANT
test_db=# GRANT INSERT ON clients TO "test-simple-user" ;
GRANT
test_db=# GRANT UPDATE ON clients TO "test-simple-user" ;
GRANT
test_db=# GRANT DELETE ON clients TO "test-simple-user" ;
GRANT
test_db=# GRANT SELECT ON orders TO "test-simple-user" ;
GRANT
test_db=# GRANT INSERT ON orders TO "test-simple-user" ;
GRANT
test_db=# GRANT UPDATE ON orders TO "test-simple-user" ;
GRANT
test_db=# GRANT DELETE ON orders TO "test-simple-user" ;
GRANT
```
Итоги:  
Список БД:
```
test_db=# \l
                                     List of databases
   Name    |  Owner   | Encoding |  Collate   |   Ctype    |       Access privileges        
-----------+----------+----------+------------+------------+--------------------------------
 postgres  | postgres | UTF8     | en_US.utf8 | en_US.utf8 | 
 template0 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres                   +
           |          |          |            |            | postgres=CTc/postgres
 template1 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres                   +
           |          |          |            |            | postgres=CTc/postgres
 test_db   | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =Tc/postgres                  +
           |          |          |            |            | postgres=CTc/postgres         +
           |          |          |            |            | "test-admin-user"=CTc/postgres
(4 rows)
```
Описание таблиц:
```
test_db=# \d clients
               Table "public.clients"
 Column  |  Type   | Collation | Nullable | Default 
---------+---------+-----------+----------+---------
 id      | integer |           | not null | 
 surname | text    |           |          | 
 country | text    |           |          | 
 booking | integer |           |          | 
Indexes:
    "clients_pkey" PRIMARY KEY, btree (id)
Foreign-key constraints:
    "clients_booking_fkey" FOREIGN KEY (booking) REFERENCES orders(id)

test_db=# \d orders
               Table "public.orders"
 Column |  Type   | Collation | Nullable | Default 
--------+---------+-----------+----------+---------
 id     | integer |           | not null | 
 name   | text    |           |          | 
 price  | integer |           |          | 
Indexes:
    "orders_pkey" PRIMARY KEY, btree (id)
Referenced by:
    TABLE "clients" CONSTRAINT "clients_booking_fkey" FOREIGN KEY (booking) REFERENCES orders(id)
```
SQL-запрос на выдачу списка с правами пользователей:
```
test_db=# SELECT * FROM information_schema.role_table_grants WHERE table_catalog IN ('test_db') AND grantee IN ('test-simple-user','test-admin-user');
 grantor  |     grantee      | table_catalog | table_schema | table_name | privilege_type | is_grantable | with_hierarchy 
----------+------------------+---------------+--------------+------------+----------------+--------------+----------------
 postgres | test-simple-user | test_db       | public       | orders     | INSERT         | NO           | NO
 postgres | test-simple-user | test_db       | public       | orders     | SELECT         | NO           | YES
 postgres | test-simple-user | test_db       | public       | orders     | UPDATE         | NO           | NO
 postgres | test-simple-user | test_db       | public       | orders     | DELETE         | NO           | NO
 postgres | test-simple-user | test_db       | public       | clients    | INSERT         | NO           | NO
 postgres | test-simple-user | test_db       | public       | clients    | SELECT         | NO           | YES
 postgres | test-simple-user | test_db       | public       | clients    | UPDATE         | NO           | NO
 postgres | test-simple-user | test_db       | public       | clients    | DELETE         | NO           | NO
(8 rows)
```

# Task 3

*Используя SQL синтаксис - наполните таблицы следующими тестовыми данными:*  
*...*  
*Используя SQL синтаксис:*

* *вычислите количество записей для каждой таблицы*

*приведите в ответе:*
* *запросы*
* *результаты их выполнения.*

Заполняю данными таблицу orders:
```
test_db=# INSERT INTO orders VALUES (1,'Шоколад',10),(2,'Принтер',3000),(3,'Книга',500),(4,'Монитор',7000),(5,'Гитара',4000);
INSERT 0 5
test_db=# SELECT * FROM orders;
 id |  name   | price 
----+---------+-------
  1 | Шоколад |    10
  2 | Принтер |  3000
  3 | Книга   |   500
  4 | Монитор |  7000
  5 | Гитара  |  4000
(5 rows)
```
Заполняю данными таблицу clients:
```
test_db=# INSERT INTO clients VALUES (1,'Иванов Иван Иванович','USA'),(2,'Петров Петр Петрович','Canada'),(3,'Иоганн Себастьян Бах','Japan'),(4,'Ронни Джеймс Дио','Russia'),(5,'Ritchie Blackmore','Russia');
INSERT 0 5
test_db=# SELECT * FROM clients;
 id |       surname        | country | booking 
----+----------------------+---------+---------
  1 | Иванов Иван Иванович | USA     |        
  2 | Петров Петр Петрович | Canada  |        
  3 | Иоганн Себастьян Бах | Japan   |        
  4 | Ронни Джеймс Дио     | Russia  |        
  5 | Ritchie Blackmore    | Russia  |        
(5 rows)
```
Количество записей в orders:
```
test_db=# SELECT COUNT (*) FROM orders;
 count 
-------
     5
(1 row)
```
Количество записей в clients:
```
test_db=# SELECT COUNT (*) FROM clients;
 count 
-------
     5
(1 row)
```


# Task 4

*Часть пользователей из таблицы clients решили оформить заказы из таблицы orders.*

*Используя foreign keys свяжите записи из таблиц, согласно таблице:*  
*...*  

*Приведите SQL-запрос для выдачи всех пользователей, которые совершили заказ, а также вывод данного запроса.*  

С помощью директивы UPDATE оформляю заказы:
```
test_db=# UPDATE  clients SET booking = 3 WHERE id = 1;
UPDATE 1
test_db=# UPDATE  clients SET booking = 4 WHERE id = 2;
UPDATE 1
test_db=# UPDATE  clients SET booking = 5 WHERE id = 3;
UPDATE 1
test_db=# SELECT * FROM clients;
 id |       surname        | country | booking 
----+----------------------+---------+---------
  4 | Ронни Джеймс Дио     | Russia  |        
  5 | Ritchie Blackmore    | Russia  |        
  1 | Иванов Иван Иванович | USA     |       3
  2 | Петров Петр Петрович | Canada  |       4
  3 | Иоганн Себастьян Бах | Japan   |       5
(5 rows)
```
Выборка результатов заказов - по логике необходимо выбрать непустые записи в booking (простой вариант).
```
test_db=# SELECT * FROM clients WHERE booking IS NOT NULL;
 id |       surname        | country | booking 
----+----------------------+---------+---------
  1 | Иванов Иван Иванович | USA     |       3
  2 | Петров Петр Петрович | Canada  |       4
  3 | Иоганн Себастьян Бах | Japan   |       5
(3 rows)
```
Но мы имеем связанные по ключу id таблицы orders, поэтому можно сделать выборку в таблице clients записей с заказами (конкатенацией по условию):
```
test_db=# SELECT * FROM clients INNER JOIN orders ON clients.booking=orders.id;
 id |       surname        | country | booking | id |  name   | price 
----+----------------------+---------+---------+----+---------+-------
  1 | Иванов Иван Иванович | USA     |       3 |  3 | Книга   |   500
  2 | Петров Петр Петрович | Canada  |       4 |  4 | Монитор |  7000
  3 | Иоганн Себастьян Бах | Japan   |       5 |  5 | Гитара  |  4000
(3 rows)
```

# Task 5

*Получите полную информацию по выполнению запроса выдачи всех пользователей из задачи 4 (используя директиву EXPLAIN).*

*Приведите получившийся результат и объясните что значат полученные значения.*  

Выполняю запрос с директивой EXPLAIN, показывающей работу планировщика Postgresql. По первому запросу:
```
test_db=# EXPLAIN SELECT * FROM clients WHERE booking IS NOT NULL;
                        QUERY PLAN                         
-----------------------------------------------------------
 Seq Scan on clients  (cost=0.00..18.10 rows=806 width=72)
   Filter: (booking IS NOT NULL)
(2 rows)
```
Видим план запроса. Количество строк и полей в таблицах, параметры поиска (фильтра) и полезный параметр cost. Чем меньше cost, тем быстрее
выполняется движком СУБД наш запрос. 
```
test_db=# EXPLAIN SELECT * FROM clients INNER JOIN orders ON clients.booking=orders.id;
                              QUERY PLAN                               
-----------------------------------------------------------------------
 Hash Join  (cost=37.00..57.24 rows=810 width=112)
   Hash Cond: (clients.booking = orders.id)
   ->  Seq Scan on clients  (cost=0.00..18.10 rows=810 width=72)
   ->  Hash  (cost=22.00..22.00 rows=1200 width=40)
         ->  Seq Scan on orders  (cost=0.00..22.00 rows=1200 width=40)
(5 rows)

```
По второму запросу видно выполнение INNER JOIN и поля таблиц, по которым происходит сравнение значений. Параметр cost сообщает, что запрос для
сервера дается большей ценой, чем первый. Первый запрос по непустому полю выглядит оптимальнее.

# Task 6

*Создайте бэкап БД test_db и поместите его в volume, предназначенный для бэкапов (см. Задачу 1).*

*Остановите контейнер с PostgreSQL (но не удаляйте volumes).*

*Поднимите новый пустой контейнер с PostgreSQL.*

*Восстановите БД test_db в новом контейнере.*

*Приведите список операций, который вы применяли для бэкапа данных и восстановления.*



Делаю дамп базы:
```
[alexvk@archbox ~]$ docker exec -it some-postgres pg_dumpall -U postgres -f /var/lib/postgresql/backup/dump_db.dmp
[alexvk@archbox ~]$ docker exec -it some-postgres bash
root@3bcf5e4aa575:/# ls -la /var/lib/postgresql/backup
total 16
drwxr-xr-x 2 root     root     4096 Feb 17 07:11 .
drwxr-xr-x 1 postgres postgres 4096 Feb 16 18:07 ..
-rw-r--r-- 1 root     root     5188 Feb 17 07:09 dump_db.dmp
```
Останавливаю первый контейнер:
```
[alexvk@archbox ~]$ docker stop some-postgres
some-postgres
```
Создаю новый контейнер some-postgres2, аттачу к нем том volume02 для бэкапа:
```
[alexvk@archbox ~]$ docker run --name some-postgres2 -e POSTGRES_PASSWORD=mysecret  -v volume02:/var/lib/postgresql/backup  -d postgres:12
cc1df166bf5ecadd712f64aed5994dbd403c70a9a16fbc78012d40cafea59676
```
Восстанавливаю всю структуру из дампа Postgresql:
```
[alexvk@archbox ~]$ docker exec -it some-postgres2 psql -f /var/lib/postgresql/backup/dump_all.dmp  -U postgres
SET
SET
SET
psql:/var/lib/postgresql/backup/dump_all.dmp:14: ERROR:  role "postgres" already exists
ALTER ROLE
CREATE ROLE
ALTER ROLE
CREATE ROLE
ALTER ROLE
You are now connected to database "template1" as user "postgres".
SET
SET
SET
SET
SET
 set_config 
------------
 
(1 row)

SET
SET
SET
SET
You are now connected to database "postgres" as user "postgres".
SET
SET
SET
SET
SET
 set_config 
------------
 
(1 row)

SET
SET
SET
SET
SET
SET
SET
SET
SET
 set_config 
------------
 
(1 row)

SET
SET
SET
SET
CREATE DATABASE
ALTER DATABASE
You are now connected to database "test_db" as user "postgres".
SET
SET
SET
SET
SET
 set_config 
------------
 
(1 row)

SET
SET
SET
SET
SET
SET
CREATE TABLE
ALTER TABLE
CREATE TABLE
ALTER TABLE
COPY 5
COPY 5
ALTER TABLE
ALTER TABLE
ALTER TABLE
GRANT
GRANT
GRANT
```
Проверяю наличие базы данных и пользователей:
```
[alexvk@archbox ~]$ docker exec -it some-postgres2 bash
root@cc1df166bf5e:/# psql -U postgres
psql (12.10 (Debian 12.10-1.pgdg110+1))
Type "help" for help.

postgres=# \l
                                     List of databases
   Name    |  Owner   | Encoding |  Collate   |   Ctype    |       Access privileges        
-----------+----------+----------+------------+------------+--------------------------------
 postgres  | postgres | UTF8     | en_US.utf8 | en_US.utf8 | 
 template0 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres                   +
           |          |          |            |            | postgres=CTc/postgres
 template1 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres                   +
           |          |          |            |            | postgres=CTc/postgres
 test_db   | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =Tc/postgres                  +
           |          |          |            |            | postgres=CTc/postgres         +
           |          |          |            |            | "test-admin-user"=CTc/postgres
(4 rows)

postgres=# \du
                                       List of roles
    Role name     |                         Attributes                         | Member of 
------------------+------------------------------------------------------------+-----------
 postgres         | Superuser, Create role, Create DB, Replication, Bypass RLS | {}
 test-admin-user  | Superuser, No inheritance                                  | {}
 test-simple-user | No inheritance                                             | {}

postgres=# \c test_db
You are now connected to database "test_db" as user "postgres".
test_db=# \dt
          List of relations
 Schema |  Name   | Type  |  Owner   
--------+---------+-------+----------
 public | clients | table | postgres
 public | orders  | table | postgres
(2 rows)
```
Все аналогично базе в первом контейнере some-postgres.  

**Краткое изложение команд для бэкапинга и ресторинга:**  
Бэкап всей структуры СУБД:
```
docker exec -it some-postgres pg_dumpall -U postgres -f /var/lib/postgresql/backup/dump_db.dmp
```
Восстановление копии структуры СУБД:
```
docker exec -it some-postgres2 psql -f /var/lib/postgresql/backup/dump_all.dmp  -U postgres
```
З.Ы. Важно не забыть примаунтить к контейнеру some-postgres2 том volume2, на котором хранится бэкап структуры СУБД.  
З.З.Ы. В боевых условиях совершенно необходимо через пайп запаковать дамп любым архиватором, а то никакого места может
не хватить.
