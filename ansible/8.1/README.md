# Домашнее задание к занятию "08.01 Введение в Ansible"

## *Подготовка к выполнению*
1. *Установите ansible версии 2.10 или выше.*
2. *Создайте свой собственный публичный репозиторий на github с произвольным именем.*
3. *Скачайте [playbook](./playbook/) из репозитория с домашним заданием и перенесите его в свой репозиторий.*

### Решение:
1. Установил ansible с помощью менеджера пакетов ОС. Вывод версии:
```
[alexvk@archbox ~]$ ansible --version
ansible [core 2.13.1]
  config file = /etc/ansible/ansible.cfg
  configured module search path = ['/home/alexvk/.ansible/plugins/modules', '/usr/share/ansible/plugins/modules']
  ansible python module location = /usr/lib/python3.10/site-packages/ansible
  ansible collection location = /home/alexvk/.ansible/collections:/usr/share/ansible/collections
  executable location = /usr/bin/ansible
  python version = 3.10.5 (main, Jun  6 2022, 18:49:26) [GCC 12.1.0]
  jinja version = 3.1.2
  libyaml = True
```
2. В уже созданном публичном репозитории для домашних заданий создан отдельный каталог ansible.
3. Файлы из playbook с домашним заданием скопированы в репозиторий на github.

## *Основная часть*

1. *Попробуйте запустить playbook на окружении из `test.yml`, зафиксируйте какое значение имеет факт `some_fact` для указанного хоста при выполнении playbook'a.*
2. *Найдите файл с переменными (group_vars) в котором задаётся найденное в первом пункте значение и поменяйте его на 'all default fact'.*
3. *Воспользуйтесь подготовленным (используется `docker`) или создайте собственное окружение для проведения дальнейших испытаний.*
4. *Проведите запуск playbook на окружении из `prod.yml`. Зафиксируйте полученные значения `some_fact` для каждого из `managed host`.*
5. *Добавьте факты в `group_vars` каждой из групп хостов так, чтобы для `some_fact` получились следующие значения: для `deb` - 'deb default fact', для `el` - 'el default fact'.*
6. *Повторите запуск playbook на окружении `prod.yml`. Убедитесь, что выдаются корректные значения для всех хостов.*
7. *При помощи `ansible-vault` зашифруйте факты в `group_vars/deb` и `group_vars/el` с паролем `netology`.*
8. *Запустите playbook на окружении `prod.yml`. При запуске `ansible` должен запросить у вас пароль. Убедитесь в работоспособности.*
9. *Посмотрите при помощи `ansible-doc` список плагинов для подключения. Выберите подходящий для работы на `control node`.*
10. *В `prod.yml` добавьте новую группу хостов с именем  `local`, в ней разместите localhost с необходимым типом подключения.*
11. *Запустите playbook на окружении `prod.yml`. При запуске `ansible` должен запросить у вас пароль. Убедитесь что факты `some_fact` для каждого из хостов определены из верных `group_vars`.*
12. *Заполните `README.md` ответами на вопросы. Сделайте `git push` в ветку `master`. В ответе отправьте ссылку на ваш открытый репозиторий с изменённым `playbook` и заполненным `README.md`.*

### Решение

1. Выполняю playbook на окружении из `test.yml`. Вывод команды указан далее:
```
[alexvk@archbox playbook]$ ansible-playbook site.yml -i inventory/test.yml

PLAY [Print os facts] ********************************************************************************************************************

TASK [Gathering Facts] *******************************************************************************************************************
[WARNING]: Platform linux on host localhost is using the discovered Python interpreter at /usr/bin/python3.10, but future installation of
another Python interpreter could change the meaning of that path. See https://docs.ansible.com/ansible-
core/2.13/reference_appendices/interpreter_discovery.html for more information.
ok: [localhost]

TASK [Print OS] **************************************************************************************************************************
ok: [localhost] => {
    "msg": "Archlinux"
}

TASK [Print fact] ************************************************************************************************************************
ok: [localhost] => {
    "msg": 12
}

PLAY RECAP *******************************************************************************************************************************
localhost                  : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```
Some_fact имеет значение 12, указанное в group_vars/all/exampl.yml

2. Для ленивых, чтобы долго не искать нужную подстроку:
```
 [alexvk@archbox playbook]$ sed -i 's/12/all default fact/' `find . -type f -exec grep -l "12" {} ;`
```
Исполняю плейбук:
```
[alexvk@archbox playbook]$ ansible-playbook site.yml -i inventory/test.yml

PLAY [Print os facts] ********************************************************************************************************************

TASK [Gathering Facts] *******************************************************************************************************************
[WARNING]: Platform linux on host localhost is using the discovered Python interpreter at /usr/bin/python3.10, but future installation of
another Python interpreter could change the meaning of that path. See https://docs.ansible.com/ansible-
core/2.13/reference_appendices/interpreter_discovery.html for more information.
ok: [localhost]

TASK [Print OS] **************************************************************************************************************************
ok: [localhost] => {
    "msg": "Archlinux"
}

TASK [Print fact] ************************************************************************************************************************
ok: [localhost] => {
    "msg": "all default fact"
}

PLAY RECAP *******************************************************************************************************************************
localhost                  : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```

