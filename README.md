# Task 1
*Проверьте список доступных сетевых интерфейсов на вашем компьютере. Какие команды есть для этого в Linux и в Windows?*  
Воспользуюсь утилитой ip из iprout2.  
```
[alexvk@archbox devops]$ ip l 
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN mode DEFAULT group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
2: enp2s0: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc fq_codel state DOWN mode DEFAULT group default qlen 1000
    link/ether 28:d2:44:b8:10:d0 brd ff:ff:ff:ff:ff:ff
3: wlp1s0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP mode DORMANT group default qlen 1000
    link/ether b0:10:41:2c:4f:8f brd ff:ff:ff:ff:ff:ff
```
ip l показывает состояние всех имеющихся в наличии сетевых интерфейсов и их параметры и состояние (лежит/поднят).  
Для староверов и просто для конформанса с остальными  Unix (GNU и не GNU, и BSD) используем ifconfig:
```
[alexvk@archbox Downloads]$ ifconfig  -a
enp2s0: flags=4099<UP,BROADCAST,MULTICAST>  mtu 1500
        ether 28:d2:44:b8:10:d0  txqueuelen 1000  (Ethernet)
        RX packets 0  bytes 0 (0.0 B)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 0  bytes 0 (0.0 B)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

lo: flags=73<UP,LOOPBACK,RUNNING>  mtu 65536
        inet 127.0.0.1  netmask 255.0.0.0
        inet6 ::1  prefixlen 128  scopeid 0x10<host>
        loop  txqueuelen 1000  (Local Loopback)
        RX packets 134  bytes 9098 (8.8 KiB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 134  bytes 9098 (8.8 KiB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

wlp1s0: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet 192.168.88.35  netmask 255.255.255.0  broadcast 192.168.88.255
        inet6 fe80::bc20:6932:74c8:143f  prefixlen 64  scopeid 0x20<link>
        ether b0:10:41:2c:4f:8f  txqueuelen 1000  (Ethernet)
        RX packets 148188  bytes 150979943 (143.9 MiB)
        RX errors 0  dropped 4257  overruns 0  frame 0
        TX packets 88420  bytes 25009206 (23.8 MiB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0
```
В Windows существует похожая утилита **ipconfig**. Аналогично *ifconfig* принимает опцию /all для отображения всех интерфейсов машины.  
Показать вывод не могу, Windows не имею.  

# Task 2
*Какой протокол используется для распознавания соседа по сетевому интерфейсу? Какой пакет и команды есть в Linux для этого?*  
Для распознавания соседа по интерфейсу используется протокол arp (address resolution protocol). Команда arp из пакета net-tools справляется 
с поставленной задачей. Либо для неофитов и исключительно пользователей GNU Linux - пакет iproute2 и соответственно ip:
```
[alexvk@archbox Downloads]$ ip neigh s
192.168.88.1 dev wlp1s0 lladdr b8:69:f4:fc:dd:f6 REACHABLE
```
Пример вывода arp-таблицы с домашнего роутера Mikrotik RB952Ui-5ac2nD:
```
[admin@MikroTik] /ip arp> print
Flags: X - disabled, I - invalid, H - DHCP, D - dynamic, P - published, C - complete 
 #    ADDRESS         MAC-ADDRESS       INTERFACE                                                                                                                                                                 
 0 DC 192.168.88.14   A0:28:ED:5D:43:4E bridge                                                                                                                                                                    
 1 DC 192.168.88.42   88:E9:FE:65:D4:12 bridge                                                                                                                                                                    
 2 DC 192.168.88.11   86:5E:D5:C9:BF:66 bridge                                                                                                                                                                    
 3 DC 192.168.88.22   28:64:B0:0B:94:24 bridge                                                                                                                                                                    
 4 DC 192.168.88.35   B0:10:41:2C:4F:8F bridge      
```
На практике еще часть применяется команда arping для того, чтобы узнать MAC-адрес интерфейса устройства по его IP адресу.  
В действии:  
```
[alexvk@archbox ~]$ sudo arping -c 1 192.168.88.14
ARPING 192.168.88.14 from 192.168.88.35 wlp1s0
Unicast reply from 192.168.88.14 [A0:28:ED:5D:43:4E]  122.448ms
Sent 1 probes (1 broadcast(s))
Received 1 response(s)
```

# Task 3

