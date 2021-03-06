### Домашнее задание к занятию "6.6. Troubleshooting"

# Task 1
*Перед выполнением задания ознакомьтесь с документацией по администрированию MongoDB.*

*Пользователь (разработчик) написал в канал поддержки, что у него уже 3 минуты происходит CRUD операция в MongoDB и её нужно прервать.*

*Вы как инженер поддержки решили произвести данную операцию:*

* *напишите список операций, которые вы будете производить для остановки запроса пользователя*
* *предложите вариант решения проблемы с долгими (зависающими) запросами в MongoDB*

**Решение:**

Обращусь к документации. По прерыванию запроса нашел ссылку https://docs.mongodb.com/manual/tutorial/terminate-running-operations/ . Метод
db.killOp() подходит для выполнения задачи. Квотинг из документации: *The db.killOp() method interrupts a running operation at the next interrupt point. db.killOp() identifies the target operation by operation ID.*  
Таким образом, осталось только определить идентификатор операции. Для этого нужно просто немного подумать. Поскольку запрос зависший, то он выполняется в настоящее время. Поиск по документации дал https://docs.mongodb.com/manual/reference/method/db.currentOp/. Этим методом и можно  узнать идентификатор зависшего запроса.
Вкратце: узнаю ID запроса с помощью db.currentOp() и прерываю этот процесс по ID методом db.killOp().  
Чтобы решить проблему с зависающими запросами, нужно посоветовать разработчикам использовать индексы для ускорения поиска и дополнительно определить таймауты на запросы с помощью метода  maxTimeMS(n), где n - количество времени на запрос в миллисекундах. 

# Task 2

*Перед выполнением задания познакомьтесь с документацией по Redis latency troobleshooting.*

*Вы запустили инстанс Redis для использования совместно с сервисом, который использует механизм TTL. Причем отношение количества записанных key-value значений к количеству истёкших значений есть величина постоянная и увеличивается пропорционально количеству реплик сервиса.*

*При масштабировании сервиса до N реплик вы увидели, что:*

* *сначала рост отношения записанных значений к истекшим*
* *Redis блокирует операции записи*
*Как вы думаете, в чем может быть проблема?*

**Решение:**

Если бы сервис использовал ключи без определения времени их истечения, то можно было бы считать, что база данных не имеет достаточных ресурсов по оперативной памяти для своей работы. Но поскольку Redis по условию задачи использует ключи с определенным временем жизни (expire keys) и, как мне думается, время жизни ключей задано именно для экономии ресурсов. Тогда необходимо обратиться к разделу документации https://redis.io/commands/expire и выяснить механизм действия этого процесса.  
Документация сообщает, что при создании expire key для его хранения используется дополнительная память; по истечении срока хранения ключи автоматически удаляются.
В Redis 2.4 срок действия может быть не точным, и он может быть от нуля до одной секунды.
Начиная с Redis 2.6, ошибка истечения срока действия составляет от 0 до 1 миллисекунды.  
Существуют также два метода удаления ключа. Пассивный - ключ удаляется при попытке клиента обратиться к нему и сервер при это определяет, что время жизни ключа истекло, и активный - сервер перебирает 10 раз в секунду ключи случайным образом и выясняет, не истекли ли они. Если ключи истекли, то они удаляются. Если истекших ключей более 25%, то процесс повторяется вновь.  
Для реплик, чтобы получить корректное поведение БД без ущерба для согласованности, по истечении срока действия ключа операция DEL создается как в файле AOF мастера, так и на всех присоединенных узлах реплик. Таким образом, процесс истечения срока действия централизован в главном экземпляре, и вероятность ошибок согласованности отсутствует.  
Однако, хотя реплики, подключенные к мастеру, не будут удалять истекшие ключами самостоятельно (но будут ждать операции DEL, поступающей от мастера), они все равно будут получать полное состояние истекших ключей набора данных. Поэтому, когда реплика будет выбрана мастером, она сможет уничтожить истекшие ключи самостоятельно.  
В условии задачи также указан рост числа записанных значений к истекшим. Обратившись к документации по ссылке https://redis.io/topics/latency, измерим задержку сервера Redis и наверняка выясним, что из-за слишком большого количества реплик сетевые задержки возросли настолько, что мастер не успевает удалять ключи и синхронизировать данные с репликами.  
Таким образом, можно сделать вывод по задаче. Количество истекших значений превысило возможности  железа по выделению памяти, а сервер скорее всего был настроен на пассивное удаление ключей, т.е. по факту обращению к ним клиентов; а количество реплик превышает возможности мастера по их синхронизации. Необходимо оптимизировать конфигурацию мастер-инстанса Redis, чтобы удалять истекшие ключи активным образом, и уменьшать количество реплик. Экстенсивный путь решения проблемы предполагает апгрейд железа и увеличение пропускной способности сети путем перехода на 10GBASE либо использованием bonding.

