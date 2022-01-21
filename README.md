# Task 1
* *Опишите своими словами основные преимущества применения на практике IaaC паттернов.*
* *Какой из принципов IaaC является основополагающим?*

* Основными преимуществами паттерна IaaC являются:
1. Автоматизация  развертывания и настройки исполняемых сред, включая: сети, виртаульные машины,
баласировщики нагрузки и другие необходимые сервисы; это приводит к ускорению процессов и экономит
финансовые и человеческие ресурсы.
2. Уверенность в получении результата, поскольку конфигурация инфраструктуры детально описана и 
всегда известна.
3. Интегрированность в процессы производства кода, поскольку методология IaaC подразумевает тот же код 
для описания инфраструктуры.
4. Стандартизация всех происходящих процессов. Команды разработчиков и тестировщиков могут быть уверены,
 что все идет по утвержденному сценарию.
5. Возможность проверять код описания инфраструктуры валидатором и выявлять синтаксические и семантические 
ошибки.
6. Безопасность, поскольку имеется читабельный человеком код  и этот код можно ревьюить.
7. Удобно вносить изменения в инфраструктуру. Достаточно описать в коде изменения и применить их.
8. Избегаем дрифта конфигураций. Используя IaaC, можно заново развиернуть все шаблоны конфигурации в другом
релизе проекта.
9. Минимизация проблемы отказов.
10. Эффективная подготовка новых сред - необходимо только внести изменения в код. Процесс подготовки становится
динамичным.
11. Масштабирование рабочих сред - по нагруженности, по времени суток, по любому параметру. Необходимо лишь обрабатывать
условия и выполнять код для развертывания/сворачивания машин.
12. Быстрое восстановление рабочих сред из бэкапов. Этот процесс тоже можно и нужно автоматизировать.

* Основополагающий принцип Iaac - это **идемпотентность**, т.е. свойства объекта при повторном применении метода не изменяются.
Также свойства идемпотентного объекта не будут изменяться и в будущем. Понятие относится как к объекту применения, так и к 
методу воздействия на этот объект.
 
# Task 2

* *Чем Ansible выгодно отличается от других систем управление конфигурациями?*
* *Какой, на ваш взгляд, метод работы систем конфигурации более надёжный push или pull?*

* Ansible использует существующую систему доступа к машинам по SSH, не требуя дополнительных телодвижений. Таким образом, быстро
начинаем работать в существующей среде. Библиотека модулей Ansible может располагаться на любой машине и не требует баз данных, серверов,
 или демонов для своей работы. Ansible прост в использовании, конфигурации описываются несложными текстовыми INI файлами. Либо можно 
использовать динамические конфигурации из данных EC2, RakcSpace или OpenStack.  
Ansible легко расширяется с помощью модулей и на текущий момент имеет в своем составе более 750 модулей. ПО можно применять в полном цикле
развертывания и жизни всей инфраструктуры  проекта.  
Работа Ansible построена на файлах сценария, т.н. Playbooks.   
https://docs.ansible.com/ содержит необходимую документацию, есть что почитать в транспорте.

* В режиме Pull ноды берут  файлы конфигурации из общего хранилища. Софт (скрипт или любой агент) устанавливается на каждую ноду отдельно. Софт
 должен: периодически собирать конфигурацию; сравнивать полученную конфигурацию с текущей; если есть расхождения, применять новые правила к конфигурации
 ноды. Таким образом, обмен инициирует собственно нода-клиент, сервер выполняет пассивную роль официанта. Так действуют Chef и Puppet.  
В режиме Push сервер "проталкивает" свои скрипты на пассивные в этом случае ноды и выполняет на них некие действия по конфигурированию последних. Действия
 инициирует сервер. Агентское ПО в этом случае вещь опциональная. ПО этого типа - Ansible и SaltStack.  

