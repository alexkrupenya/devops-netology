# Task 1

*Архитектор ПО решил проконсультироваться у вас, какой тип БД лучше выбрать для хранения определенных данных.*

*Он вам предоставил следующие типы сущностей, которые нужно будет хранить в БД:*

* *Электронные чеки в json виде*
* *Склады и автомобильные дороги для логистической компании*
* *Генеалогические деревья*
* *Кэш идентификаторов клиентов с ограниченным временем жизни для движка аутенфикации*
* *Отношения клиент-покупка для интернет-магазина*
* *Выберите подходящие типы СУБД для каждой сущности и объясните свой выбор.*

- Электронные чеки в json - это явное требование применять документоориентированную базу данных, оптимизированную именно
для таких случаев хранения;
- Склады и автодороги для логистов требуют применения базы данных графового типа, поскольку решение 
транспортной задачи методом графов красиво выглядит. Графовая БД является реализацией сетевой модели в виде графа.
- Кэш для иденфикаторов целесообразно строить на базе Nosql "ключ-значение", это быстро работает и не требует больших ресурсов, по принципу BASE.
- Генеалогические деревья логично строить в иерархической базе, поскольку имеется пара родителей, от которых
и идут вниз остальные связи.
- Клиент-покупка это реляционная БД, поскольку модель предполагает большое количество разнообразных связей между объектами.

# Task 2

*Вы создали распределенное высоконагруженное приложение и хотите классифицировать его согласно CAP-теореме. Какой классификации по CAP-теореме соответствует ваша система, если (каждый пункт - это отдельная реализация вашей системы и для каждого пункта надо привести классификацию):*

* *Данные записываются на все узлы с задержкой до часа (асинхронная запись)*
* *При сетевых сбоях, система может разделиться на 2 раздельных кластера*
* *Система может не прислать корректный ответ или сбросить соединение*
* *А согласно PACELC-теореме, как бы вы классифицировали данные реализации?* 

1. Данные записываются на все узлы с задержкой до часа (асинхронная запись): распространенный случай работы распределенных систем. Случай из практики, очень близкий к описанной задаче. Существует БД биллинга абонентов ТСОП, состоящая из мастер-сервера и 4 слейвов. Все работы по созданию, модификации и проверке данных абонентов ведутся на мастере, это большая и мощная машина. Слейвы используются в целях отказоустойчивости системы, расположены в разных сегементах корпоративной ЛВС и содержат данные с отставанием от мастера от 8 до 12 часов. При проведении ежемесячных расчетов с абонентами все расчеты выполняются на одном из слейвов (который прекращает синхронизацию с мастером и использует текущий "срез" данных). Это сделано для того, чтобы не загружать мастер ненужными операциями (мастер выполняет только лишь актуальные операции с текущими данными). Таким образом, все наши ноды доступны (available) и устойчивы к разделению (partition tolerance), поскольку они дадут ответ,  но не обязательно актуальными данными (no concistency). По CAP теореме это AP.     
2. При сетевых сбоях, система может разделиться на 2 раздельных кластера: рассмотрю систему из рабочей практики, описанную выше. Если потеряется связь с мастером по причине обрыва оптический линии очередными копателями, то слейвы все равно будут давать ответы на запросы - но неактуальными, несинхронизированными с мастером данными; мало того, ответы разных слейвов тоже могут быть разными (помним о паузах в синхронизации). Имеем распределенную систему по классификации CAP - AP.   
3. Система может не прислать корректный ответ или сбросить соединение: пример, приведенный выше, не подходит в данном случае. В этом случае наша распределенная система, потеряв связь между узлами, остановит обработку запросов к БД и будет либо сообщать об ошибке кластера (No cluster sync available или что-то в таком духе), либо вообще ничего не будет обрабатывать и сообщать, сбрасывая соединение. Считаем, что разделение системы (например, ошибки в конфигурировании ЛВС) привело к такому результату. Система не желает отдавать данные, не являющиеся достоверным и надежными с ее точки зрения. Такое поведение свойственно системам, которые ревностно следят за целостностью данных. Но раз при этом система все-таки что-то отвечает, то необходимо обратиться к точному определению  CAP теоремы для понимания доступности: *Availability: Every request receives a (non-error) response, without the guarantee that it contains the most recent write.* В качестве примера используем наш перенастроенный кластер, который будет теперь внимательно следить за целостностью данных в случае разделения системы. Если наш кластер при разделении начинает сообщать то, чего мы точно от него не ждём, то  вопрос с availability автоматически снимается с повестки. Для выполнения требования доступности мы должны получать ответ с необходимыми данными, пусть даже и неактуальными, а не ошибки и тем более не сброс соединения. В сухом остатке имеется CP - при разделении БД начинает следить за своей целостностью, жертвуя доступностью.  

