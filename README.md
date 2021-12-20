# Домашнее задание к занятию "4.2. Использование Python для решения типовых DevOps задач"

## Обязательная задача 1

Есть скрипт:
```python
#!/usr/bin/env python3
a = 1
b = '2'
c = a + b
```

### Вопросы:
| Вопрос  | Ответ |
| ------------- | ------------- |
| Какое значение будет присвоено переменной `c`?  | Получим error - сложение для  разных типов данных |
| Как получить для переменной `c` значение 12?  | Нужно преобразовать переменную a в string: c = str (a) + b  |
| Как получить для переменной `c` значение 3?  | Нужно преобразовать переменную b в int: c = a + int(b)  |

## Обязательная задача 2
Мы устроились на работу в компанию, где раньше уже был DevOps Engineer. Он написал скрипт, позволяющий узнать, какие файлы модифицированы в репозитории, относительно локальных изменений. Этим скриптом недовольно начальство, потому что в его выводе есть не все изменённые файлы, а также непонятен полный путь к директории, где они находятся. Как можно доработать скрипт ниже, чтобы он исполнял требования вашего руководителя?

```python
#!/usr/bin/env python3

import os

bash_command = ["cd ~/netology/sysadm-homeworks", "git status"]
result_os = os.popen(' && '.join(bash_command)).read()
is_change = False
for result in result_os.split('\n'):
    if result.find('modified') != -1:
        prepare_result = result.replace('\tmodified:   ', '')
        print(prepare_result)
        break
```

### Ваш скрипт:
```python
#!/usr/bin/env python3

import os

bash_command = ["~/netology/sysadm-homeworks", "git status"]
result_os = os.popen(' && '.join(bash_command)).read()
# Не нашел, куда приткнуть переменную is_change булевого типа
# поэтому просто ее закомментировал. Считаю ее артефактом
# от предыдущих версий
# is_change = False
for result in result_os.split('\n'):
    if result.find('modified') != -1:
        prepare_result = result.replace('\tmodified:   ', '')
        print(prepare_result)
#       Оператор break не нужен, т.к. прерывает выполнение цикла поиска
#       при нахождении первого вхождения, поэтому закомментирую его.
#        break

```

### Вывод скрипта при запуске при тестировании:
```
[alexvk@archbox sysadm-homeworks]$ ls -a
.  ..  123.txt  .git  test.py
[alexvk@archbox sysadm-homeworks]$ git status
On branch master

No commits yet

Changes to be committed:
  (use "git rm --cached <file>..." to unstage)
        new file:   123.txt
        new file:   test.py

Changes not staged for commit:
  (use "git add <file>..." to update what will be committed)
  (use "git restore <file>..." to discard changes in working directory)
        modified:   123.txt
        modified:   test.py

[alexvk@archbox sysadm-homeworks]$ ./test.py 
123.txt
test.py
[alexvk@archbox sysadm-homeworks]$
```

## Обязательная задача 3
1. Доработать скрипт выше так, чтобы он мог проверять не только локальный репозиторий в текущей директории, а также умел воспринимать путь к репозиторию, который мы передаём как входной параметр. Мы точно знаем, что начальство коварное и будет проверять работу этого скрипта в директориях, которые не являются локальными репозиториями.

### Ваш скрипт:
```python
#!/usr/bin/env python3

import os
# Для передачи аргументов скрипту требуется модуль sys
import sys

# Переменная для определения пути репозитория. Считаю, что
# путь можно передавать только один.
git_path = sys.argv[1]
bash_command = ["cd"+" "+git_path, "git status"]
result_os = os.popen(' && '.join(bash_command)).read()
# Не нашел, куда приткнуть переменную is_change булевого типа
# поэтому просто ее закомментировал. Считаю ее артефактом
# от предыдущих версий
# is_change = False
for result in result_os.split('\n'):
    if result.find('modified') != -1:
        prepare_result = result.replace('\tmodified:   ', '')
        #Сделал более информативный вывод и добавил путь 
        print("modified file:",prepare_result,"at path",git_path)
#       Оператор break не нужен, т.к. прерывает выполнение цикла поиска
#       при нахождении первого вхождения, поэтому закомментирую его.
#        break

```