*Какая технология используется для разделения L2 коммутатора на несколько виртуальных сетей? Какой пакет и команды есть в Linux для этого? Приведите пример конфига.*  
Для разделения на виртуальные сети используется технология виртуальных меток на пакетах ethernet (VLAN). Пакеты метятся соответствующим номером сети (т.н. tag), и далее коммутатор
разбирает эти пакеты в соответствие со своими установками по различным портам. Пакеты в сетях, использующих VLAN, называются тегированными, соответственно не помеченные пакеты 
являются нетегированными.  
Давным-давно в GNU Linux для VLAN использовалась утилита vconfig. Но время шло, ее функционал перекочевал в пакет iproute2, и теперь VLAN управляется утилитой ip.  
Для примера учиним vlan за номером 42 на интерфейсе enp2s0. 
```
[alexvk@archbox ~]$ sudo ip link add link enp2s0 name enp2s0.42 type vlan id 42
 
```
Теперь посмотрю список интерфейсов.
```
[alexvk@archbox ~]$ ip l 
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN mode DEFAULT group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
2: enp2s0: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc fq_codel state DOWN mode DEFAULT group default qlen 1000
    link/ether 28:d2:44:b8:10:d0 brd ff:ff:ff:ff:ff:ff
3: wlp1s0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP mode DORMANT group default qlen 1000
    link/ether b0:10:41:2c:4f:8f brd ff:ff:ff:ff:ff:ff
6: enp2s0.42@enp2s0: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN mode DEFAULT group default qlen 1000
    link/ether 28:d2:44:b8:10:d0 brd ff:ff:ff:ff:ff:ff
```
Номер 6 - искомый VLAN интерфейс для получения тегированных пакетов для VLAN 42.  
Посмотрю расширенную информацию об интерфейсе:
```
[alexvk@archbox ~]$ ip -d link show enp2s0.42
6: enp2s0.42@enp2s0: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN mode DEFAULT group default qlen 1000
    link/ether 28:d2:44:b8:10:d0 brd ff:ff:ff:ff:ff:ff promiscuity 0 minmtu 0 maxmtu 65535 
    vlan protocol 802.1Q id 42 <REORDER_HDR> addrgenmode eui64 numtxqueues 1 numrxqueues 1 gso_max_size 64000 gso_max_segs 64 
```
Теперь назначу адрес на этот интерфейс:
```
[alexvk@archbox ~]$ sudo ip addr add 192.168.88.123/24 brd 192.168.100.255 dev enp2s0.42
```
Поднимаю интерфейс:
```
[alexvk@archbox ~]$ sudo ip link set dev enp2s0.42 up
```
Смотрю состояние интерфейса:
```
[alexvk@archbox ~]$ ip -d link show enp2s0.42
4: enp2s0.42@enp2s0: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc noqueue state LOWERLAYERDOWN mode DEFAULT group default qlen 1000
    link/ether 28:d2:44:b8:10:d0 brd ff:ff:ff:ff:ff:ff promiscuity 0 minmtu 0 maxmtu 65535 
    vlan protocol 802.1Q id 42 <REORDER_HDR> addrgenmode eui64 numtxqueues 1 numrxqueues 1 gso_max_size 64000 gso_max_segs 64 
```
Интерфейс с vlan id=42 готов к работе, осталось только вставить разъем RJ-45.  
Соответственно, если на вашем линукс-боксе есть пара интерфейсов, то можно организовать рутинг между VLAN и нетегированной сетью.  
Всего доступно 4094 VLAN (12 бит, 0 и 4095 не используем). Это теоретически. Практически же количество VLAN на порту зависит 
от типа используемого оборудования.  
Погашу интерфейс.  
```
[alexvk@archbox ~]$ sudo ip link set dev enp2s0.42 down
```
Удалю vlan.  
```
[alexvk@archbox ~]$ sudo ip link delete enp2s0.42
```
Для получения постоянной конфигурации необходимо использовать текстовые конфиги systemd в более-менее современных Linux системах, либо скрипты 
запуска rc.*  в системах SystemV, либо rc.net* в BSD.  