# Task 3

*Перед выполнением задания познакомьтесь с документацией по Common Mysql errors.*

*Вы подняли базу данных MySQL для использования в гис-системе. При росте количества записей, в таблицах базы, пользователи начали жаловаться на ошибки вида:*

``InterfaceError: (InterfaceError) 2013: Lost connection to MySQL server during query u'SELECT..... '``

*Как вы думаете, почему это начало происходить и как локализовать проблему?*

*Какие пути решения данной проблемы вы можете предложить?*

**Решение:**

Эта проблема имеет место быть в случаях, описанных в документации по ссылке https://dev.mysql.com/doc/refman/8.0/en/error-lost-connection.html .  Существуют три наиболее вероятные причины появления этого сообщения об ошибке. Обычно это указывает на проблемы с сетевым подключением, и следует проверить состояние сети, если эта ошибка возникает часто. Если сообщение об ошибке содержит “during query”, вероятно, это тот самый случай.  
Иногда это сообщение об ошибке “во время запроса” возникает, когда миллионы строк отправляются как часть одного или нескольких запросов и мы ловим таймаут.  
Реже это может произойти, когда клиент пытается установить первоначальное соединение с сервером и время, выделенное на эту операцию слишком мало.  
В указанном в ДЗ случае проблема проявилась после роста количества записей в БД. Предлагаю увеличить значение параметра ``net_read_timeout`` (таймаут получения данных по сети), чтобы позволить клиенту все-таки дождаться запрошенных данных. Также проверить переменную ``max_connections`` и, возможно, поможет увеличение ее значения. И всегда помогает дополнительный объем оперативной памяти (не помешает точно).  
Разработчикам стоит указать на появление этой ошибки и необходимость построения индексов таблиц(ы) для ускорения исполнения запросов, а также разбить сами запросы на части так, чтобы не приходилось получать от сервера столь  большие объемы информации. По теме оптимизации есть хороший источник https://www.oreilly.com/library/view/high-performance-mysql/9780596101718/.   

# Task 4

*Перед выполнением задания ознакомтесь со статьей Common PostgreSQL errors из блога Percona.*

*Вы решили перевести гис-систему из задачи 3 на PostgreSQL, так как прочитали в документации, что эта СУБД работает с большим объемом данных лучше, чем MySQL.*

*После запуска пользователи начали жаловаться, что СУБД время от времени становится недоступной. В dmesg вы видите, что:*  
``postmaster invoked oom-killer``

*Как вы думаете, что происходит?*

*Как бы вы решили данную проблему?*

**Решение:**

Сообщение в логах буфера ядра, поэтому делаю вывод, что процесс oom-killer пытался спасти систему от недостатка оперативной памяти. В кажется жертвы был выбран   postmaster, cерверный процесс postgres (postmaster предназначен для многопользовательского окружения). В соответствии с документацией по ядру https://www.kernel.org/doc/gorman/html/understand/understand016.html, oom-killer определил "плохой" процесс по взвешенному значению его "вредности" для системы и уничтожил. Это плата за возможность для операционной системы остаться на плаву, если какой-процесс потребует чересчур много оперативной памяти и ее не останется для нужд самой ОС. 	
Неправильное решение проблемы - отключить oom-killer, тогда система может просто зависнуть. Для временного решения проблемы можно просто добавить ОЗУ (базы данных часто имеют тенденцию увеличиваться). Если это невозможно или нецелесообразно сделать, то лучше обратиться к документации https://www.postgresql.org/docs/14/kernel-resources.html , где подробно описаны шаги по решению вопроса.  
* sysctl -w vm.overcommit_memory=2 - не позволять приложениям занимать больше виртуальной памяти, чем доступно. Размер занимаемой памяти вычисляется как *total_swap* + *total_ram* * *overcommit_ratio* / *100*. В случае параметра "2" overcommit_ratio=100 и соответственно памяти выделится *total_swap+total_ram*. Это не уберет полностью вероятность запуска oom_killer, но снизит ее значительно.
* тонкая настройка System V IPC Parameters. Параметров много, все они требует вычислений и должны производиться искушенным в Postgres специалистом.  Остановлюсь на двух параметрах, это kernel.shmmax и kernel.shmall. Это размер оперативной памяти в байтах и  размер оперативной памяти в страницах с системным размером страниц по умолчанию. Необходимо задать эти параметры в соответствии с конфигурацией вашей системы.
* проверить и при необходимости изменить системные ограничения. В документации рекомендовано проверить параметры ``/proc/sys/fs/file-max``. Если возможности поменять значение параметра в ОС нет, нужно изменить системный параметр БД ``max_files_per_process``.
* sysctl -w vm.nr_hugepages=N - большие страницы уменьшают накладные расходы на память. N необходимо вычислить, используя несложные расчеты из документации.
* добавить ОЗУ будет всегда хорошим решением. 


