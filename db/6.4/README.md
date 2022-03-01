# Task 1

*Используя docker поднимите инстанс PostgreSQL (версию 13). Данные БД сохраните в volume.*

*Подключитесь к БД PostgreSQL используя psql.*

*Воспользуйтесь командой \? для вывода подсказки по имеющимся в psql управляющим командам.*

*Найдите и приведите управляющие команды для:*

* *вывода списка БД*
* *подключения к БД*
* *вывода списка таблиц*
* *вывода описания содержимого таблиц*
* *выхода из psql*

Решение:  
Забираю образ для докера с версией Postgres 13.
```
[alexvk@archbox ~]$ docker pull postgres:13
13: Pulling from library/postgres
[...skipped]
Digest: sha256:8b8ff4fcdc9442d8a1d38bd1a77acbdfbc8a04afda9c19df47383cb2d08fc04b
Status: Downloaded newer image for postgres:13
docker.io/library/postgres:13
```
Создаю том для Postgres с дефолтным расположением:
```
[alexvk@archbox ~]$ docker volume create volume00
volume00
```
Создаю контейнер с сервером Postgres ver.13:
```
[alexvk@archbox ~]$ docker run --name some-postgres13 -e POSTGRES_PASSWORD=mysecret -v volume00:/var/lib/postgresql/data -d postgres:13
bbe8ebc9320999b636be481310c40124ee666c0b23edb0ca22081018e9df5c3d
```
Подключаюсь к контейнеру и просматриваю содержимое:
```
[alexvk@archbox ~]$ docker exec -it some-postgres13 bash
root@bbe8ebc93209:/# psql -U postgres
psql (13.6 (Debian 13.6-1.pgdg110+1))
Type "help" for help.

postgres=# 
```
Вывод подсказок:
```
postgres=# \?
General
  \copyright             show PostgreSQL usage and distribution terms
  \crosstabview [COLUMNS] execute query and display results in crosstab
  \errverbose            show most recent error message at maximum verbosity
  \g [(OPTIONS)] [FILE]  execute query (and send results to file or |pipe);
                         \g with no arguments is equivalent to a semicolon
  \gdesc                 describe result of query, without executing it
  \gexec                 execute query, then execute each value in its result
  \gset [PREFIX]         execute query and store results in psql variables
  \gx [(OPTIONS)] [FILE] as \g, but forces expanded output mode
  \q                     quit psql
  \watch [SEC]           execute query every SEC seconds
[...skipped...]
```
Вывод списка баз данных:
```
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

```
Команда для подключения к БД:
```
Connection
  \c[onnect] {[DBNAME|- USER|- HOST|- PORT|-] | conninfo}
                         connect to new database (currently "postgres")
```
Подключусь к текущей БД заново:
```
postgres=# \c postgres
You are now connected to database "postgres" as user "postgres".
```
Для вывода таблиц воспользуюсь командой \dt из help:
```
postgres=# \dt
Did not find any relations.
```
Поскольку таблицы базы postgres являются служебными, необходимо просматриваться их командой \dtS:
```
postgres=# \dtS
                    List of relations
   Schema   |          Name           | Type  |  Owner   
------------+-------------------------+-------+----------
 pg_catalog | pg_aggregate            | table | postgres
 pg_catalog | pg_am                   | table | postgres
 pg_catalog | pg_amop                 | table | postgres
 pg_catalog | pg_amproc               | table | postgres
 pg_catalog | pg_attrdef              | table | postgres
 pg_catalog | pg_attribute            | table | postgres
\[...skipped...]
```
Для просмотра описания содержимого таблиц воспользуюсь командой ``\d[S+] list tables, views, and sequences``.  
Для примера просмотрю служебную талицу pg_user:
```
postgres=# \dS+ pg_user;
                                     View "pg_catalog.pg_user"
    Column    |           Type           | Collation | Nullable | Default | Storage  | Description 
--------------+--------------------------+-----------+----------+---------+----------+-------------
 usename      | name                     |           |          |         | plain    | 
 usesysid     | oid                      |           |          |         | plain    | 
 usecreatedb  | boolean                  |           |          |         | plain    | 
 usesuper     | boolean                  |           |          |         | plain    | 
 userepl      | boolean                  |           |          |         | plain    | 
 usebypassrls | boolean                  |           |          |         | plain    | 
 passwd       | text                     |           |          |         | extended | 
 valuntil     | timestamp with time zone |           |          |         | plain    | 
 useconfig    | text[]                   | C         |          |         | extended | 
View definition:
 SELECT pg_shadow.usename,
    pg_shadow.usesysid,
    pg_shadow.usecreatedb,
    pg_shadow.usesuper,
    pg_shadow.userepl,
    pg_shadow.usebypassrls,
    '********'::text AS passwd,
    pg_shadow.valuntil,
    pg_shadow.useconfig
   FROM pg_shadow;
```
Для выхода для psql использую ``\q``:
```
postgres=# \q
root@bbe8ebc93209:/# 
```

