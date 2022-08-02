# Домашнее задание к занятию "08.04 Создание собственных modules"

## Подготовка к выполнению
1. *Создайте пустой публичных репозиторий в любом своём проекте: `my_own_collection`*
2. *Скачайте репозиторий ansible: `git clone https://github.com/ansible/ansible.git` по любому удобному вам пути*
3. *Зайдите в директорию ansible: `cd ansible`*
4. *Создайте виртуальное окружение: `python3 -m venv venv`*
5. *Активируйте виртуальное окружение: `. venv/bin/activate`. Дальнейшие действия производятся только в виртуальном окружении*
6. *Установите зависимости `pip install -r requirements.txt`*
7. *Запустить настройку окружения `. hacking/env-setup`*
8. *Если все шаги прошли успешно - выйти из виртуального окружения `deactivate`*
9. *Ваше окружение настроено, для того чтобы запустить его, нужно находиться в директории `ansible` и выполнить конструкцию `. venv/bin/activate && . hacking/env-setup`*

### Решение:

Клонирую репозиторий ansible `git clone git@github.com:ansible/ansbile.git`. Листинг не привожу, все тривиально и много текста.

Далее выполняю вышеприведенную инструкцию:

```
[alexvk@archbox 8.4]$ cd ansible
[alexvk@archbox ansible]$ python3 -m venv venv
[alexvk@archbox ansible]$ . venv/bin/activate
(venv) [alexvk@archbox ansible]$ pip install -r requirements.txt 
Collecting jinja2>=3.0.0
  Downloading Jinja2-3.1.2-py3-none-any.whl (133 kB)
     ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 133.1/133.1 KB 686.1 kB/s eta 0:00:00
Collecting PyYAML>=5.1
  Downloading PyYAML-6.0-cp310-cp310-manylinux_2_5_x86_64.manylinux1_x86_64.manylinux_2_12_x86_64.manylinux2010_x86_64.whl (682 kB)
     ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 682.2/682.2 KB 1.8 MB/s eta 0:00:00
Collecting cryptography
  Downloading cryptography-37.0.4-cp36-abi3-manylinux_2_24_x86_64.whl (4.1 MB)
     ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 4.1/4.1 MB 2.9 MB/s eta 0:00:00
Collecting packaging
  Downloading packaging-21.3-py3-none-any.whl (40 kB)
     ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 40.8/40.8 KB 5.1 MB/s eta 0:00:00
Collecting resolvelib<0.9.0,>=0.5.3
  Downloading resolvelib-0.8.1-py2.py3-none-any.whl (16 kB)
Collecting MarkupSafe>=2.0
  Downloading MarkupSafe-2.1.1-cp310-cp310-manylinux_2_17_x86_64.manylinux2014_x86_64.whl (25 kB)
Collecting cffi>=1.12
  Downloading cffi-1.15.1-cp310-cp310-manylinux_2_17_x86_64.manylinux2014_x86_64.whl (441 kB)
     ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 441.8/441.8 KB 4.7 MB/s eta 0:00:00
Collecting pyparsing!=3.0.5,>=2.0.2
  Downloading pyparsing-3.0.9-py3-none-any.whl (98 kB)
     ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 98.3/98.3 KB 10.3 MB/s eta 0:00:00
Collecting pycparser
  Downloading pycparser-2.21-py2.py3-none-any.whl (118 kB)
     ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 118.7/118.7 KB 7.0 MB/s eta 0:00:00
Installing collected packages: resolvelib, PyYAML, pyparsing, pycparser, MarkupSafe, packaging, jinja2, cffi, cryptography
Successfully installed MarkupSafe-2.1.1 PyYAML-6.0 cffi-1.15.1 cryptography-37.0.4 jinja2-3.1.2 packaging-21.3 pycparser-2.21 pyparsing-3.0.9 resolvelib-0.8.1
WARNING: You are using pip version 22.0.4; however, version 22.2.1 is available.
You should consider upgrading via the '/home/alexvk/learn/devops/ansible/8.4/ansible/venv/bin/python3 -m pip install --upgrade pip' command.
(venv) [alexvk@archbox ansible]$ . hacking/env-setup
running egg_info
creating lib/ansible_core.egg-info
writing lib/ansible_core.egg-info/PKG-INFO
writing dependency_links to lib/ansible_core.egg-info/dependency_links.txt
writing entry points to lib/ansible_core.egg-info/entry_points.txt
writing requirements to lib/ansible_core.egg-info/requires.txt
writing top-level names to lib/ansible_core.egg-info/top_level.txt
writing manifest file 'lib/ansible_core.egg-info/SOURCES.txt'
reading manifest file 'lib/ansible_core.egg-info/SOURCES.txt'
reading manifest template 'MANIFEST.in'
warning: no files found matching 'SYMLINK_CACHE.json'
warning: no previously-included files found matching 'docs/docsite/rst_warnings'
warning: no previously-included files found matching 'docs/docsite/rst/conf.py'
warning: no previously-included files found matching 'docs/docsite/rst/index.rst'
warning: no previously-included files found matching 'docs/docsite/rst/dev_guide/index.rst'
warning: no previously-included files matching '*' found under directory 'docs/docsite/_build'
warning: no previously-included files matching '*.pyc' found under directory 'docs/docsite/_extensions'
warning: no previously-included files matching '*.pyo' found under directory 'docs/docsite/_extensions'
warning: no files found matching '*.ps1' under directory 'lib/ansible/modules/windows'
warning: no files found matching '*.yml' under directory 'lib/ansible/modules'
warning: no files found matching 'validate-modules' under directory 'test/lib/ansible_test/_util/controller/sanity/validate-modules'
adding license file 'COPYING'
writing manifest file 'lib/ansible_core.egg-info/SOURCES.txt'

Setting up Ansible to run out of checkout...

PATH=/home/alexvk/learn/devops/ansible/8.4/ansible/bin:/home/alexvk/learn/devops/ansible/8.4/ansible/venv/bin:/usr/local/bin:/home/alexvk/files/yandex/yandex-cloud/bin:/usr/local/bin:/home/alexvk/files/yandex/yandex-cloud/bin:/usr/local/sbin:/usr/local/bin:/usr/bin:/usr/lib/jvm/default/bin:/usr/bin/site_perl:/usr/bin/vendor_perl:/usr/bin/core_perl
PYTHONPATH=/home/alexvk/learn/devops/ansible/8.4/ansible/test/lib:/home/alexvk/learn/devops/ansible/8.4/ansible/lib
MANPATH=/home/alexvk/learn/devops/ansible/8.4/ansible/docs/man:/usr/local/man:/usr/local/share/man:/usr/share/man:/usr/lib/jvm/default/man

Remember, you may wish to specify your host file with -i

Done!

(venv) [alexvk@archbox ansible]$ deactivate 
[alexvk@archbox ansible]$ 

```

