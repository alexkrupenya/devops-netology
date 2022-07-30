# Домашнее задание к занятию "08.03 Работа с Roles"

## Подготовка к выполнению
1. *Создайте два пустых публичных репозитория в любом своём проекте: elastic-role и kibana-role.*
2. *Скачайте [role](./roles/) из репозитория с домашним заданием и перенесите его в свой репозиторий elastic-role.*
3. *Скачайте дистрибутив [java](https://www.oracle.com/java/technologies/javase-jdk11-downloads.html) и положите его в директорию `playbook/files/`. *
4. *Установите molecule: `pip3 install molecule`*
5. *Добавьте публичную часть своего ключа к своему профилю в github.*

### Решение

1. Cозданы два репозитория на github *elastic-role* и *kibana-role*, public доступ.
2. Выполнено.
```
[alexvk@archbox elastic-role]$ tree -L 2
.
└── roles
    ├── defaults
    ├── handlers
    ├── meta
    ├── molecule
    ├── README.md
    ├── tasks
    ├── templates
    ├── tests
    └── vars
```
3. Использую дистрибутив java из OpenJDK 11.0.2, помещаю его в `playbook/files`.
4.  Устанавливаю molecule:
```
[alexvk@archbox elastic-role]$ pip3 install molecule
Defaulting to user installation because normal site-packages is not writeable
Collecting molecule
  Using cached molecule-4.0.1-py3-none-any.whl (248 kB)
[..skipped..]
Installing collected packages: molecule
Successfully installed molecule-4.0.1
```
Дополнительно необходимо указать путь  к исполняемому файлу molecule, т.к. установка выполнена в домашней директории. Путь добавляется к пути в переменной
`PATH` в файле `.bashrc`. Версия molecule:
```
[alexvk@archbox elastic-role]$ molecule --version
molecule 4.0.1 using python 3.10 
    ansible:2.13.2
    delegated:4.0.1 from molecule
```
Для работы с docker в archlinux нужно дополнительно установить пакет `python-docker`.

5. Публичный ключ добавлен.

## Основная часть

*Наша основная цель - разбить наш playbook на отдельные roles. Задача: сделать roles для elastic, kibana и написать playbook для использования этих ролей. Ожидаемый результат: существуют два ваших репозитория с roles и один репозиторий с playbook.*

1. *Создать в старой версии playbook файл `requirements.yml` и заполнить его следующим содержимым:*
   ```yaml
   ---
     - src: git@github.com:netology-code/mnt-homeworks-ansible.git
       scm: git
       version: "1.0.1"
       name: java 
   ```
2. *При помощи `ansible-galaxy` скачать себе эту роль. Запустите  `molecule test`, посмотрите на вывод команды.*
3. *Перейдите в каталог с ролью elastic-role и создайте сценарий тестирования по умолчаню при помощи `molecule init scenario --driver-name docker`.*
4. *Добавьте несколько разных дистрибутивов (centos:8, ubuntu:latest) для инстансов и протестируйте роль, исправьте найденные ошибки, если они есть.*
5. *Создайте новый каталог с ролью при помощи `molecule init role --driver-name docker kibana-role`. Можете использовать другой драйвер, который более удобен вам.*
6. *На основе tasks из старого playbook заполните новую role. Разнесите переменные между `vars` и `default`. Проведите тестирование на разных дистрибитивах (centos:7, centos:8, ubuntu).*
7. *Выложите все roles в репозитории. Проставьте тэги, используя семантическую нумерацию.*
8. *Добавьте roles в `requirements.yml` в playbook.*
9. *Переработайте playbook на использование roles.*
10. *Выложите playbook в репозиторий.*
11. *В ответ приведите ссылки на оба репозитория с roles и одну ссылку на репозиторий с playbook.*

### Решение

1. Файл requirements.yml создан по приведенному шаблону.
2. Скачаю роль, как указано [в документации](https://docs.ansible.com/ansible/latest/galaxy/user_guide.html#install-multiple-collections-with-a-requirements-file):
```
[alexvk@archbox 8.3]$ ansible-galaxy install -r requirements.yml --roles-path .
Starting galaxy role install process
- extracting java to /home/alexvk/learn/devops/ansible/8.3/java
- java (1.0.1) was installed successfully
```
Запускаю `molecule test`:
```
[alexvk@archbox java]$ molecule test
INFO     default scenario test matrix: dependency, lint, cleanup, destroy, syntax, create, prepare, converge, idempotence, side_effect, verify, cleanup, destroy
INFO     Performing prerun with role_name_check=0...
INFO     Using /home/alexvk/.cache/ansible-compat/38a096/roles/mynamespace.java symlink to current repository in order to enable Ansible to find the role using its expected full name.
INFO     Running default > dependency
WARNING  Skipping, missing the requirements file.
WARNING  Skipping, missing the requirements file.
INFO     Running default > lint
INFO     Lint is disabled.
INFO     Running default > cleanup
WARNING  Skipping, cleanup playbook not configured.
INFO     Running default > destroy
INFO     Sanity checks: 'docker'

PLAY [Destroy] *****************************************************************

TASK [Destroy molecule instance(s)] ********************************************
changed: [localhost] => (item=instance)

TASK [Wait for instance(s) deletion to complete] *******************************
FAILED - RETRYING: [localhost]: Wait for instance(s) deletion to complete (300 retries left).
ok: [localhost] => (item=instance)

TASK [Delete docker networks(s)] ***********************************************

PLAY RECAP *********************************************************************
localhost                  : ok=2    changed=1    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0

INFO     Running default > syntax

playbook: /home/alexvk/learn/devops/ansible/8.3/java/molecule/default/converge.yml
INFO     Running default > create

PLAY [Create] ******************************************************************

TASK [Log into a Docker registry] **********************************************
skipping: [localhost] => (item=None) 
skipping: [localhost]

TASK [Check presence of custom Dockerfiles] ************************************
ok: [localhost] => (item={'image': 'quay.io/centos/centos:stream8', 'name': 'instance', 'pre_build_image': True})

TASK [Create Dockerfiles from image names] *************************************
skipping: [localhost] => (item={'image': 'quay.io/centos/centos:stream8', 'name': 'instance', 'pre_build_image': True}) 

TASK [Discover local Docker images] ********************************************
ok: [localhost] => (item={'changed': False, 'skipped': True, 'skip_reason': 'Conditional result was False', 'item': {'image': 'quay.io/centos/centos:stream8', 'name': 'instance', 'pre_build_image': True}, 'ansible_loop_var': 'item', 'i': 0, 'ansible_index_var': 'i'})

TASK [Build an Ansible compatible image (new)] *********************************
skipping: [localhost] => (item=molecule_local/quay.io/centos/centos:stream8) 

TASK [Create docker network(s)] ************************************************

TASK [Determine the CMD directives] ********************************************
ok: [localhost] => (item={'image': 'quay.io/centos/centos:stream8', 'name': 'instance', 'pre_build_image': True})

TASK [Create molecule instance(s)] *********************************************
changed: [localhost] => (item=instance)

TASK [Wait for instance(s) creation to complete] *******************************
FAILED - RETRYING: [localhost]: Wait for instance(s) creation to complete (267 retries left).
[..skipped..]
]changed: [localhost] => (item={'failed': 0, 'started': 1, 'finished': 0, 'ansible_job_id': '694058754575.4635', 'results_file': '/home/alexvk/.ansible_async/694058754575.4635', 'changed': True, 'item': {'image': 'quay.io/centos/centos:stream8', 'name': 'instance', 'pre_build_image': True}, 'ansible_loop_var': 'item'})

PLAY RECAP *********************************************************************
localhost                  : ok=5    changed=2    unreachable=0    failed=0    skipped=4    rescued=0    ignored=0

INFO     Running default > prepare
WARNING  Skipping, prepare playbook not configured.
INFO     Running default > converge

PLAY [Converge] ****************************************************************

TASK [Gathering Facts] *********************************************************
ok: [instance]

TASK [Include java] ************************************************************

TASK [java : Upload .tar.gz file containing binaries from local storage] *******
skipping: [instance]

TASK [java : Upload .tar.gz file conaining binaries from remote storage] *******
changed: [instance]

TASK [java : Ensure installation dir exists] ***********************************
fatal: [instance]: FAILED! => {"changed": false, "module_stderr": "/bin/sh: sudo: command not found\n", "module_stdout": "", "msg": "MODULE FAILURE\nSee stdout/stderr for the exact error", "rc": 127}

PLAY RECAP *********************************************************************
instance                   : ok=2    changed=1    unreachable=0    failed=1    skipped=1    rescued=0    ignored=0

WARNING  Retrying execution failure 2 of: ansible-playbook --inventory /home/alexvk/.cache/molecule/java/default/inventory --skip-tags molecule-notest,notest /home/alexvk/learn/devops/ansible/8.3/java/molecule/default/converge.yml
CRITICAL Ansible return code was 2, command was: ['ansible-playbook', '--inventory', '/home/alexvk/.cache/molecule/java/default/inventory', '--skip-tags', 'molecule-notest,notest', '/home/alexvk/learn/devops/ansible/8.3/java/molecule/default/converge.yml']
WARNING  An error occurred during the test sequence action: 'converge'. Cleaning up.
INFO     Running default > cleanup
WARNING  Skipping, cleanup playbook not configured.
INFO     Running default > destroy

PLAY [Destroy] *****************************************************************

TASK [Destroy molecule instance(s)] ********************************************
changed: [localhost] => (item=instance)

TASK [Wait for instance(s) deletion to complete] *******************************
FAILED - RETRYING: [localhost]: Wait for instance(s) deletion to complete (300 retries left).
changed: [localhost] => (item=instance)

TASK [Delete docker networks(s)] ***********************************************

PLAY RECAP *********************************************************************
localhost                  : ok=2    changed=2    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0

INFO     Pruning extra files from scenario ephemeral directory
```

4. Добавляю контейнеры pycontribs/centos7, pycontribs/centos8, образ для ubuntu собираю из версии ubuntu trusty и python 2.7. Согласно [документации](https://molecule.readthedocs.io/en/latest/configuration.html#molecule.platforms.Platforms), инстансы нужно добавить в файл `molecule/default/molecule.yml`.
```
[alexvk@archbox elastic-role]$ molecule test
INFO     default scenario test matrix: dependency, lint, cleanup, destroy, syntax, create, prepare, converge, idempotence, side_effect, verify, cleanup, destroy
INFO     Performing prerun with role_name_check=0...
INFO     Set ANSIBLE_LIBRARY=/home/alexvk/.cache/ansible-compat/12e536/modules:/home/alexvk/.cache/ansible-compat/38a096/modules:/home/alexvk/.ansible/plugins/modules:/usr/share/ansible/plugins/modules:/home/alexvk/.cache/ansible-compat/38a096/modules:/home/alexvk/.ansible/plugins/modules:/usr/share/ansible/plugins/modules
INFO     Set ANSIBLE_COLLECTIONS_PATH=/home/alexvk/.cache/ansible-compat/12e536/collections:/home/alexvk/.cache/ansible-compat/38a096/collections:/home/alexvk/.ansible/collections:/usr/share/ansible/collections:/home/alexvk/.cache/ansible-compat/38a096/collections:/home/alexvk/.ansible/collections:/usr/share/ansible/collections
INFO     Set ANSIBLE_ROLES_PATH=/home/alexvk/.cache/ansible-compat/12e536/roles:roles:/home/alexvk/.cache/ansible-compat/38a096/roles:/home/alexvk/.ansible/roles:/usr/share/ansible/roles:/etc/ansible/roles:/home/alexvk/.cache/ansible-compat/38a096/roles:/home/alexvk/.ansible/roles:/usr/share/ansible/roles:/etc/ansible/roles
INFO     Running default > dependency
WARNING  Skipping, missing the requirements file.
WARNING  Skipping, missing the requirements file.
INFO     Running default > lint
INFO     Lint is disabled.
INFO     Running default > cleanup
WARNING  Skipping, cleanup playbook not configured.
INFO     Running default > destroy
INFO     Sanity checks: 'docker'

PLAY [Destroy] *****************************************************************

TASK [Destroy molecule instance(s)] ********************************************
changed: [localhost] => (item=centos8)
changed: [localhost] => (item=centos7)
changed: [localhost] => (item=ubuntu)

TASK [Wait for instance(s) deletion to complete] *******************************
ok: [localhost] => (item=centos8)
ok: [localhost] => (item=centos7)
ok: [localhost] => (item=ubuntu)

TASK [Delete docker networks(s)] ***********************************************

PLAY RECAP *********************************************************************
localhost                  : ok=2    changed=1    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0

INFO     Running default > syntax

playbook: /home/alexvk/learn/devops/git/elastic-role/molecule/default/converge.yml
INFO     Running default > create

PLAY [Create] ******************************************************************

TASK [Log into a Docker registry] **********************************************
skipping: [localhost] => (item=None) 
skipping: [localhost] => (item=None) 
skipping: [localhost] => (item=None) 
skipping: [localhost]

TASK [Check presence of custom Dockerfiles] ************************************
ok: [localhost] => (item={'image': 'pycontribs/centos:8', 'name': 'centos8', 'pre_build_image': True})
ok: [localhost] => (item={'image': 'pycontribs/centos:7', 'name': 'centos7', 'pre_build_image': True})
ok: [localhost] => (item={'image': 'ubuntu:my', 'name': 'ubuntu', 'pre_build_image': True})

TASK [Create Dockerfiles from image names] *************************************
skipping: [localhost] => (item={'image': 'pycontribs/centos:8', 'name': 'centos8', 'pre_build_image': True}) 
skipping: [localhost] => (item={'image': 'pycontribs/centos:7', 'name': 'centos7', 'pre_build_image': True}) 
skipping: [localhost] => (item={'image': 'ubuntu:my', 'name': 'ubuntu', 'pre_build_image': True}) 

TASK [Discover local Docker images] ********************************************
ok: [localhost] => (item={'changed': False, 'skipped': True, 'skip_reason': 'Conditional result was False', 'item': {'image': 'pycontribs/centos:8', 'name': 'centos8', 'pre_build_image': True}, 'ansible_loop_var': 'item', 'i': 0, 'ansible_index_var': 'i'})
ok: [localhost] => (item={'changed': False, 'skipped': True, 'skip_reason': 'Conditional result was False', 'item': {'image': 'pycontribs/centos:7', 'name': 'centos7', 'pre_build_image': True}, 'ansible_loop_var': 'item', 'i': 1, 'ansible_index_var': 'i'})
ok: [localhost] => (item={'changed': False, 'skipped': True, 'skip_reason': 'Conditional result was False', 'item': {'image': 'ubuntu:my', 'name': 'ubuntu', 'pre_build_image': True}, 'ansible_loop_var': 'item', 'i': 2, 'ansible_index_var': 'i'})

TASK [Build an Ansible compatible image (new)] *********************************
skipping: [localhost] => (item=molecule_local/pycontribs/centos:8) 
skipping: [localhost] => (item=molecule_local/pycontribs/centos:7) 
skipping: [localhost] => (item=molecule_local/ubuntu:my) 

TASK [Create docker network(s)] ************************************************

TASK [Determine the CMD directives] ********************************************
ok: [localhost] => (item={'image': 'pycontribs/centos:8', 'name': 'centos8', 'pre_build_image': True})
ok: [localhost] => (item={'image': 'pycontribs/centos:7', 'name': 'centos7', 'pre_build_image': True})
ok: [localhost] => (item={'image': 'ubuntu:my', 'name': 'ubuntu', 'pre_build_image': True})

TASK [Create molecule instance(s)] *********************************************
changed: [localhost] => (item=centos8)
changed: [localhost] => (item=centos7)
changed: [localhost] => (item=ubuntu)

TASK [Wait for instance(s) creation to complete] *******************************
changed: [localhost] => (item={'failed': 0, 'started': 1, 'finished': 0, 'ansible_job_id': '565225267588.75377', 'results_file': '/home/alexvk/.ansible_async/565225267588.75377', 'changed': True, 'item': {'image': 'pycontribs/centos:8', 'name': 'centos8', 'pre_build_image': True}, 'ansible_loop_var': 'item'})
changed: [localhost] => (item={'failed': 0, 'started': 1, 'finished': 0, 'ansible_job_id': '155404879532.75395', 'results_file': '/home/alexvk/.ansible_async/155404879532.75395', 'changed': True, 'item': {'image': 'pycontribs/centos:7', 'name': 'centos7', 'pre_build_image': True}, 'ansible_loop_var': 'item'})
changed: [localhost] => (item={'failed': 0, 'started': 1, 'finished': 0, 'ansible_job_id': '295236990526.75412', 'results_file': '/home/alexvk/.ansible_async/295236990526.75412', 'changed': True, 'item': {'image': 'ubuntu:my', 'name': 'ubuntu', 'pre_build_image': True}, 'ansible_loop_var': 'item'})

PLAY RECAP *********************************************************************
localhost                  : ok=5    changed=2    unreachable=0    failed=0    skipped=4    rescued=0    ignored=0

INFO     Running default > prepare
WARNING  Skipping, prepare playbook not configured.
INFO     Running default > converge

PLAY [Converge] ****************************************************************

TASK [Gathering Facts] *********************************************************
ok: [centos8]
ok: [centos7]
ok: [ubuntu]

TASK [Include elastic-role] ****************************************************

PLAY RECAP *********************************************************************
centos7                    : ok=1    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
centos8                    : ok=1    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
ubuntu                     : ok=1    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

INFO     Running default > idempotence

PLAY [Converge] ****************************************************************

TASK [Gathering Facts] *********************************************************
ok: [centos8]
ok: [ubuntu]
ok: [centos7]

TASK [Include elastic-role] ****************************************************

PLAY RECAP *********************************************************************
centos7                    : ok=1    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
centos8                    : ok=1    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
ubuntu                     : ok=1    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

INFO     Idempotence completed successfully.
INFO     Running default > side_effect
WARNING  Skipping, side effect playbook not configured.
INFO     Running default > verify
INFO     Running Ansible Verifier

PLAY [Verify] ******************************************************************

TASK [Example assertion] *******************************************************
ok: [centos7] => {
    "changed": false,
    "msg": "All assertions passed"
}
ok: [centos8] => {
    "changed": false,
    "msg": "All assertions passed"
}
ok: [ubuntu] => {
    "changed": false,
    "msg": "All assertions passed"
}

PLAY RECAP *********************************************************************
centos7                    : ok=1    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
centos8                    : ok=1    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
ubuntu                     : ok=1    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

INFO     Verifier completed successfully.
INFO     Running default > cleanup
WARNING  Skipping, cleanup playbook not configured.
INFO     Running default > destroy

PLAY [Destroy] *****************************************************************

TASK [Destroy molecule instance(s)] ********************************************
changed: [localhost] => (item=centos8)
changed: [localhost] => (item=centos7)
changed: [localhost] => (item=ubuntu)

TASK [Wait for instance(s) deletion to complete] *******************************
changed: [localhost] => (item=centos8)
changed: [localhost] => (item=centos7)
changed: [localhost] => (item=ubuntu)

TASK [Delete docker networks(s)] ***********************************************

PLAY RECAP *********************************************************************
localhost                  : ok=2    changed=2    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0

INFO     Pruning extra files from scenario ephemeral directory
[alexvk@archbox elastic-role]$ 
```

Тесты пройдены.

5. При попытке создать роль с помощью `molecule init` получаю сообщение:
```
[alexvk@archbox tmp]$ molecule init role kibana-role  --driver-name docker
CRITICAL Outside collections you must mention role namespace like: molecule init role 'acme.myrole'. Be sure you use only lowercase characters and underlines. See https://galaxy.ansible.com/docs/contributing/creating_role.html
```
Чтение документации прояснило причину. Для обхода вынужденных улучшений использую инициализацию по всем правилам:
```
[alexvk@archbox kibana-role]$ molecule init role 'my.kibana_role' --driver-name docker
INFO     Initializing new role kibana_role...
Invalid -W option ignored: unknown warning category: 'CryptographyDeprecationWarning'
Using /etc/ansible/ansible.cfg as config file
- Role kibana_role was created successfully
Invalid -W option ignored: unknown warning category: 'CryptographyDeprecationWarning'
[WARNING]: No inventory was parsed, only implicit localhost is available
localhost | CHANGED => {"backup": "","changed": true,"msg": "line added"}
INFO     Initialized role in /home/alexvk/learn/devops/git/kibana-role/kibana_role successfully.
```
Затем во всех yaml-файлах проекта заменяю параметры на желаемые. Костыли, но что делать некуда. 

6. Выполнено, результат в [playbook](https://github.com/alexkrupenya/devops-netology/tree/main/ansible/8.3/playbook)

7. Выполнено, результат в репозиториях [elastic-role](https://github.com/alexkrupenya/elastic-role/tree/0.1.1) и [kibana](https://github.com/alexkrupenya/kibana-role/tree/0.1.1)

8. Выполнено, [здесь](https://github.com/alexkrupenya/devops-netology/tree/main/ansible/8.3/playbook/requirements.yml)

9. Скачаю роли с помощью `ansible-galaxy install -r requirements.yml --roles-path roles/` и выполню playbook с использованием ролей:
```
[alexvk@archbox playbook]$ ansible-playbook site.yml -i inventory/prod.yml 

PLAY [all] ******************************************************************************************************************************************

TASK [Gathering Facts] ******************************************************************************************************************************
ok: [kbn]
ok: [esh]

TASK [java-role : Upload .tar.gz file containing binaries from local storage] ***********************************************************************
skipping: [esh]
skipping: [kbn]

TASK [java-role : Upload .tar.gz file conaining binaries from remote storage] ***********************************************************************
changed: [esh]
changed: [kbn]

TASK [java-role : Ensure installation dir exists] ***************************************************************************************************
changed: [esh]
changed: [kbn]

TASK [java-role : Extract java in the installation directory] ***************************************************************************************
changed: [esh]
changed: [kbn]

TASK [java-role : Export environment variables] *****************************************************************************************************
changed: [esh]
changed: [kbn]

PLAY [elasticsearch] ********************************************************************************************************************************

TASK [Gathering Facts] ******************************************************************************************************************************
ok: [esh]

TASK [elastic-role : Upload tar.gz Elasticsearch from remote URL] ***********************************************************************************
changed: [esh]

TASK [elastic-role : Create directrory for Elasticsearch] *******************************************************************************************
changed: [esh]

TASK [elastic-role : Extract Elasticsearch in the installation directory] ***************************************************************************
changed: [esh]

TASK [elastic-role : Set environment Elastic] *******************************************************************************************************
changed: [esh]

PLAY [kibana] ***************************************************************************************************************************************

TASK [Gathering Facts] ******************************************************************************************************************************
ok: [kbn]

TASK [kibana-role : Upload tar.gz Kibana from remote URL] *******************************************************************************************
changed: [kbn]

TASK [kibana-role : Create directrory for Kibana (/opt/kibana/7.17.3)] ******************************************************************************
changed: [kbn]

TASK [kibana-role : Extract Kibana in the installation directory] ***********************************************************************************
changed: [kbn]

TASK [kibana-role : Set environment Kibana] *********************************************************************************************************
changed: [kbn]

PLAY RECAP ******************************************************************************************************************************************
esh                        : ok=10   changed=8    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0   
kbn                        : ok=10   changed=8    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0   
```

## Необязательная часть

1. Проделайте схожие манипуляции для создания роли logstash.
2. Создайте дополнительный набор tasks, который позволяет обновлять стек ELK.
3. В ролях добавьте тестирование в раздел `verify.yml`. Данный раздел должен проверять, что elastic запущен и возвращает успешный статус по API, web-интерфейс kibana отвечает без кодов ошибки, logstash через команду `logstash -e 'input { stdin { } } output { stdout {} }'`.
4. Убедитесь в работоспособности своего стека. Возможно, потребуется тестировать все роли одновременно.
5. Выложите свои roles в репозитории. В ответ приведите ссылки.

---

### Как оформить ДЗ?

Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.

---