# Task 2

*Используя psql создайте БД test_database.*

*Изучите бэкап БД.*

*Восстановите бэкап БД в test_database.*

*Перейдите в управляющую консоль psql внутри контейнера.*

*Подключитесь к восстановленной БД и проведите операцию ANALYZE для сбора статистики по таблице.*

*Используя таблицу pg_stats, найдите столбец таблицы orders с наибольшим средним значением размера элементов в байтах.*

*Приведите в ответе команду, которую вы использовали для вычисления и полученный результат.*

Решение:  
Создаю базу данных test_database:
```
postgres=# CREATE DATABASE test_database;
CREATE DATABASE
postgres=# 
```
Восстанавливаю данные из бэкапа в test_database:
```
[alexvk@archbox test_data]$ cp  test_dump.sql some-postgres13:/root/
[alexvk@archbox test_data]$ docker exec -it some-postgres13  bash
root@bbe8ebc93209:~# psql -U postgres -f /root/test_dump.sql -d test_database
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
CREATE SEQUENCE
ALTER TABLE
ALTER SEQUENCE
ALTER TABLE
COPY 8
 setval 
--------
      8
(1 row)

ALTER TABLE
```
Проверяю наличие БД:
```
postgres=# \l test_database
                                 List of databases
     Name      |  Owner   | Encoding |  Collate   |   Ctype    | Access privileges 
---------------+----------+----------+------------+------------+-------------------
 test_database | postgres | UTF8     | en_US.utf8 | en_US.utf8 | 
(1 row)
```
Подключаюсь к БД и просматриваю содержимое:
```
test_database=# \c test_database 
You are now connected to database "test_database" as user "postgres".
test_database=# \dt
         List of relations
 Schema |  Name  | Type  |  Owner   
--------+--------+-------+----------
 public | orders | table | postgres
(1 row)

test_database=# SELECT * FROM orders;
 id |        title         | price 
----+----------------------+-------
  1 | War and peace        |   100
  2 | My little database   |   500
  3 | Adventure psql time  |   300
  4 | Server gravity falls |   300
  5 | Log gossips          |   123
  6 | WAL never lies       |   900
  7 | Me and my bash-pet   |   499
  8 | Dbiezdmin            |   501
(8 rows)
```
Просмотрю статистику по таблице orders:
```
test_database=# ANALYZE VERBOSE orders;
INFO:  analyzing "public.orders"
INFO:  "orders": scanned 1 of 1 pages, containing 8 live rows and 0 dead rows; 8 rows in sample, 8 estimated total rows
ANALYZE
```
Используя таблицу pg_stats, найдите столбец таблицы orders с наибольшим средним значением размера элементов в байтах.
```
test_database=# \dS pg_stats;
                     View "pg_catalog.pg_stats"
         Column         |   Type   | Collation | Nullable | Default 
------------------------+----------+-----------+----------+---------
 schemaname             | name     |           |          | 
 tablename              | name     |           |          | 
 attname                | name     |           |          | 
 inherited              | boolean  |           |          | 
 null_frac              | real     |           |          | 
 avg_width              | integer  |           |          | 
 n_distinct             | real     |           |          | 
 most_common_vals       | anyarray |           |          | 
 most_common_freqs      | real[]   |           |          | 
 histogram_bounds       | anyarray |           |          | 
 correlation            | real     |           |          | 
 most_common_elems      | anyarray |           |          | 
 most_common_elem_freqs | real[]   |           |          | 
 elem_count_histogram   | real[]   |           |          | 
```
Для решения задачи необходимо выполнить запрос по полю avg_width и tablename:
```
test_database=# SELECT avg_width FROM pg_stats WHERE tablename='orders';
 avg_width 
-----------
         4
        16
         4
(3 rows)
```
По результату выполнения запроса видно, что столбец таблицы orders с наибольшим средним значением размера элементов в байтах - это второй столбец title.

# Task 3

*Архитектор и администратор БД выяснили, что ваша таблица orders разрослась до невиданных размеров и поиск по ней занимает долгое время. Вам, как успешному выпускнику курсов DevOps в нетологии предложили провести разбиение таблицы на 2 (шардировать на orders_1 - price>499 и orders_2 - price<=499).*