## Основная часть

*Наша цель - написать собственный module, который мы можем использовать в своей role, через playbook. Всё это должно быть собрано в виде collection и отправлено в наш репозиторий.*

1. *В виртуальном окружении создать новый `my_own_module.py` файл*
2. *Наполнить его содержимым:*
```python
#!/usr/bin/python

# Copyright: (c) 2018, Terry Jones <terry.jones@example.org>
# GNU General Public License v3.0+ (see COPYING or https://www.gnu.org/licenses/gpl-3.0.txt)
from __future__ import (absolute_import, division, print_function)
__metaclass__ = type

DOCUMENTATION = r'''
---
module: my_test

short_description: This is my test module

# If this is part of a collection, you need to use semantic versioning,
# i.e. the version is of the form "2.5.0" and not "2.4".
version_added: "1.0.0"

description: This is my longer description explaining my test module.

options:
    name:
        description: This is the message to send to the test module.
        required: true
        type: str
    new:
        description:
            - Control to demo if the result of this module is changed or not.
            - Parameter description can be a list as well.
        required: false
        type: bool
# Specify this value according to your collection
# in format of namespace.collection.doc_fragment_name
extends_documentation_fragment:
    - my_namespace.my_collection.my_doc_fragment_name

author:
    - Your Name (@yourGitHubHandle)
'''

EXAMPLES = r'''
# Pass in a message
- name: Test with a message
  my_namespace.my_collection.my_test:
    name: hello world

# pass in a message and have changed true
- name: Test with a message and changed output
  my_namespace.my_collection.my_test:
    name: hello world
    new: true

# fail the module
- name: Test failure of the module
  my_namespace.my_collection.my_test:
    name: fail me
'''

RETURN = r'''
# These are examples of possible return values, and in general should use other names for return values.
original_message:
    description: The original name param that was passed in.
    type: str
    returned: always
    sample: 'hello world'
message:
    description: The output message that the test module generates.
    type: str
    returned: always
    sample: 'goodbye'
'''

from ansible.module_utils.basic import AnsibleModule


def run_module():
    # define available arguments/parameters a user can pass to the module
    module_args = dict(
        name=dict(type='str', required=True),
        new=dict(type='bool', required=False, default=False)
    )

    # seed the result dict in the object
    # we primarily care about changed and state
    # changed is if this module effectively modified the target
    # state will include any data that you want your module to pass back
    # for consumption, for example, in a subsequent task
    result = dict(
        changed=False,
        original_message='',
        message=''
    )

    # the AnsibleModule object will be our abstraction working with Ansible
    # this includes instantiation, a couple of common attr would be the
    # args/params passed to the execution, as well as if the module
    # supports check mode
    module = AnsibleModule(
        argument_spec=module_args,
        supports_check_mode=True
    )

    # if the user is working with this module in only check mode we do not
    # want to make any changes to the environment, just return the current
    # state with no modifications
    if module.check_mode:
        module.exit_json(**result)

    # manipulate or modify the state as needed (this is going to be the
    # part where your module will do what it needs to do)
    result['original_message'] = module.params['name']
    result['message'] = 'goodbye'

    # use whatever logic you need to determine whether or not this module
    # made any modifications to your target
    if module.params['new']:
        result['changed'] = True

    # during the execution of the module, if there is an exception or a
    # conditional state that effectively causes a failure, run
    # AnsibleModule.fail_json() to pass in the message and the result
    if module.params['name'] == 'fail me':
        module.fail_json(msg='You requested this to fail', **result)

    # in the event of a successful module execution, you will want to
    # simple AnsibleModule.exit_json(), passing the key/value results
    module.exit_json(**result)


def main():
    run_module()


if __name__ == '__main__':
    main()
```
*Или возьмите данное наполнение из [статьи](https://docs.ansible.com/ansible/latest/dev_guide/developing_modules_general.html#creating-a-module).*

3. *Заполните файл в соответствии с требованиями ansible так, чтобы он выполнял основную задачу: module должен создавать текстовый файл на удалённом хосте по пути, определённом в параметре `path`, с содержимым, определённым в параметре `content`.*
4. *Проверьте module на исполняемость локально.*
5. *Напишите single task playbook и используйте module в нём.*
6. *Проверьте через playbook на идемпотентность.*
7. *Выйдите из виртуального окружения.*
8. *Инициализируйте новую collection: `ansible-galaxy collection init my_own_namespace.my_own_collection`*
9. *В данную collection перенесите свой module в соответствующую директорию.*
10. *Single task playbook преобразуйте в single task role и перенесите в collection. У role должны быть default всех параметров module*
11. *Создайте playbook для использования этой role.*
12. *Заполните всю документацию по collection, выложите в свой репозиторий, поставьте тег `1.0.0` на этот коммит.*
13. *Создайте .tar.gz этой collection: `ansible-galaxy collection build` в корневой директории collection.*
14. *Создайте ещё одну директорию любого наименования, перенесите туда single task playbook и архив c collection.*
15. *Установите collection из локального архива: `ansible-galaxy collection install <archivename>.tar.gz`*
16. *Запустите playbook, убедитесь, что он работает.*
17. *В ответ необходимо прислать ссылку на репозиторий с collection*

### Решение

1. Выполнено, создан файл library/my_own_collection. 

2. Создал модуль [по документации](https://docs.ansible.com/ansible/latest/dev_guide/developing_modules_general.html#creating-a-module). По той же документации создал текстовый файл [args.json](src/args.json.orig).

Переместил файл `my_own_module.py` в каталог `lib/modules`.

Результат запуска модуля:
```
(venv) [alexvk@archbox ansible]$ python -m ansible.modules.my_own_module library/args.json 

{"changed": true, "original_message": "hello", "message": "goodbye", "invocation": {"module_args": {"name": "hello", "new": true}}} 
```

3. Создал по шаблону [свой модуль](src/my_own_module.py) для создания текстового файла с содержимым в переменной `content` по указанному пути `path` на удаленной машине. Соответственно поменял содержимое файла [src/args.json](src/args.json).

4. Локальная проверка:
```
(venv) [alexvk@archbox ansible]$ python -m ansible.modules.my_own_module library/args.json

{"changed": true, "original_message": "this is a test", "message": "File has been created", "invocation": {"module_args": {"path": "/home/alexvk/test.txt", "content": "this is a test"}}}
(venv) [alexvk@archbox ansible]$ python -m ansible.modules.my_own_module library/args.json

{"changed": false, "original_message": "this is a test", "message": "File exists", "invocation": {"module_args": {"path": "/home/alexvk/test.txt", "content": "this is a test"}}}
(venv) [alexvk@archbox ansible]$ 
```

Файл был создан, и его наличие также обработано. Считаю тест успешным.

5. Создал [playbook](src/site.yml).

6. Запускаю playbook:
```
(venv) [alexvk@archbox ansible]$ ansible-playbook library/site.yml 
[WARNING]: You are running the development version of Ansible. You should only run Ansible from "devel" if you are modifying the Ansible engine, or
trying out features under development. This is a rapidly changing source of code and can become unstable at any point.
[WARNING]: No inventory was parsed, only implicit localhost is available
[WARNING]: provided hosts list is empty, only localhost is available. Note that the implicit localhost does not match 'all'

PLAY [My module is at work] *************************************************************************************************************************

TASK [Gathering Facts] ******************************************************************************************************************************
ok: [localhost]

TASK [Make a file] **********************************************************************************************************************************
changed: [localhost]

PLAY RECAP ******************************************************************************************************************************************
localhost                  : ok=2    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
```

Повторно запускаю playbook, чтобы убедиться в идентичности результата:
```
venv) [alexvk@archbox ansible]$ ansible-playbook library/site.yml 
[WARNING]: You are running the development version of Ansible. You should only run Ansible from "devel" if you are modifying the Ansible engine, or
trying out features under development. This is a rapidly changing source of code and can become unstable at any point.
[WARNING]: No inventory was parsed, only implicit localhost is available
[WARNING]: provided hosts list is empty, only localhost is available. Note that the implicit localhost does not match 'all'

PLAY [My module is at work] *************************************************************************************************************************

TASK [Gathering Facts] ******************************************************************************************************************************
ok: [localhost]

TASK [Make a file] **********************************************************************************************************************************
ok: [localhost]

PLAY RECAP ******************************************************************************************************************************************
localhost                  : ok=2    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
```

Посмотрев на файл в каталоге, указанном в args.json, убеждаюсь в том, что файл после повторного запуска playbook никуда не делся. Содержимое файла осталось неизменным. Таким образом, считаю playbook идемпотентным. 

7. Выход из виртуального окружения.
```
(venv) [alexvk@archbox ansible]$ deactivate 
[alexvk@archbox ansible]$ 
```

8. Инциализация collection:
```
[alexvk@archbox 8.4]$ ansible-galaxy collection init my_own_namespace.my_own_collection
[WARNING]: You are running the development version of Ansible. You should only run Ansible from "devel" if you are modifying the Ansible engine, or
trying out features under development. This is a rapidly changing source of code and can become unstable at any point.
- Collection my_own_namespace.my_own_collection was created successfully
[alexvk@archbox 8.4]$ 
```

Collection создана успешно.

9. Просмотр readme в структуре collection показал, что нужно перенести свой модуль `my_own_module.py` в каталог `plugins/modules`. 
```
[alexvk@archbox my_own_namespace]$ tree my_own_collection 
my_own_collection
├── docs
├── galaxy.yml
├── plugins
│   ├── modules
│   │   └── my_own_module.py
│   └── README.md
├── README.md
└── roles

4 directories, 4 files
```

10. Создал `my_own_module_role`
```
[alexvk@archbox 8.4]$ ansible-galaxy init my_own_module_role
- Role my_own_module_role was created successfully
```

11. Создал [playbook](playbook/site.yml) для использования роли.

12. Выполнено, выложено [сюда](https://github.com/alexkrupenya/my_own_collection).

13. Собираю коллекцию:
```
[alexvk@archbox mycollection]$ ansible-galaxy collection build
Created collection for my_own_namespace.mycollection at /home/alexvk/learn/devops/ansible/8.4/my_own_namespace-mycollection-1.0.0.tar.gz
```

14. Перенес playbook и архив в каталог ~/tmp.
```
[alexvk@archbox tmp]$ ls 
my_own_namespace-mycollection-1.0.0.tar.gz  site.yml
```

15. Установка collection из архива:
```
[alexvk@archbox tmp]$ ansible-galaxy collection install --force  my_own_namespace-mycollection-1.0.0.tar.gz 
Starting galaxy collection install process
Process install dependency map
Starting collection install process
Installing 'my_own_namespace.mycollection:1.0.0' to '/home/alexvk/.cache/ansible-compat/38a096/collections/ansible_collections/my_own_namespace/mycollection'
my_own_namespace.mycollection:1.0.0 was installed successfully
```

16. Проверка работоспособности playbook:
```
[alexvk@archbox tmp]$ ansible-playbook site.yml 
[WARNING]: No inventory was parsed, only implicit localhost is available
[WARNING]: provided hosts list is empty, only localhost is available. Note that the implicit localhost does not match 'all'

PLAY [Test for sample file module] ******************************************************************************************************************

TASK [Gathering Facts] ******************************************************************************************************************************
ok: [localhost]

TASK [Make a file] **********************************************************************************************************************************
changed: [localhost]

PLAY RECAP ******************************************************************************************************************************************
localhost                  : ok=2    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
```

И второй запуск:
```
[alexvk@archbox tmp]$ ansible-playbook site.yml 
[WARNING]: No inventory was parsed, only implicit localhost is available
[WARNING]: provided hosts list is empty, only localhost is available. Note that the implicit localhost does not match 'all'

PLAY [Test for sample file module] ******************************************************************************************************************

TASK [Gathering Facts] ******************************************************************************************************************************
ok: [localhost]

TASK [Make a file] **********************************************************************************************************************************
ok: [localhost]

PLAY RECAP ******************************************************************************************************************************************
localhost                  : ok=2    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
```

17. [Ссылка на репозиторий с коллекцией](https://github.com/alexkrupenya/my_own_collection)

## Необязательная часть

1. Используйте свой полёт фантазии: Создайте свой собственный module для тех roles, что мы делали в рамках предыдущих лекций.
2. Соберите из roles и module отдельную collection.
3. Создайте новый репозиторий и выложите новую collection туда.

Если идей нет, но очень хочется попробовать что-то реализовать: реализовать module восстановления из backup elasticsearch.

---

### Как оформить ДЗ?

Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.

---