Плюсы Push:
* Простота использования в команде. Поскольку инструменты, использующие Push, проще в освоении, то большим плюсом будет наличие на проекте  готовых специалистов.
* Гибкость. Нужно лишь описать действия, остальное ПО сделает само. 
* Эффективность. Инфраструктура единообразна, ноды сконфигурированы проще, меньше оверхеда с  клиентским ПО на нодах. Обучение новых сотрудников будет проще.
* Оптимизация пропускной способности сети. Вместо стягивания конфигов нодами (которых может быть очень много), соединение будет инициировать сервер и отправлять 
конфигурация тогда, когда нужно, а не когда это захочет сделать нода. Таким образом уменьшаем задержки между переконфигурированием инфраструктуры. Траффик также 
уменьшается, поскольку ноды в режиме Pull забирают конфигурации через определенные poll-интервалы без учета наличия изменения в конфигурации. 
* Полный контроль над нодой. Сервер может выполнять все, что заложено в его архитектуру прямо сейчас и здесь.  

Плюсы Pull:
* Изменения применяются внутри инфраструктуры нод. Ни один внешний клиент не портит конфигурацию (тем более вручную). Все несанкционированные изменения будут 
исправлены конфигурацией из центрального хранилища. 
*  Проще запускать новые ноды. Как только новая машина готова, она получает из хранилища свою конфигурацию и немедленно начинает работу (в отличие от Push метода,
 где нужно проверять  ноду, готова ли она к конфигурированию).

Резюмируя - какой метод лучше? Это зависит от условий применения и инфраструктуры. Если имеется большая статическая инфраструктура, то очевидным выбором является
метод Push. Если же структура динамическая и изменчивая, то вероятнее всего наш выбор Pull.  
По надежности (подразумеваю под надежностью отказоустойчивость) проведу аналогию с любым другим сложным устройством. Чем меньше деталей, чем проще устройство - тем устройство надежнее. Поскольку метод Push подразумевает куда меньшее количество задействованного ПО, то считаю его более надежным (отказоустойчивым), чем метод Pull. 

# Task 3

*Установить на личный компьютер:*

* *VirtualBox*
* *Vagrant*
* *Ansible*

*Приложить вывод команд установленных версий каждой из программ, оформленный в markdown.*

Листинг вывода консоли:
```
[alexvk@archbox ~]$ sudo pacman -S virtualbox vagrant ansible
warning: virtualbox-6.1.32-1 is up to date -- reinstalling
warning: vagrant-2.2.19-1 is up to date -- reinstalling
warning: ansible-5.2.0-1 is up to date -- reinstalling
resolving dependencies...
looking for conflicting packages...

Packages (3) ansible-5.2.0-1  vagrant-2.2.19-1  virtualbox-6.1.32-1

Total Installed Size:  639,04 MiB
Net Upgrade Size:        0,00 MiB

:: Proceed with installation? [Y/n] n
```
Необходимые пакеты уже были проинсталлированы и готовы к употреблению.  
Версионирование (выводу пакетного менеджера не доверяем):
```
[alexvk@archbox ~]$ ansible --version
ansible [core 2.12.1]
  config file = /etc/ansible/ansible.cfg
  configured module search path = ['/home/alexvk/.ansible/plugins/modules', '/usr/share/ansible/plugins/modules']
  ansible python module location = /usr/lib/python3.10/site-packages/ansible
  ansible collection location = /home/alexvk/.ansible/collections:/usr/share/ansible/collections
  executable location = /usr/bin/ansible
  python version = 3.10.1 (main, Dec 18 2021, 23:53:45) [GCC 11.1.0]
  jinja version = 3.0.3
  libyaml = True
[alexvk@archbox ~]$ vagrant version
Installed Version: 2.2.19
Latest Version: 2.2.19
 
You're running an up-to-date version of Vagrant!
[alexvk@archbox ~]$ vboxmanage -v
6.1.32r149290
```

# Task 4

*Воспроизвести практическую часть лекции самостоятельно.*

*Создать виртуальную машину.*  
*Зайти внутрь ВМ, убедиться, что Docker установлен с помощью команды*  
*docker ps*