### Вывод скрипта при запуске при тестировании:
```
[alexvk@archbox ~]$ ~/netology/sysadm-homeworks/test.py ~/netology/sysadm-homeworks/
modified file: 123.txt at path /home/alexvk/netology/sysadm-homeworks/
modified file: test.py at path /home/alexvk/netology/sysadm-homeworks/
[alexvk@archbox ~]$ 


```

## Обязательная задача 4
1. Наша команда разрабатывает несколько веб-сервисов, доступных по http. Мы точно знаем, что на их стенде нет никакой балансировки, кластеризации, за DNS прячется конкретный IP сервера, где установлен сервис. Проблема в том, что отдел, занимающийся нашей инфраструктурой очень часто меняет нам сервера, поэтому IP меняются примерно раз в неделю, при этом сервисы сохраняют за собой DNS имена. Это бы совсем никого не беспокоило, если бы несколько раз сервера не уезжали в такой сегмент сети нашей компании, который недоступен для разработчиков. Мы хотим написать скрипт, который опрашивает веб-сервисы, получает их IP, выводит информацию в стандартный вывод в виде: <URL сервиса> - <его IP>. Также, должна быть реализована возможность проверки текущего IP сервиса c его IP из предыдущей проверки. Если проверка будет провалена - оповестить об этом в стандартный вывод сообщением: [ERROR] <URL сервиса> IP mismatch: <старый IP> <Новый IP>. Будем считать, что наша разработка реализовала сервисы: `drive.google.com`, `mail.google.com`, `google.com`.

### Ваш скрипт:
```python
#!/usr/bin/env python3

# Работаю с ip
import socket 
# Работаю с Таймером
import time 
# Рандомайзер паузы для опроса
import random

# Определяю словарь парой хост - ip адрес
dest = {'drive.google.com':'', 'mail.google.com':'', 'google.com':''}
# Инициализирую словарь реальными ip адресами
for i in dest:
    dest[i] = socket.gethostbyname(i)
# Основной цикл проверки. Цикл бесконечный, выход по Ctrl-C; выхода по условию не предусмотрено
# Перебор значений из словаря и сравнение ip адресов.
# В случае несовпадения присваиваю новый адрес и показываю ошибку
# После проверки спать случайное время от 3 до 9 сек.
while True : 
  for aim in dest:
    addr = socket.gethostbyname(aim)
    if addr != dest[aim]:
      print ('[ERROR]', aim, 'IP mismatch:', dest[aim], addr)
      dest[aim] = addr
  time.sleep(random.randint(3,9))
```

### Вывод скрипта при запуске при тестировании:
```
[alexvk@archbox devops]$ ./servtest.py 
[ERROR] mail.google.com IP mismatch: 74.125.131.19 74.125.131.17
[ERROR] google.com IP mismatch: 173.194.73.101 173.194.73.113
[ERROR] mail.google.com IP mismatch: 74.125.131.17 74.125.131.19
[ERROR] google.com IP mismatch: 173.194.73.113 173.194.73.100
[ERROR] mail.google.com IP mismatch: 74.125.131.19 74.125.131.17
[ERROR] google.com IP mismatch: 173.194.73.100 173.194.73.138
[ERROR] mail.google.com IP mismatch: 74.125.131.17 74.125.131.19
[ERROR] google.com IP mismatch: 173.194.73.138 173.194.73.139
[ERROR] mail.google.com IP mismatch: 74.125.131.19 74.125.131.17
[ERROR] google.com IP mismatch: 173.194.73.139 173.194.73.102
[ERROR] google.com IP mismatch: 173.194.73.102 173.194.73.101
[ERROR] mail.google.com IP mismatch: 74.125.131.17 74.125.131.19
[ERROR] google.com IP mismatch: 173.194.73.101 173.194.73.113
^CTraceback (most recent call last):
  File "/home/alexvk/learn/devops/./servtest.py", line 25, in <module>
    time.sleep(random.randint(3,9))
KeyboardInterrupt
```