Теорема PACELC это развитие теоремы CAP. Она гласит, что  в случае разделения сети **P** в распределённой компьютерной системе необходимо выбирать между доступностью **A** и согласованностью **C**, но даже если система работает нормально в отсутствии разделения **E**, необходим выбор между задержками **L** и согласованностью **C**. Алгоритмически теорема выглядит как IF P -> (C or A), ELSE (C or L).
По PACELC-теореме ответы на вопросы будут следующие:
1. Данные записываются на все узлы с задержкой до часа (асинхронная запись): вышеприведенный пример из п.1 ответа по теореме CAP демонстрирует, что система будет иметь доступные данные, но они будут не целостны (не синхронизированы) между узлами, и притом между синхронизацией данных существует серьезная пауза. Таким  образом, вывод - при разделении "P" система доступна "A", и при штатной работе иначе наблюдается задержка в синхронизации данных "L": PA/EL.
2. При сетевых сбоях, система может разделиться на 2 раздельных кластера: так же из пример п.2 ответа по теореме CAP - система доступна, но между синхронизацией данных может наблюдаться серьезная задержка, если вообще не полное прекращение синхронизации. Ноды же при этом отвечают в других сегментах сети и замечательно отдают запрошенные данные.   
Существует еще одно состояние - система разделена (P), но данные на мастере не обновлялись давно и они синхронизированы с остальными нодами. Тогда считаем такой частный случай PA/EC.  
В общем же случае, если мастер обновляет данные в базе и безуспешно пытается достучаться до остальных нод (или их части), имеет PA/EL (при разделении система доступна, но данные не целостны). При нормальной работе системы имеем случай из п.1, описанный выше.
3. Система может не прислать корректный ответ или сбросить соединение:  система **НЕ** доступна, поскольку она не обрабатывает запросы, и вместо данных сообщает об ошибках или вообще ничего не сообщает, но при этом целостность данных сохранена и после восстановления сетевого взаимодействия между нодами все должно заработать как ни в чем не бывало. Согласно теореме PACELC, доступность принесена в жертву богу целостности данных. По PACELC это  PС/EC.

# Task 3

*Могут ли в одной системе сочетаться принципы BASE и ACID? Почему?*


ACID(Atomicity, Consistency, Isolation, Durability)
Концепция ACID обеспечивает полную целостность и надежность системы.  
Концепция BASE обеспечивает высокую доступность и производительность системы.  
Свойства ACID означают, что после завершения транзакции ее данные непротиворечивы (технический жаргон: записи согласованы) и стабильны в памяти, куда  могут включаться  различные области и типы памяти.  
Концепция BASE (Basically Available, Soft State, Eventual Consistency) уже в своей аббревиатуре указывает на прерогативу доступности данных над их целостностью и состоянием системы.  
Обе модели созданы для разных целей и предоставляют разный подход к обработке данных.
Таким образом, отдельно взятую СУБД нельзя рассматривать как имеющую ACID+BASE концепцию, поскольку эти концепции противоречат друг другу.  

# Task 4

*Вам дали задачу написать системное решение, основой которого бы послужили:*

* *фиксация некоторых значений с временем жизни*
* *реакция на истечение таймаута*
*Вы слышали о key-value хранилище, которое имеет механизм Pub/Sub. Что это за система? Какие минусы выбора данной системы?*

Для решения задачи с такими требованиями хорошо подходит Redis. Дословный перевод из документации:

*SUBSCRIBE, UNSUBSCRIBE и PUBLISH реализуют парадигму обмена сообщениями Publish/Subscribe, где (цитируя Википедию) отправители (издатели) не запрограммированы на отправку своих сообщений конкретным получателям (подписчикам). Скорее, опубликованные сообщения классифицируются по каналам без знания того, какие (если есть) подписчики могут быть. Подписчики проявляют интерес к одному или нескольким каналам и получают только те сообщения, которые представляют интерес, не зная, какие (если есть) издатели существуют. Такое разделение издателей и подписчиков может обеспечить большую масштабируемость и более динамичную топологию сети.*

Также Redis умеет работать с таймаутами для хранимых значений. Также из документации:

*Redis и сроки действия: ключи с ограниченным сроком жизни. Прежде чем перейти к более сложным структурам данных, нам нужно обсудить еще одну функцию, которая работает независимо от типа значения и называется в Redis сроком действия. По сути, вы можете установить тайм-аут для ключа. Этот таймаут будет являться ограничителем времени жизни. Когда время жизни истекает, ключ автоматически уничтожается, точно так же, как если бы пользователь вызвал команду DEL с ключом.*

Несколько кратких сведений об истечении срока действия в Redis:

*Таймауты могут быть установлены как с точностью до секунд, так и с точностью до миллисекунд. Однако разрешение времени окончания всегда составляет 1 миллисекунду. Информация об истечении срока действия реплицируется и сохраняется на диске, время фактически все равно идет, даже если ваш сервер Redis находится в выключенном состоянии (это означает, что Redis сохраняет дату истечения срока действия ключа на диск).*

Минусы Redis:
- Лимиты памяти. Redis — это база данных в памяти, а это означает, что весь набор данных должен находиться в памяти (ОЗУ). Это может стоить дорого, если планируется иметь большие наборы данных;
- Необходимость постоянной синхронизации данных в ОЗУ и на диске (это делает системный вызов fsync()). Redis делает снапшоты данных для сохранения. При аварии Redis все данные, несинхронизированные с постоянной памятью, будут утеряны.
- Redis не имеет богатого языка запросов (типа SQL). Это не реляционная база, поэтому полнотекстовый поиск по ней сложен. Функции агрегации (типа суммирования) тоже отсутствуют, все возложено на пользовательское приложение. Индексы не поддерживаются ядром СУБД. В общем и целом, все выполняется только командами самого Redis.
- Безопасность. Имеется только базовые опции. Нет механизма назначения прав. Нет шифрования данных. Но указанное можно реализовать в другом программном слое.

Плюсы: Redis исключительно быстр. Просто его нужно правильно готовить и не ставить задачи использовать Redis там, где нужно использовать другие инструменты. 