# Task 4
*Какие типы агрегации интерфейсов есть в Linux? Какие опции есть длягв балансировки нагрузки? Приведите пример конфига.*  
Для агрегации интерфейсов ядром Linux применяется модуль bonding. Агрегация конформатна стандарту IEEE 802.3ad. Существует множество
проприетарных протоколов, но они не являются предметов рассмотрения для Linux.  
Модуль ядра bonding всегда доступен в большинстве современных дистрибутивов и дополнительно требует для управления пакеты iproute2 и ifenslave.  
Согласно документации https://www.kernel.org/doc/Documentation/networking/bonding.txt, существуют следующие типы агрегации, предоставляемые этим модулем:  
* balance rr - round-robin (циклическая) политика; передача пакетов в последовательном порядке с первого доступного интерфейса до последнего;
* active-backup - один интерфейс в группе активен; если он выходит из строя, другой интерфейс группы берет на себя ответственность. Отказоустойчивое решение;
* balance-xor - передача выполняется по избирательному хэширующему алгоритму. Политика по умолчанию - простая ( MAC-адрес источника XOR с MAC-адресом получателя 
по модулю количества интерфейсов. Альтернативная схема политики может быть выбрана с помощью опции xmit_hash_policy;
* broadcast - передавать на всех интерфейсах. Эта схема обеспечивает отказоустойчивость;
* 802.3ad - IEEE 802.3ad агрегация. Создает группы агрегации, имеющие одинаковую скорость и дуплекс. Использует все интерфейсы в активной агрегации для выполнения
спецификаций 802.3ad. Выбор интерфейса для исходящего трафика осуществляется в соответствии с политикой хеширования передачи, которая может быть изменена с
простой политики XOR по умолчанию через xmit_hash_policy. Обратите внимание, что не все передают политики могут быть совместимы с 802.3ad, особенно в части
требований к неправильному порядку пакетов раздела 43.2.4 стандарта 802.3ad. Различные одноранговые реализации будут иметь разные допуски несоблюдения стандарта. 
Потребуется:
1. Поддержка Ethtool в базовых драйверах для информирования о скорости и дуплексе каждого интерфейса.
2. Коммутатор, поддерживающий динамическое агрегированное соединение IEEE 802.3ad. Для большинства коммутаторов потребуется определенная конфигурация  для включения
 режима 802.3ad.
* balance-tlb - адаптивная балансировка нагрузки при передаче; не требует специальных коммутаторов. Передача распределяется по всем интерфейсам для балансировки 
нагрузки, прием ведется активным интерфейсом. 
Потребуется:
1. Поддержка Ethtool в базовых драйверах для информирования о скорости и дуплексе каждого интерфейса.
* balance-alb - включает в себя подмножество balance-tlb, но распределяется не только исходящий трафик, а и входящий также балансируется. Не требует наличия
специальных коммутаторов. Поскольку прием траффика основан на ARP negotiation, драйверы интерфейсов должны уметь менять MAC адреса своих устройств.  
Потребуется:
1. Поддержка Ethtool в базовых драйверах для информирования о скорости и дуплексе каждого интерфейса.
2. Устройства, драйверы которых в состоянии изменять MAC адреса.  
Таким образом, для балансировки нагрузки можно использовать опции balance-alb и balance-tlb.  

Создам active backup bonding на двух интерфейсах для примера, поскольку это простой и удобный для экспериментов вариант.
```
[root@archbox ~]# ip link add bond0 type bond
[root@archbox ~]# ip link set bond0 type bond miimon 100 mode active-backup
[root@archbox ~]# ip link set enp2s0 down
[root@archbox ~]# ip link set enp2s0 master bond0
[root@archbox ~]# ip link set wlp1s0 down
[root@archbox ~]# ip link set wlp1s0 master bond0
[root@archbox ~]# ip link set bond0 up
```
На выходе имеется готовый интерфейс bond0.
```
[root@archbox ~]# ip l 
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN mode DEFAULT group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
2: enp2s0: <NO-CARRIER,BROADCAST,MULTICAST,SLAVE,UP> mtu 1500 qdisc fq_codel master bond0 state DOWN mode DEFAULT group default qlen 1000
    link/ether 12:45:22:ea:2a:56 brd ff:ff:ff:ff:ff:ff permaddr 28:d2:44:b8:10:d0
3: wlp1s0: <BROADCAST,MULTICAST,SLAVE,UP,LOWER_UP> mtu 1500 qdisc mq master bond0 state UP mode DORMANT group default qlen 1000
    link/ether 12:45:22:ea:2a:56 brd ff:ff:ff:ff:ff:ff permaddr b0:10:41:2c:4f:8f
4: bond0: <BROADCAST,MULTICAST,MASTER,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP mode DEFAULT group default qlen 1000
    link/ether 12:45:22:ea:2a:56 brd ff:ff:ff:ff:ff:ff
```
и файл bond0:
```
[root@archbox ~]# ls /proc/net/bonding/
bond0
```
Получу адрес через dhcp:
```
[root@archbox ~]# dhclient bond0
```
Проверю состояние интерфейсов:
```
[root@archbox ~]# ip a s
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host 
       valid_lft forever preferred_lft forever
2: enp2s0: <NO-CARRIER,BROADCAST,MULTICAST,SLAVE,UP> mtu 1500 qdisc fq_codel master bond0 state DOWN group default qlen 1000
    link/ether 12:45:22:ea:2a:56 brd ff:ff:ff:ff:ff:ff permaddr 28:d2:44:b8:10:d0
3: wlp1s0: <BROADCAST,MULTICAST,SLAVE,UP,LOWER_UP> mtu 1500 qdisc mq master bond0 state UP group default qlen 1000
    link/ether 12:45:22:ea:2a:56 brd ff:ff:ff:ff:ff:ff permaddr b0:10:41:2c:4f:8f
    inet 192.168.88.26/24 brd 192.168.88.255 scope global dynamic noprefixroute wlp1s0
       valid_lft 286sec preferred_lft 286sec
4: bond0: <BROADCAST,MULTICAST,MASTER,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default qlen 1000
    link/ether 12:45:22:ea:2a:56 brd ff:ff:ff:ff:ff:ff
    inet 192.168.88.26/24 brd 192.168.88.255 scope global bond0
       valid_lft forever preferred_lft forever
    inet6 fe80::1045:22ff:feea:2a56/64 scope link 
       valid_lft forever preferred_lft forever
```
Видно активный интерфейс и адрес группы. Задача решена.

# Task 5
*Сколько IP адресов в сети с маской /29 ? Сколько /29 подсетей можно получить из сети с маской /24. Приведите несколько примеров /29 подсетей внутри сети 10.10.10.0/24*  
1. Выполню простой арифметический подсчет. Маска подсети /29, то есть долой 29 бит из 32, остается 3 бита. Получаем 2^3 = 8. Первый адрес - адрес сети, не используется
для хостов. Последний - широковещательный, broadcast. На хосты остается **6** адресов.
2. В сети с маской /24 имеется 8 бит для адресации, в сети /29 - 3 бита. Очевидно, что **(2^8)/(2^3)=32** подсети имеют место быть по условию задачи.
3. Сеть 10.10.10.0/24 - частная сеть класса А. В соответствие с задачей п.2 можем разбить эту сеть на подсети:  10.10.10.0/29, 10.10.10.8/29, 10.10.10.16/29, 10.10.10.24/29 и так далее. 
Числовой ряд E=N+8, где N - последнее число в тетраде, для образования непересекающихся подмножеств в сети с маской 255.255.255.0.  

# Task 6
*Задача: вас попросили организовать стык между 2-мя организациями. Диапазоны 10.0.0.0/8, 172.16.0.0/12, 192.168.0.0/16 уже заняты. Из какой подсети допустимо взять частные IP адреса? 
Маску выберите из расчета максимум 40-50 хостов внутри подсети.*
В задании совершенно точно сформулировано требование о выделении частной подсети. Поскольку широко известные частные сети уже полностью заняты, обращусь к RFC6890.
В этом документе п.2.2.2 заявлено, что существует еще одна частная подсеть 100.64.0.0/10, предназначенная для shared address space. Воспользуюсь ею. 22 бита на хосты слишком
расточительно по условию задачи, поэтому для возьму подсеть из конца диапазона 10.127.255.0/26. 6 бит дает 2^6 хостов, итого 62 за вычетом сети и бродкаста.   
Если и это слишком расточительно, то можно организовать две подсети 10.127.255.0/27 и 10.127.255.32/28, что в сумме даст 30+14=44 хоста.  

# Task 7
*Как проверить ARP таблицу в Linux, Windows? Как очистить ARP кеш полностью? Как из ARP таблицы удалить только один нужный IP?*  
Для проверки таблицы ARP нужен пакет iproute2, и утилита ip сделает всю работу за вас. Старая школа воспользуется утилитой arp из пакета
net-tools.
```
[alexvk@archbox ~]$ arp -a -i wlp1s0
_gateway (192.168.88.1) at b8:69:f4:fc:dd:f6 [ether] on wlp1s0
```
Утилита ip.
```
[alexvk@archbox ~]$ ip neigh show dev wlp1s0
192.168.88.1 lladdr b8:69:f4:fc:dd:f6 REACHABLE
```
Для очистки всей таблицы arp:
```
[alexvk@archbox ~]$ sudo ip -s neigh flush all

*** Round 1, deleting 1 entries ***
*** Flush is complete after 1 round ***
```
К сожалению, утилита arp не позволяет очистить весь ARP кеш одним наскоком. Можно лишь попрактиковать поштучное удаление или написать небольшой 
скрипт на awk.  
 
В Windows, насколько я помню, также применяется утилита arp с ключом -a. Команда покажет таблицу ARP.  
Для очистки кеша ARP применяется команда ``netsh interface ip delete arpcache``.  
Для удаления определенного адреса из таблицы используется arp -d xxxx.xxxx.xxxx.xxxx, где последнее - IP адрес. Дополнительно можно указать,
на каком интерфейсе выполнить удаление адреса. С помощью утилиты ip удаление выполняется так:
```
[alexvk@archbox ~]$ sudo ip -s neigh del 192.168.88.1 dev wlp1s0
```

