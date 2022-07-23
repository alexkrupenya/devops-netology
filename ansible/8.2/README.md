# Домашнее задание к занятию "08.02 Работа с Playbook"

## *Подготовка к выполнению*
1. *Создайте свой собственный (или используйте старый) публичный репозиторий на github с произвольным именем.*
2. *Скачайте [playbook](./playbook/) из репозитория с домашним заданием и перенесите его в свой репозиторий.*
3. *Подготовьте хосты в соотвтествии с группами из предподготовленного playbook.* 
4. *Скачайте дистрибутив [java](https://www.oracle.com/java/technologies/javase-jdk11-downloads.html) и положите его в директорию `playbook/files/`.*

### Ответы:
1. Выполнено.
2. Выполнено.
3. Выполнено. Подготовлены образы с помощью docker-compose, [исходные тексты здесь](src/docker-compose)
```
[alexvk@archbox docker-compose]$ docker-compose up -d
[+] Building 27.2s (9/9) FINISHED                                                                                                                    
 => [docker-compose_kibana internal] load build definition from Dockerfile                                                                      0.0s
 => => transferring dockerfile: 98B                                                                                                             0.0s
 => [docker-compose_elasticsearch internal] load build definition from Dockerfile                                                               0.0s
 => => transferring dockerfile: 98B                                                                                                             0.0s
 => [docker-compose_kibana internal] load .dockerignore                                                                                         0.0s
 => => transferring context: 2B                                                                                                                 0.0s
 => [docker-compose_elasticsearch internal] load .dockerignore                                                                                  0.0s
 => => transferring context: 2B                                                                                                                 0.0s
 => [docker-compose_kibana internal] load metadata for docker.io/library/ubuntu:latest                                                          1.8s
 => [auth] library/ubuntu:pull token for registry-1.docker.io                                                                                   0.0s
 => CACHED [docker-compose_kibana 1/2] FROM docker.io/library/ubuntu:latest@sha256:b6b83d3c331794420340093eb706a6f152d9c1fa51b262d9bf34594887c  0.0s
 => [docker-compose_elasticsearch 2/2] RUN apt update && apt -y install python3                                                                23.3s
 => [docker-compose_kibana] exporting to image                                                                                                  2.0s
 => => exporting layers                                                                                                                         2.0s
 => => writing image sha256:34a75b3f17a4d09096435ca63474a57b655180c930a729028dab2d2c5627103a                                                    0.0s
 => => naming to docker.io/library/docker-compose_elasticsearch                                                                                 0.0s
 => => naming to docker.io/library/docker-compose_kibana                                                                                        0.0s
[+] Running 3/3
 ⠿ Network docker-compose_default  Created                                                                                                      0.1s
 ⠿ Container kbn                   Started                                                                                                      0.9s
 ⠿ Container esh                   Started   
```

4. Поскольу политика Oracle в отношении Java давно поменялась и для скачивания файла требуется регистрация, поступлю как указано 
[в этой статье](https://blog.joda.org/2018/09/do-not-fall-into-oracles-java-11-trap.html). Файл с openjdk [взял отсюда](https://download.java.net/java/ga/jdk11/openjdk-11_linux-x64_bin.tar.gz).
Поменяю в var_groups/all/vars.yml переменную `java_oracle_jdk_package: openjdk-11.0.2_linux-x64_bin.tar.gz`. Полученный файл 
скопировал в `playbook/files` согласно заданию.



## Основная часть
1. *Приготовьте свой собственный inventory файл `prod.yml`.*
2. *Допишите playbook: нужно сделать ещё один play, который устанавливает и настраивает kibana.*
3. *При создании tasks рекомендую использовать модули: `get_url`, `template`, `unarchive`, `file`.*
4. *Tasks должны: скачать нужной версии дистрибутив, выполнить распаковку в выбранную директорию, сгенерировать конфигурацию с параметрами.*
5. *Запустите `ansible-lint site.yml` и исправьте ошибки, если они есть.*
6. *Попробуйте запустить playbook на этом окружении с флагом `--check`.*
7. *Запустите playbook на `prod.yml` окружении с флагом `--diff`. Убедитесь, что изменения на системе произведены.*
8. *Повторно запустите playbook с флагом `--diff` и убедитесь, что playbook идемпотентен.*
9. *Подготовьте README.md файл по своему playbook. В нём должно быть описано: что делает playbook, какие у него есть параметры и теги.*
10. *Готовый playbook выложите в свой репозиторий, в ответ предоставьте ссылку на него.*

### Решение:

Подготовленный `prod.yml` [находится здесь](playbook/inventory/prod.yml).

Дополненный playbook для установки и настройки кибаны [находится здесь](playbook/site.yml).

Запускаю ansible-lint:
```
[alexvk@archbox playbook]$ ansible-lint site.yml 
WARNING  Overriding detected file kind 'yaml' with 'playbook' for given positional argument: site.yml
``` 
От warning можно избавиться, переименовав каталог `playbook` в `playbooks`.

Запуск playbook на окружении с флагом `--check`:
```
[alexvk@archbox playbook]$ ansible-playbook --check site.yml -i inventory/prod.yml 

PLAY [Install Java] *********************************************************************************************************************************

TASK [Gathering Facts] ******************************************************************************************************************************
ok: [kbn]
ok: [esh]

TASK [Set facts for Java 11 vars] *******************************************************************************************************************
ok: [esh]
ok: [kbn]

TASK [Upload .tar.gz file containing binaries from local storage] ***********************************************************************************
changed: [esh]
changed: [kbn]

TASK [Ensure installation dir exists] ***************************************************************************************************************
changed: [esh]
changed: [kbn]

TASK [Extract java in the installation directory] ***************************************************************************************************
An exception occurred during task execution. To see the full traceback, use -vvv. The error was: NoneType: None
fatal: [esh]: FAILED! => {"changed": false, "msg": "dest '/opt/jdk/11.0.2' must be an existing dir"}
An exception occurred during task execution. To see the full traceback, use -vvv. The error was: NoneType: None
fatal: [kbn]: FAILED! => {"changed": false, "msg": "dest '/opt/jdk/11.0.2' must be an existing dir"}

PLAY RECAP ******************************************************************************************************************************************
esh                        : ok=4    changed=2    unreachable=0    failed=1    skipped=0    rescued=0    ignored=0   
kbn                        : ok=4    changed=2    unreachable=0    failed=1    skipped=0    rescued=0    ignored=0   
```
Вижу ошибку для обоих хостов. Сообщение гласит об отсутствии директории для установки Java.

Теперь запускаю playbook на том же окружении с флагом --diff:
```
[alexvk@archbox playbook]$ ansible-playbook --diff site.yml -i inventory/prod.yml 

PLAY [Install Java] *********************************************************************************************************************************

TASK [Gathering Facts] ******************************************************************************************************************************
ok: [kbn]
ok: [esh]

TASK [Set facts for Java 11 vars] *******************************************************************************************************************
ok: [esh]
ok: [kbn]

TASK [Upload .tar.gz file containing binaries from local storage] ***********************************************************************************
diff skipped: source file size is greater than 104448
changed: [esh]
diff skipped: source file size is greater than 104448
changed: [kbn]

TASK [Ensure installation dir exists] ***************************************************************************************************************
--- before
+++ after
@@ -1,4 +1,4 @@
 {
     "path": "/opt/jdk/11.0.2",
-    "state": "absent"
+    "state": "directory"
 }

changed: [kbn]
--- before
+++ after
@@ -1,4 +1,4 @@
 {
     "path": "/opt/jdk/11.0.2",
-    "state": "absent"
+    "state": "directory"
 }

changed: [esh]

TASK [Extract java in the installation directory] ***************************************************************************************************
changed: [esh]
changed: [kbn]

TASK [Export environment variables] *****************************************************************************************************************
--- before
+++ after: /home/alexvk/.ansible/tmp/ansible-local-54886rolutfa1/tmpnoxd2dvv/jdk.sh.j2
@@ -0,0 +1,5 @@
+# Warning: This file is Ansible Managed, manual changes will be overwritten on next playbook run.
+#!/usr/bin/env bash
+
+export JAVA_HOME=/opt/jdk/11.0.2
+export PATH=$PATH:$JAVA_HOME/bin
\ No newline at end of file

changed: [esh]
--- before
+++ after: /home/alexvk/.ansible/tmp/ansible-local-54886rolutfa1/tmphhgp8dfp/jdk.sh.j2
@@ -0,0 +1,5 @@
+# Warning: This file is Ansible Managed, manual changes will be overwritten on next playbook run.
+#!/usr/bin/env bash
+
+export JAVA_HOME=/opt/jdk/11.0.2
+export PATH=$PATH:$JAVA_HOME/bin
\ No newline at end of file

changed: [kbn]

PLAY [Install Elasticsearch] ************************************************************************************************************************

TASK [Gathering Facts] ******************************************************************************************************************************
ok: [esh]

TASK [Upload tar.gz Elasticsearch from remote URL] **************************************************************************************************
changed: [esh]

TASK [Create directrory for Elasticsearch] **********************************************************************************************************
--- before
+++ after
@@ -1,4 +1,4 @@
 {
     "path": "/opt/elastic/7.17.3",
-    "state": "absent"
+    "state": "directory"
 }

changed: [esh]

TASK [Extract Elasticsearch in the installation directory] ******************************************************************************************
changed: [esh]

TASK [Set environment Elastic] **********************************************************************************************************************
--- before
+++ after: /home/alexvk/.ansible/tmp/ansible-local-54886rolutfa1/tmpeu3gtgkj/elk.sh.j2
@@ -0,0 +1,5 @@
+# Warning: This file is Ansible Managed, manual changes will be overwritten on next playbook run.
+#!/usr/bin/env bash
+
+export ES_HOME=/opt/elastic/7.17.3
+export PATH=$PATH:$ES_HOME/bin
\ No newline at end of file

changed: [esh]

PLAY [Install Kibana] *******************************************************************************************************************************

TASK [Gathering Facts] ******************************************************************************************************************************
ok: [kbn]

TASK [Upload tar.gz Kibana from remote URL] *********************************************************************************************************
changed: [kbn]

TASK [Create directory for kibana (/opt/kibana/7.17.5)] *********************************************************************************************
--- before
+++ after
@@ -1,4 +1,4 @@
 {
     "path": "/opt/kibana/7.17.5",
-    "state": "absent"
+    "state": "directory"
 }

changed: [kbn]

TASK [Extract kibana in the installation directory] *************************************************************************************************
changed: [kbn]

TASK [Set environment Kibana] ***********************************************************************************************************************
--- before
+++ after: /home/alexvk/.ansible/tmp/ansible-local-54886rolutfa1/tmpog5m_4pe/kib.sh.j2
@@ -0,0 +1,5 @@
+# Warning: This file is Ansible Managed, manual changes will be overwritten on next playbook run.
+#!/usr/bin/env bash
+
+export KB_HOME=/opt/kibana/7.17.5
+export PATH=$PATH:$KB_HOME/bin

changed: [kbn]

PLAY RECAP ******************************************************************************************************************************************
esh                        : ok=11   changed=8    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
kbn                        : ok=11   changed=8    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   

[alexvk@archbox playbook]$ 
``` 
Видно, что изменения внесены. Проконтролирую наличие директорий в контейнере `kbn` (kibana):
```
[alexvk@archbox playbook]$ docker exec kbn tree -L 2 /opt
/opt
|-- jdk
|   `-- 11.0.2
`-- kibana
    `-- 7.17.5

4 directories, 0 files
```
и в контейнере `esh` (elasticsearch):
```
[alexvk@archbox playbook]$ docker exec esh tree -L 2 /opt
/opt
|-- elastic
|   `-- 7.17.3
`-- jdk
    `-- 11.0.2

4 directories, 0 files
```

[Файл с объяснением функции и параметров playbook](playbook/README.md)

## Необязательная часть

1. Приготовьте дополнительный хост для установки logstash.
2. Пропишите данный хост в `prod.yml` в новую группу `logstash`.
3. Дополните playbook ещё одним play, который будет исполнять установку logstash только на выделенный для него хост.
4. Все переменные для нового play определите в отдельный файл `group_vars/logstash/vars.yml`.
5. Logstash конфиг должен конфигурироваться в части ссылки на elasticsearch (можно взять, например его IP из facts или определить через vars).
6. Дополните README.md, протестируйте playbook, выложите новую версию в github. В ответ предоставьте ссылку на репозиторий.

---

### Как оформить ДЗ?

Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.

---