Для решения задачи можно склонировать репозиторий заданий и воспользоваться каталогом ``virt-homeworks/05-virt-02-iaac/src/``, содержащим все необходимые 
конфигурационные файлы. Забегая вперед - просмотр файла Vagrantfile показал наличие сети ``192.168.192.``, поэтому эту сеть необходимо добавить в конфиг virtualbox.
У меня это /etc/vbox/networks.conf. Добавляю строчку ``* 192.168.0.0/16``. Если эту сеть не добавить, virtualbox не разрешит использовать ее для host-only устройств.  
Далее листинг:
```
[alexvk@archbox vagrant]$ vagrant up
Bringing machine 'server1.netology' up with 'virtualbox' provider...
==> server1.netology: Importing base box 'bento/ubuntu-20.04'...
==> server1.netology: Matching MAC address for NAT networking...
==> server1.netology: Checking if box 'bento/ubuntu-20.04' version '202112.19.0' is up to date...
==> server1.netology: Setting the name of the VM: server1.netology
==> server1.netology: Clearing any previously set network interfaces...
==> server1.netology: Preparing network interfaces based on configuration...
    server1.netology: Adapter 1: nat
    server1.netology: Adapter 2: hostonly
==> server1.netology: Forwarding ports...
    server1.netology: 22 (guest) => 20011 (host) (adapter 1)
    server1.netology: 22 (guest) => 2222 (host) (adapter 1)
==> server1.netology: Running 'pre-boot' VM customizations...
==> server1.netology: Booting VM...
==> server1.netology: Waiting for machine to boot. This may take a few minutes...
    server1.netology: SSH address: 127.0.0.1:2222
    server1.netology: SSH username: vagrant
    server1.netology: SSH auth method: private key
    server1.netology: Warning: Connection reset. Retrying...
    server1.netology: Warning: Remote connection disconnect. Retrying...
    server1.netology: Warning: Remote connection disconnect. Retrying...
    server1.netology: 
    server1.netology: Vagrant insecure key detected. Vagrant will automatically replace
    server1.netology: this with a newly generated keypair for better security.
    server1.netology: 
    server1.netology: Inserting generated public key within guest...
    server1.netology: Removing insecure key from the guest if it's present...
    server1.netology: Key inserted! Disconnecting and reconnecting using new SSH key...
==> server1.netology: Machine booted and ready!
==> server1.netology: Checking for guest additions in VM...
==> server1.netology: Setting hostname...
==> server1.netology: Configuring and enabling network interfaces...
==> server1.netology: Mounting shared folders...
    server1.netology: /vagrant => /home/alexvk/tmp/vagrant
==> server1.netology: Running provisioner: ansible...
    server1.netology: Running ansible-playbook...

PLAY [nodes] *******************************************************************

TASK [Gathering Facts] *********************************************************
ok: [server1.netology]

TASK [Create directory for ssh-keys] *******************************************
ok: [server1.netology]

TASK [Adding rsa-key in /root/.ssh/authorized_keys] ****************************
changed: [server1.netology]

TASK [Checking DNS] ************************************************************
changed: [server1.netology]

TASK [Installing tools] ********************************************************
ok: [server1.netology] => (item=git)
ok: [server1.netology] => (item=curl)

TASK [Installing docker] *******************************************************
changed: [server1.netology]

TASK [Add the current user to docker group] ************************************
changed: [server1.netology]

PLAY RECAP *********************************************************************
server1.netology           : ok=7    changed=4    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
```
Логинюсь в созданную машину:
```
[alexvk@archbox vagrant]$ vagrant ssh server1.netology 
Welcome to Ubuntu 20.04.3 LTS (GNU/Linux 5.4.0-91-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage

  System information as of Fri 21 Jan 2022 01:29:28 PM UTC

  System load:  0.13               Users logged in:          0
  Usage of /:   13.4% of 30.88GB   IPv4 address for docker0: 172.17.0.1
  Memory usage: 23%                IPv4 address for eth0:    10.0.2.15
  Swap usage:   0%                 IPv4 address for eth1:    192.168.192.11
  Processes:    111


This system is built by the Bento project by Chef Software
More information can be found at https://github.com/chef/bento
Last login: Fri Jan 21 13:26:05 2022 from 10.0.2.2
```
Запускаю ``docker ps``:
```
vagrant@server1:~$ docker ps
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES
vagrant@server1:~$ 
```
Задача выполнена, docker показал пустой список контейнеров.