3. Собрал свой образ для docker из образа на dockerhub "ubuntu:latest", добавив в него python3. Образ centos:7 из dockerhub уже содержит питон. 
Запускаю с помощью docker-compose:
```
[alexvk@archbox docker-compose]$ docker-compose up -d
[+] Running 2/2
 ⠿ Container centos7  Started                                                                                              1.0s
 ⠿ Container ubuntu   Started     
 ```
 
 Посмотрю состояние контейнеров:
 ```
 [alexvk@archbox docker-compose]$ docker ps
CONTAINER ID   IMAGE                   COMMAND      CREATED          STATUS          PORTS     NAMES
9a93ac834f17   centos:7                "sleep 1d"   17 seconds ago   Up 15 seconds             centos7
e5db591fccf7   docker-compose_ubuntu   "sleep 1d"   17 seconds ago   Up 15 seconds             ubuntu
```
Исходники для [docker-compose здесь](src/docker-compose).

4. Выполню запуск playbook в соответствии с заданием:
```
[alexvk@archbox playbook]$ ansible-playbook site.yml -i inventory/prod.yml

PLAY [Print os facts] **********************************************************************************************************

TASK [Gathering Facts] *********************************************************************************************************
ok: [ubuntu]
ok: [centos7]

TASK [Print OS] ****************************************************************************************************************
ok: [centos7] => {
    "msg": "CentOS"
}
ok: [ubuntu] => {
    "msg": "Ubuntu"
}

TASK [Print fact] **************************************************************************************************************
ok: [centos7] => {
    "msg": "el"
}
ok: [ubuntu] => {
    "msg": "deb"
}

PLAY RECAP *********************************************************************************************************************
centos7                    : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
ubuntu                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```

5. Редактирую значения в group_vars  согласно заданию и выполняю playbook.

6. Результат выполнения playbook:
```
[alexvk@archbox playbook]$ ansible-playbook site.yml -i inventory/prod.yml

PLAY [Print os facts] **********************************************************************************************************

TASK [Gathering Facts] *********************************************************************************************************
ok: [ubuntu]
ok: [centos7]

TASK [Print OS] ****************************************************************************************************************
ok: [centos7] => {
    "msg": "CentOS"
}
ok: [ubuntu] => {
    "msg": "Ubuntu"
}

TASK [Print fact] **************************************************************************************************************
ok: [centos7] => {
    "msg": "el default fact"
}
ok: [ubuntu] => {
    "msg": "deb default fact"
}

PLAY RECAP *********************************************************************************************************************
centos7                    : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
ubuntu                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```

7. Шифрую факты для групп хостов с паролем 'netology'.
```
[alexvk@archbox playbook]$ ansible-vault encrypt group_vars/deb/examp.yml
New Vault password:
Confirm New Vault password:
Encryption successful
[alexvk@archbox playbook]$ ansible-vault encrypt group_vars/el/examp.yml
New Vault password:
Confirm New Vault password:
Encryption successful
```
Листинг зашифрованного содержимого:
```
[alexvk@archbox playbook]$ cat group_vars/deb/examp.yml
$ANSIBLE_VAULT;1.1;AES256
39623931623061613866663733363330313430386165666465306231303831653939633766356132
3935303433376238383164356539343334386636383832330a303839386638653966336664336563
37306161343537313038616632656537343261613562623232343766363533653736316433316562
6431633862663636350a646463646435326566646262366234316131346361363265386566626132
34313231623731346466646338313735363663386133633134633362323233623566343337663662
6161656361386638323630393366393537376264333936353866
```

8. Запускаю playbook для prod:
```
[alexvk@archbox playbook]$ ansible-playbook --ask-vault-password site.yml -i inventory/prod.yml
Vault password:

PLAY [Print os facts] **********************************************************************************************************

TASK [Gathering Facts] *********************************************************************************************************
ok: [ubuntu]
ok: [centos7]

TASK [Print OS] ****************************************************************************************************************
ok: [centos7] => {
    "msg": "CentOS"
}
ok: [ubuntu] => {
    "msg": "Ubuntu"
}

TASK [Print fact] **************************************************************************************************************
ok: [centos7] => {
    "msg": "el default fact"
}
ok: [ubuntu] => {
    "msg": "deb default fact"
}

PLAY RECAP *********************************************************************************************************************
centos7                    : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
ubuntu                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```

