# Task 1

*Используя docker поднимите инстанс MySQL (версию 8). Данные БД сохраните в volume.*

*Изучите [бэкап БД](https://github.com/netology-code/virt-homeworks/tree/master/06-db-03-mysql/test_data) и 
восстановитесь из него.*

*Перейдите в управляющую консоль `mysql` внутри контейнера.*

*Используя команду `\h` получите список управляющих команд.*

*Найдите команду для выдачи статуса БД и **приведите в ответе** из ее вывода версию сервера БД.*

*Подключитесь к восстановленной БД и получите список таблиц из этой БД.*

*Приведите в ответе количество записей с `price` > 300.*

Решение:  
Загружаю образ с MySQL версии 8:
```
alexvk@archbox ~]$ docker volume list
DRIVER    VOLUME NAME
[alexvk@archbox ~]$ pwd
/home/alexvk
[alexvk@archbox ~]$ docker pull mysql:8
8: Pulling from library/mysql
[...skipped...]
Digest: sha256:e3358f55ea2b0cd432685d7e3c79a33a85c7a359b35fa87fc4993514b9573446
Status: Downloaded newer image for mysql:8
docker.io/library/mysql:8
```
Создаю том для хранения БД:
```
[alexvk@archbox ~]$ docker volume create volume00
volume00
```
Создаю контейнер с MySQL версии 8:
```
[alexvk@archbox ~]$ docker run --name some-mysql -e MYSQL_ROOT_PASSWORD=mysecret  -v volume00:/var/lib/mysql -d mysql:8
f8926cb22a159b6b0cd08426fe0e68c9e7cb5db55ecc0bfcbb0f8837a5eabcb0
```
Копирую дамп базы в контейнер и восстанавливаю БД из него:
```
[alexvk@archbox 06-db-03-mysql]$ docker cp test_data/test_dump.sql some-mysql:/root/.
[alexvk@archbox 06-db-03-mysql]$ docker exec -it some-mysql bash
root@f8926cb22a15:~# mysql -uroot -pmysecret test_db < test_dump.sql 
mysql: [Warning] Using a password on the command line interface can be insecure.
ERROR 1049 (42000): Unknown database 'test_db'
```
Не существует целевая БД. Подправлю sql скрипт, добавив в начало дампа строки:
```
CREATE DATABASE IF NOT EXISTS `test_db`;
USE `test_db`;
```
Повторю прогон скрипта после  редактирования:
```
root@f8926cb22a15:~# mysql -uroot -pmysecret < test_dump.sql 
mysql: [Warning] Using a password on the command line interface can be insecure.
```
Ошибок больше нет. Перехожу в CLI mysql:
```
root@f8926cb22a15:~# mysql -uroot -pmysecret
mysql: [Warning] Using a password on the command line interface can be insecure.
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 40
Server version: 8.0.28 MySQL Community Server - GPL

Copyright (c) 2000, 2022, Oracle and/or its affiliates.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql> 
```
Даю команду ``\h``:
```
mysql> \h

For information about MySQL products and services, visit:
   http://www.mysql.com/
For developer information, including the MySQL Reference Manual, visit:
   http://dev.mysql.com/
To buy MySQL Enterprise support, training, or other products, visit:
   https://shop.mysql.com/

List of all MySQL commands:
Note that all text commands must be first on line and end with ';'
?         (\?) Synonym for `help'.
clear     (\c) Clear the current input statement.
connect   (\r) Reconnect to the server. Optional arguments are db and host.
delimiter (\d) Set statement delimiter.
edit      (\e) Edit command with $EDITOR.
ego       (\G) Send command to mysql server, display result vertically.
exit      (\q) Exit mysql. Same as quit.
go        (\g) Send command to mysql server.
help      (\h) Display this help.
nopager   (\n) Disable pager, print to stdout.
notee     (\t) Don't write into outfile.
pager     (\P) Set PAGER [to_pager]. Print the query results via PAGER.
print     (\p) Print current command.
prompt    (\R) Change your mysql prompt.
quit      (\q) Quit mysql.
rehash    (\#) Rebuild completion hash.
source    (\.) Execute an SQL script file. Takes a file name as an argument.
status    (\s) Get status information from the server.
system    (\!) Execute a system shell command.
tee       (\T) Set outfile [to_outfile]. Append everything into given outfile.
use       (\u) Use another database. Takes database name as argument.
charset   (\C) Switch to another charset. Might be needed for processing binlog with multi-byte charsets.
warnings  (\W) Show warnings after every statement.
nowarning (\w) Don't show warnings after every statement.
resetconnection(\x) Clean session context.
query_attributes Sets string parameters (name1 value1 name2 value2 ...) for the next query to pick up.

For server side help, type 'help contents'
```
Команда получения статуса: ``\s``. Выполняю:
```
mysql> \s
--------------
mysql  Ver 8.0.28 for Linux on x86_64 (MySQL Community Server - GPL)

Connection id:		41
Current database:	
Current user:		root@localhost
SSL:			Not in use
Current pager:		stdout
Using outfile:		''
Using delimiter:	;
Server version:		8.0.28 MySQL Community Server - GPL
Protocol version:	10
Connection:		Localhost via UNIX socket
Server characterset:	utf8mb4
Db     characterset:	utf8mb4
Client characterset:	latin1
Conn.  characterset:	latin1
UNIX socket:		/var/run/mysqld/mysqld.sock
Binary data as:		Hexadecimal
Uptime:			1 hour 9 min 4 sec

Threads: 2  Questions: 93  Slow queries: 0  Opens: 172  Flush tables: 3  Open tables: 90  Queries per second avg: 0.022
--------------
```
Подлючаюсь к восстановленной БД и получаю список таблиц:
```
mysql> use test_db;
Reading table information for completion of table and column names
You can turn off this feature to get a quicker startup with -A

Database changed
mysql> show tables;
+-------------------+
| Tables_in_test_db |
+-------------------+
| orders            |
+-------------------+
1 row in set (0.00 sec)
```
Количество записей с price > 300:
```
mysql> SELECT COUNT(*) FROM orders WHERE price > 300;
+----------+
| COUNT(*) |
+----------+
|        1 |
+----------+
1 row in set (0.00 sec)
```

# Task 2

*Создайте пользователя test в БД c паролем test-pass, используя:*

* *плагин авторизации mysql_native_password*
* *срок истечения пароля - 180 дней*
* *количество попыток авторизации - 3*
* *максимальное количество запросов в час - 100*
* *аттрибуты пользователя:*
* -*Фамилия "Pretty"*
* -*Имя "James"*
* *Предоставьте привелегии пользователю test на операции SELECT базы test_db.*

*Используя таблицу INFORMATION_SCHEMA.USER_ATTRIBUTES получите данные по пользователю test и приведите в ответе к задаче.*

Решение:  
Создам пользователя по заданию. Документация по ссылке https://dev.mysql.com/doc/refman/8.0/en/create-user.html подробно сообщает, как это сделать.
Запрос выглядит так:
```
mysql> CREATE USER 'test'@'localhost'
    ->   IDENTIFIED WITH mysql_native_password BY 'test-pass'
    ->   WITH MAX_QUERIES_PER_HOUR 100
    ->   PASSWORD EXPIRE INTERVAL 180 DAY
    ->   FAILED_LOGIN_ATTEMPTS 3 PASSWORD_LOCK_TIME 2
    ->   ATTRIBUTE '{"fname":"James", "lname":"Pretty"}';
Query OK, 0 rows affected (0.01 sec)
```
Даю права пользователю test на SELECT-ы в базе test_db (https://dev.mysql.com/doc/refman/8.0/en/grant.html):
```
mysql> GRANT SELECT ON test_db.* TO 'test'@'localhost';
Query OK, 0 rows affected, 1 warning (0.01 sec)
```
Выборка из INFORMATION_SCHEMA.USER_ATTRIBUTES по пользователю test:
```
mysql> SELECT * FROM INFORMATION_SCHEMA.USER_ATTRIBUTES WHERE USER='test';
+------+-----------+---------------------------------------+
| USER | HOST      | ATTRIBUTE                             |
+------+-----------+---------------------------------------+
| test | localhost | {"fname": "James", "lname": "Pretty"} |
+------+-----------+---------------------------------------+
1 row in set (0.00 sec)
```

# Task 3

*Установите профилирование SET profiling = 1. Изучите вывод профилирования команд SHOW PROFILES;.*

*Исследуйте, какой engine используется в таблице БД test_db и приведите в ответе.*

*Измените engine и приведите время выполнения и запрос на изменения из профайлера в ответе:*

* *на MyISAM*
* *на InnoDB*

Решение:  
Устанавливаю SET profiling=1; далее:
```
mysql> SHOW PROFILES;
+----------+------------+---------------------------------------------------------------------------------------------------------------------+
| Query_ID | Duration   | Query                                                                                                               |
+----------+------------+---------------------------------------------------------------------------------------------------------------------+
|        1 | 0.00030800 | use mysql'                                                                                                          |
|        2 | 0.00045750 | SELECT DATABASE()                                                                                                   |
|        3 | 0.00221100 | show databases                                                                                                      |
|        4 | 0.00759725 | show tables                                                                                                         |
|        5 | 0.00046725 | SET PROFILING=1                                                                                                     |
|        6 | 0.00047025 | SELECT DATABASE()                                                                                                   |
|        7 | 0.00219050 | show databases                                                                                                      |
|        8 | 0.00393975 | show tables                                                                                                         |
|        9 | 0.00045150 | SET PROFILING=1                                                                                                     |
|       10 | 0.00050650 | select DATABASE(), USER() limit 1                                                                                   |
|       11 | 0.00043725 | select @@character_set_client, @@character_set_connection, @@character_set_server, @@character_set_database limit 1 |
|       12 | 0.00237375 | show databases                                                                                                      |
|       13 | 0.00405800 | show tables                                                                                                         |
|       14 | 0.00096925 | select user from mysql.user                                                                                         |
+----------+------------+---------------------------------------------------------------------------------------------------------------------+
14 rows in set, 1 warning (0.00 sec)
```
Получаю список запросов и длительность их выполнения. Можно посмотреть статистику по запросам отдельно, например по запросу 11:
```
mysql> SHOW PROFILE FOR query 11;
+----------------------+----------+
| Status               | Duration |
+----------------------+----------+
| starting             | 0.000204 |
| checking permissions | 0.000018 |
| Opening tables       | 0.000026 |
| init                 | 0.000017 |
| optimizing           | 0.000021 |
| executing            | 0.000039 |
| end                  | 0.000013 |
| query end            | 0.000014 |
| closing tables       | 0.000012 |
| freeing items        | 0.000044 |
| cleaning up          | 0.000033 |
+----------------------+----------+
11 rows in set, 1 warning (0.00 sec)
```
Тот же запрос, загрузка CPU:
```
mysql> SHOW PROFILE CPU FOR query 11;
+----------------------+----------+----------+------------+
| Status               | Duration | CPU_user | CPU_system |
+----------------------+----------+----------+------------+
| starting             | 0.000204 | 0.000000 |   0.000158 |
| checking permissions | 0.000018 | 0.000000 |   0.000017 |
| Opening tables       | 0.000026 | 0.000000 |   0.000027 |
| init                 | 0.000017 | 0.000000 |   0.000016 |
| optimizing           | 0.000021 | 0.000000 |   0.000021 |
| executing            | 0.000039 | 0.000000 |   0.000039 |
| end                  | 0.000013 | 0.000000 |   0.000012 |
| query end            | 0.000014 | 0.000000 |   0.000013 |
| closing tables       | 0.000012 | 0.000000 |   0.000012 |
| freeing items        | 0.000044 | 0.000000 |   0.000044 |
| cleaning up          | 0.000033 | 0.000000 |   0.000032 |
+----------------------+----------+----------+------------+
11 rows in set, 1 warning (0.00 sec)
```
И тому подобное. Подробнее в документации по ссылке https://dev.mysql.com/doc/refman/8.0/en/show-profile.html .  

Используемые engines можно посмотреть так:
```
mysql> SELECT * FROM INFORMATION_SCHEMA.ENGINES;
+--------------------+---------+----------------------------------------------------------------+--------------+------+------------+
| ENGINE             | SUPPORT | COMMENT                                                        | TRANSACTIONS | XA   | SAVEPOINTS |
+--------------------+---------+----------------------------------------------------------------+--------------+------+------------+
| FEDERATED          | NO      | Federated MySQL storage engine                                 | NULL         | NULL | NULL       |
| MEMORY             | YES     | Hash based, stored in memory, useful for temporary tables      | NO           | NO   | NO         |
| InnoDB             | DEFAULT | Supports transactions, row-level locking, and foreign keys     | YES          | YES  | YES        |
| PERFORMANCE_SCHEMA | YES     | Performance Schema                                             | NO           | NO   | NO         |
| MyISAM             | YES     | MyISAM storage engine                                          | NO           | NO   | NO         |
| MRG_MYISAM         | YES     | Collection of identical MyISAM tables                          | NO           | NO   | NO         |
| BLACKHOLE          | YES     | /dev/null storage engine (anything you write to it disappears) | NO           | NO   | NO         |
| CSV                | YES     | CSV storage engine                                             | NO           | NO   | NO         |
| ARCHIVE            | YES     | Archive storage engine                                         | NO           | NO   | NO         |
+--------------------+---------+----------------------------------------------------------------+--------------+------+------------+
9 rows in set (0.00 sec)
```
Либо командой ``SHOW ENGINES;`` . Полезное чтение по этому заданию https://dev.mysql.com/doc/refman/8.0/en/information-schema.html .  
Выясню, какой движок используется для таблицы orders в БД test_db. Для этого сделаю запрос по таблице information_schema.tables:
```
mysql> SELECT * FROM information_schema.tables table_schema = 'test_db'\G
*************************** 1. row ***************************
  TABLE_CATALOG: def
   TABLE_SCHEMA: test_db
     TABLE_NAME: orders
     TABLE_TYPE: BASE TABLE
         ENGINE: InnoDB
        VERSION: 10
     ROW_FORMAT: Dynamic
     TABLE_ROWS: 5
 AVG_ROW_LENGTH: 3276
    DATA_LENGTH: 16384
MAX_DATA_LENGTH: 0
   INDEX_LENGTH: 0
      DATA_FREE: 0
 AUTO_INCREMENT: 6
    CREATE_TIME: 2022-02-22 09:24:56
    UPDATE_TIME: 2022-02-22 09:24:56
     CHECK_TIME: NULL
TABLE_COLLATION: utf8mb4_0900_ai_ci
       CHECKSUM: NULL
 CREATE_OPTIONS: 
  TABLE_COMMENT: 
1 row in set (0.00 sec)
```
В таблице одна строка, поэтому вывод такого вида наиболее удобен. Поле ENGINE = InnoDB, движок таблицы теперь известен.
```
mysql> ALTER TABLE orders engine = MyISAM;
Query OK, 5 rows affected (0.04 sec)
Records: 5  Duplicates: 0  Warnings: 0

mysql> ALTER TABLE orders engine = InnoDB;
Query OK, 5 rows affected (0.04 sec)
Records: 5  Duplicates: 0  Warnings: 0

mysql> show profiles;
+----------+------------+------------------------------------+
| Query_ID | Duration   | Query                              |
+----------+------------+------------------------------------+
|        1 | 0.04124800 | ALTER TABLE orders engine = MyISAM |
|        2 | 0.03891050 | ALTER TABLE orders engine = InnoDB |
+----------+------------+------------------------------------+
2 rows in set, 1 warning (0.00 sec)
```
Переход с InnoDB на MyISAM занял ~0.04 сек., обратно на InnoDB переход занял ~0.039 сек.

# Task 4

*Изучите файл my.cnf в директории /etc/mysql.*

*Измените его согласно ТЗ (движок InnoDB):*

* *Скорость IO важнее сохранности данных*
* *Нужна компрессия таблиц для экономии места на диске*
* *Размер буффера с незакомиченными транзакциями 1 Мб*
* *Буффер кеширования 30% от ОЗУ*
* *Размер файла логов операций 100 Мб*

*Приведите в ответе измененный файл my.cnf.*

Решение:  
По поводу конфиг-файлов было полезно прочитать https://dev.mysql.com/doc/refman/8.0/en/option-files.html .  
Команда ``show variables`` покажет значения системных параметров сервера mysqld.  
* По скорости I/O https://dev.mysql.com/doc/refman/8.0/en/innodb-parameters.html#sysvar_innodb_flush_log_at_trx_commit .  
Таким образом,переменную innodb_flush_log_at_trx_commit устанавливаю равной 0, тогда логи транзакций будут записываться на диск каждую секунду. База
становится не ACID-compaint. Если установить эту переменную равной 1, то логи будут записываться после каждой транзакции (full ACID-compaint). 
Дополнительно можно установить переменную innodb_flush_log_at_timeout, которая контролирует частоту записи лог-файлов.
* Сжатие таблиц описано по ссылке https://dev.mysql.com/doc/refman/8.0/en/innodb-compression-usage.html . Для сжатия необходимо установить параметр innodb_file_per_table в состояние "ON". После этого указать параметр ROW_FORMAT=COMPRESSED, или KEY_BLOCK_SIZE условие, или оба вместе, при создании или изменении таблицы инструкциями  CREATE TABLE or ALTER TABLE в табличном пространстве типа файл-на-таблицу. В ТЗ не указано, какое именно пространство используется, general или file-per-table, потому ограничусь последним.

```
mysql> show variables like '%file_per_table%';
+-----------------------+-------+
| Variable_name         | Value |
+-----------------------+-------+
| innodb_file_per_table | ON    |
+-----------------------+-------+
1 row in set (0.01 sec)
```
* По аналогии с п.1 в списке системных переменных найден ответственный за размер буфера логов не прошедших commit транзакций, это https://dev.mysql.com/doc/refman/8.0/en/innodb-parameters.html#sysvar_innodb_log_buffer_size . Устанавливается параметр innodb_log_buffer_size. 
* Размер буфера кеширования данных и индексов регулируется переменной innodb_buffer_pool_size. Переменную можно менять динамически. Поскольку эта  переменная принимает абсолютные значения, то придется вычислять 30% RAM самостоятельно. При доступной 1G имеем примерно 384М.
* Логи операций innodb_log_file_size. Логов всегда два, поэтому дискового пространства будет занято минимум вдвое больше. 
Документация по ссылке https://dev.mysql.com/doc/refman/8.0/en/innodb-parameters.html#sysvar_innodb_buffer_pool_size .  
Вид файла **my.cnf** после изменения:
```
[mysqld]
pid-file        = /var/run/mysqld/mysqld.pid
socket          = /var/run/mysqld/mysqld.sock
datadir         = /var/lib/mysql
secure-file-priv= NULL
#
#Custom config should go here
#!includedir /etc/mysql/conf.d/
#
###Customizing
# Make I/O fast
innodb_flush_log_at_trx_commit=0
#
# Compress tables (file_per_table parameter)
innodb_file_per_table=ON
#
# Set uncommited transactions log buffer to 1M
innodb_log_buffer_size=1M
#
# Set data and index cache to 30 percent of available RAM
innodb_buffer_pool_size=384M
#
# Set logs filesize to 100M
innodb_log_file_size=100M
```