*Предложите SQL-транзакцию для проведения данной операции.*

*Можно ли было изначально исключить "ручное" разбиение при проектировании таблицы orders?*

Решение:
Для выполнения задачи разбиения таблицы необходимо обратиться к документации по ссылке https://www.postgresql.org/docs/10/ddl-partitioning.html .  
Партиционированная таблица будет заполняться на основе значения ключа партиции. Каждая партиция имеет подмножество данных, определенных границами раздела. На текущий момент граничными значениями могут служить диапазон либо список.  
Для создания собственной партиционированной таблицы можно воспользоваться примером 5.10.2.1. из документации.  
По задаче требуется партиционировать уже существующую таблицу. Необходимо ее сперва переименовать, чтобы создать новую таблицу 'orders' по заданию.
```
test_database=# ALTER TABLE orders RENAME TO orders_backup;
ALTER TABLE
```
Создаю таблицу по заданию, разделение осуществляется по полю price (параметры таблицы беру из дампа базы):
```
test_database=# CREATE TABLE orders (
    id integer NOT NULL,
    title character varying(80) NOT NULL,
    price integer DEFAULT 0
    ) partition by range(price) ;
```
Листинг таблиц:
```
test_database=# \dt
                   List of relations
 Schema |     Name      |       Type        |  Owner   
--------+---------------+-------------------+----------
 public | orders        | partitioned table | postgres
 public | orders_backup | table             | postgres
(2 rows)
```
Создаю отдельные таблицы согласно условию задачи:
```
test_database=# CREATE TABLE orders_1 PARTITION OF orders FOR VALUES FROM (500) TO (2147483647);
CREATE TABLE
test_database=# CREATE TABLE orders_2 PARTITION OF orders FOR VALUES FROM (0) TO (500);
CREATE TABLE
```
После создания раздельных таблиц и партиционированной общей таблицы orders необходимо скопировать данные во вновь созданную
таблицу из архивной.
```
test_database=# INSERT INTO orders SELECT * FROM orders_backup ;
INSERT 0 8
test_database=# select * from orders;
 id |        title         | price 
----+----------------------+-------
  1 | War and peace        |   100
  3 | Adventure psql time  |   300
  4 | Server gravity falls |   300
  5 | Log gossips          |   123
  7 | Me and my bash-pet   |   499
  2 | My little database   |   500
  6 | WAL never lies       |   900
  8 | Dbiezdmin            |   501
(8 rows)

test_database=# select * from orders_1;
 id |       title        | price 
----+--------------------+-------
  2 | My little database |   500
  6 | WAL never lies     |   900
  8 | Dbiezdmin          |   501
(3 rows)

test_database=# select * from orders_2;
 id |        title         | price 
----+----------------------+-------
  1 | War and peace        |   100
  3 | Adventure psql time  |   300
  4 | Server gravity falls |   300
  5 | Log gossips          |   123
  7 | Me and my bash-pet   |   499
(5 rows)
```
Задача выполнена. Можно уничтожать таблицу бэкапа.  
Ручного переноса данных и разбиения таблиц можно было бы избежать, если сразу создавать таблицу партиционированной. Набор партиций можно изменять, удаляя ненужные либо добавляя новые; именно на этапе проектирования базы лучше решать, стоит ли делать таблицы партиционированными. Если таблицы будут велики по объему (хотя бы в пределах ОЗУ сервера), то секционирование уже однозначно стоит делать.

# Task 4

*Используя утилиту pg_dump создайте бекап БД test_database.*

*Как бы вы доработали бэкап-файл, чтобы добавить уникальность значения столбца title для таблиц test_database?*

Решение:
Для создания дампа базы данных используется утилита pg_dump. Создаю бэкап базы:
```
root@bbe8ebc93209:~# pg_dump -U postgres -d test_database > test_database_dump.sql
root@bbe8ebc93209:~# cat test_database_dump.sql 
--
-- PostgreSQL database dump
--

-- Dumped from database version 13.6 (Debian 13.6-1.pgdg110+1)
-- Dumped by pg_dump version 13.6 (Debian 13.6-1.pgdg110+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
[...skipped...]
```
Для добавления уникальности значению столбца title таблицы orders можно использовать ограничивающее свойство UNIQUE. Для
этого в дамп базы можно добавить приведенную здесь строку:   
``ALTER TABLE orders ADD CONSTRAINT uniq_title UNIQUE (title);``