9.  Просмотрю документацию по ansible:
```
[alexvk@archbox playbook]$ ansible-doc -l -t connection
[skipped]
local                          execute on controller
[skipped]
```
Для работы на локальной ноде подходит plugin "local".

10. Добавлю группу хостов с именем local, [файл здесь](playbook1/inventory/prod.yml).

11. Запускаю playbook на  окружении "prod.yml":
```
[alexvk@archbox playbook]$ ansible-playbook site.yml --ask-vault-password -i inventory/prod.yml
Vault password:

PLAY [Print os facts] **********************************************************************************************************

TASK [Gathering Facts] *********************************************************************************************************
[WARNING]: Platform linux on host localhost is using the discovered Python interpreter at /usr/bin/python3.10, but future
installation of another Python interpreter could change the meaning of that path. See https://docs.ansible.com/ansible-
core/2.13/reference_appendices/interpreter_discovery.html for more information.
ok: [localhost]
ok: [ubuntu]
ok: [centos7]

TASK [Print OS] ****************************************************************************************************************
ok: [centos7] => {
    "msg": "CentOS"
}
ok: [ubuntu] => {
    "msg": "Ubuntu"
}
ok: [localhost] => {
    "msg": "Archlinux"
}

TASK [Print fact] **************************************************************************************************************
ok: [centos7] => {
    "msg": "el default fact"
}
ok: [ubuntu] => {
    "msg": "deb default fact"
}
ok: [localhost] => {
    "msg": "all default fact"
}

PLAY RECAP *********************************************************************************************************************
centos7                    : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
localhost                  : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
ubuntu                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```

12. Оформил решение по требованию п.12 задания. [Исходные тексты здесь](playbook1/)

## Необязательная часть

1. *При помощи `ansible-vault` расшифруйте все зашифрованные файлы с переменными.*
2. *Зашифруйте отдельное значение `PaSSw0rd` для переменной `some_fact` паролем `netology`. Добавьте полученное значение в `group_vars/all/exmp.yml`.*
3. *Запустите `playbook`, убедитесь, что для нужных хостов применился новый `fact`.*
4. *Добавьте новую группу хостов `fedora`, самостоятельно придумайте для неё переменную. В качестве образа можно использовать [этот](https://hub.docker.com/r/pycontribs/fedora).*
5. *Напишите скрипт на bash: автоматизируйте поднятие необходимых контейнеров, запуск ansible-playbook и остановку контейнеров.*
6. *Все изменения должны быть зафиксированы и отправлены в вашей личный репозиторий.*

### Решение:

1.  Расшифрую файлы с переменными:
```
[alexvk@archbox playbook]$ ansible-vault decrypt group_vars/deb/examp.yml
Vault password:
Decryption successful
[alexvk@archbox playbook]$ cat group_vars/deb/examp.yml
---
  some_fact: "deb default fact"

[alexvk@archbox playbook]$ ansible-vault decrypt group_vars/el/examp.yml
Vault password:
Decryption successful

[alexvk@archbox playbook]$ cat group_vars/el/examp.yml
---
  some_fact: "el default fact"
```

2. Шифрование отдельного значения:
``` 
[alexvk@archbox playbook]$ ansible-vault encrypt_string PaSSw0rd -n some_fact
New Vault password:
Confirm New Vault password:
Encryption successful
some_fact: !vault |
          $ANSIBLE_VAULT;1.1;AES256
          37633362303033336236386530636637303162393134303965363334353331313033303734623066
          3765333363373334393638376537633731306535373461610a656532356566313034393633613335
          39346164653163656233663466643862363333643865393033343732373738386339333134666564
          6562306633306632380a306237373664613263366132643463643366353761616364623363353239
          6633
```

3. Запускаю playbook:
```
[alexvk@archbox playbook]$ ansible-playbook site.yml --ask-vault-password -i inventory/prod.yml
Vault password:

PLAY [Print os facts] **********************************************************************************************************

TASK [Gathering Facts] *********************************************************************************************************
[WARNING]: Platform linux on host localhost is using the discovered Python interpreter at /usr/bin/python3.10, but future
installation of another Python interpreter could change the meaning of that path. See https://docs.ansible.com/ansible-
core/2.13/reference_appendices/interpreter_discovery.html for more information.
ok: [localhost]
ok: [ubuntu]
ok: [centos7]

TASK [Print OS] ****************************************************************************************************************
ok: [centos7] => {
    "msg": "CentOS"
}
ok: [ubuntu] => {
    "msg": "Ubuntu"
}
ok: [localhost] => {
    "msg": "Archlinux"
}

TASK [Print fact] **************************************************************************************************************
ok: [centos7] => {
    "msg": "el default fact"
}
ok: [ubuntu] => {
    "msg": "deb default fact"
}
ok: [localhost] => {
    "msg": "PaSSw0rd"
}

PLAY RECAP *********************************************************************************************************************
centos7                    : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
localhost                  : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
ubuntu                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```

4. Добавляю fedora к списку хостов и запускаю контейнер с fedora:
```
[alexvk@archbox docker-compose]$ docker-compose up -d
[+] Running 2/2
 ⠿ fedora Pulled                                                                                                          20.7s
   ⠿ e1deda52ffad Pull complete                                                                                           17.5s
[+] Running 4/4
 ⠿ Network docker-compose_default  Created                                                                                 0.1s
 ⠿ Container centos7               Started                                                                                 2.6s
 ⠿ Container ubuntu                Started                                                                                 2.6s
 ⠿ Container fedora                Started                                                                                 2.4s
```
Теперь запускаю playbook:
```
[alexvk@archbox playbook]$ ansible-playbook site.yml --ask-vault-password -i inventory/prod.yml
Vault password:

PLAY [Print os facts] **********************************************************************************************************

TASK [Gathering Facts] *********************************************************************************************************
[WARNING]: Platform linux on host localhost is using the discovered Python interpreter at /usr/bin/python3.10, but future
installation of another Python interpreter could change the meaning of that path. See https://docs.ansible.com/ansible-
core/2.13/reference_appendices/interpreter_discovery.html for more information.
ok: [localhost]
ok: [ubuntu]
ok: [fedora]
ok: [centos7]

TASK [Print OS] ****************************************************************************************************************
ok: [centos7] => {
    "msg": "CentOS"
}
ok: [ubuntu] => {
    "msg": "Ubuntu"
}
ok: [localhost] => {
    "msg": "Archlinux"
}
ok: [fedora] => {
    "msg": "Fedora"
}

TASK [Print fact] **************************************************************************************************************
ok: [centos7] => {
    "msg": "el default fact"
}
ok: [ubuntu] => {
    "msg": "deb default fact"
}
ok: [localhost] => {
    "msg": "PaSSw0rd"
}
ok: [fedora] => {
    "msg": "fe default fact"
}

PLAY RECAP *********************************************************************************************************************
centos7                    : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
fedora                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
localhost                  : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
ubuntu                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```

5. [Написан скрипт на bash](src/bash) для автоматизации процесса запуска/остановки инстансов docker и выполнения playbook.
Запуск и вывод скрипта:
```
[alexvk@archbox 8.1]$ ./run_abook.sh
[+] Running 4/4
 ⠿ Network docker-compose_default  Created                                                                                 0.1s
 ⠿ Container fedora                Started                                                                                 1.1s
 ⠿ Container ubuntu                Started                                                                                 1.0s
 ⠿ Container centos7               Started                                                                                 0.9s

PLAY [Print os facts] **********************************************************************************************************

TASK [Gathering Facts] *********************************************************************************************************
[WARNING]: Platform linux on host localhost is using the discovered Python interpreter at /usr/bin/python3.10, but future
installation of another Python interpreter could change the meaning of that path. See https://docs.ansible.com/ansible-
core/2.13/reference_appendices/interpreter_discovery.html for more information.
ok: [localhost]
ok: [ubuntu]
ok: [fedora]
ok: [centos7]

TASK [Print OS] ****************************************************************************************************************
ok: [centos7] => {
    "msg": "CentOS"
}
ok: [ubuntu] => {
    "msg": "Ubuntu"
}
ok: [localhost] => {
    "msg": "Archlinux"
}
ok: [fedora] => {
    "msg": "Fedora"
}

TASK [Print fact] **************************************************************************************************************
ok: [centos7] => {
    "msg": "el default fact"
}
ok: [ubuntu] => {
    "msg": "deb default fact"
}
ok: [localhost] => {
    "msg": "PaSSw0rd"
}
ok: [fedora] => {
    "msg": "fe default fact"
}

PLAY RECAP *********************************************************************************************************************
centos7                    : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
fedora                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
localhost                  : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
ubuntu                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

[+] Running 4/4
 ⠿ Container fedora                Removed                                                                                10.3s
 ⠿ Container centos7               Removed                                                                                10.5s
 ⠿ Container ubuntu                Removed                                                                                10.5s
 ⠿ Network docker-compose_default  Removed                                                                                 0.1s
```

6. Оформил решение по требованию п.6 задания. [Исходные тексты здесь](playbook2/)

---

### Как оформить ДЗ?

Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.

---
