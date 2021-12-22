# Домашнее задание к занятию "4.3. Языки разметки JSON и YAML"


## Обязательная задача 1
Мы выгрузили JSON, который получили через API запрос к нашему сервису:
```
    { "info" : "Sample JSON output from our service\t",
        "elements" :[
            { "name" : "first",
            "type" : "server",
            "ip" : 7175 
            }
            { "name" : "second",
            "type" : "proxy",
            "ip : 71.78.22.43
            }
        ]
    }
```
  Нужно найти и исправить все ошибки, которые допускает наш сервис  
##### Решение:
```json=
01:    { "info" : "Sample JSON output from our service\t",
02:        "elements" :[
03:            { "name" : "first",
04:            "type" : "server",
05:            "ip" : 7175 
06:            },
07:            { "name" : "second",
08:            "type" : "proxy",
09:            "ip" : "71.78.22.43"
10:            }
11:        ]
12:    }
```
В строке 6 пропущена запятая в описании элементов массива; в строке 9 пропущена кавычка после "ip, а ip адрес не взят в кавычки вообще.
 
## Обязательная задача 2
В прошлый рабочий день мы создавали скрипт, позволяющий опрашивать веб-сервисы и получать их IP. К уже реализованному функционалу нам нужно добавить возможность записи JSON и YAML файлов, описывающих наши сервисы. Формат записи JSON по одному сервису: `{ "имя сервиса" : "его IP"}`. Формат записи YAML по одному сервису: `- имя сервиса: его IP`. Если в момент исполнения скрипта меняется IP у сервиса - он должен так же поменяться в yml и json файле.  
##### Решение:
Не совсем ясно, необходимо создавать json и yaml описания в отдельном файле для каждого сервиса, либо создавать
файл с описанием всех сервисов сразу. Потому реализую оба варианта в одном скрипте.
### Ваш скрипт:
```python
#!/usr/bin/env python3

# Работаю с ip
import socket 
# Работаю с Таймером
import time 
# Рандомайзер паузы для опроса
import random
# Работаю с JSON
import json
#Работаю с YAML
import yaml

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
      #вывод ip адреса сервиса в выделенный json файл
    with open (aim+".json","w") as json_log:
      json_log.write (json.dumps({aim:dest[aim]}))
    #вывод ip адреса сервиса в выделенный yaml файл
    with open (aim+".yaml","w") as yaml_log:
        yaml_log.write (yaml.dump([{aim:dest[aim]}]))
  #Сливаем сервисы в один файл 
  #определяю переменную типа list для структурирования вывода json и yaml
  output = []
  #заполняю list списками значений
  for i in dest:
    output.append ({i:dest[i]})
  #вывод в файлы yaml и json
  with open ("services.yaml","w") as file:
    documents = yaml.dump (output,file,default_flow_style=False)
  with open ("services.json","w") as file:
    file.write (json.dumps(output))
  time.sleep (random.randint(3,9))
```

### Вывод скрипта при запуске при тестировании:
```
[alexvk@archbox devops]$ ./test_google.py 
[ERROR] mail.google.com IP mismatch: 142.251.1.19 142.251.1.18
[ERROR] google.com IP mismatch: 173.194.222.101 173.194.222.102
[ERROR] mail.google.com IP mismatch: 142.251.1.18 142.251.1.19
[ERROR] google.com IP mismatch: 173.194.222.102 173.194.222.138
[ERROR] mail.google.com IP mismatch: 142.251.1.19 142.251.1.18
[ERROR] google.com IP mismatch: 173.194.222.138 173.194.222.139
[ERROR] mail.google.com IP mismatch: 142.251.1.18 142.251.1.19
[ERROR] google.com IP mismatch: 173.194.222.139 173.194.222.113
[ERROR] mail.google.com IP mismatch: 142.251.1.19 142.251.1.18
[ERROR] google.com IP mismatch: 173.194.222.113 173.194.222.100
[ERROR] mail.google.com IP mismatch: 142.251.1.18 142.251.1.19
[ERROR] google.com IP mismatch: 173.194.222.100 173.194.222.101
[ERROR] mail.google.com IP mismatch: 142.251.1.19 142.251.1.18
[ERROR] google.com IP mismatch: 173.194.222.101 173.194.222.102
[ERROR] mail.google.com IP mismatch: 142.251.1.18 142.251.1.19
[ERROR] google.com IP mismatch: 173.194.222.102 173.194.222.138
[ERROR] mail.google.com IP mismatch: 142.251.1.19 142.251.1.18
[ERROR] google.com IP mismatch: 173.194.222.138 173.194.222.139
[ERROR] mail.google.com IP mismatch: 142.251.1.18 142.251.1.19
[ERROR] google.com IP mismatch: 173.194.222.139 173.194.222.113
[ERROR] mail.google.com IP mismatch: 142.251.1.19 142.251.1.18
[ERROR] google.com IP mismatch: 173.194.222.113 173.194.222.100
^CTraceback (most recent call last):
  File "/home/alexvk/learn/devops/./test_google.py", line 46, in <module>
    time.sleep (random.randint(3,9))
KeyboardInterrupt
```

### json-файл(ы), который(е) записал ваш скрипт:
```json
[alexvk@archbox devops]$ cat drive.google.com.json 
{"drive.google.com": "108.177.14.194"}
[alexvk@archbox devops]$ cat mail.google.com.json 
{"mail.google.com": "142.251.1.18"} 
[alexvk@archbox devops]$ cat google.com.json 
{"google.com": "173.194.222.100"} 
[alexvk@archbox devops]$ cat services.json 
[{"drive.google.com": "108.177.14.194"}, {"mail.google.com": "142.251.1.18"}, {"google.com": "173.194.222.100"}]
```

### yml-файл(ы), который(е) записал ваш скрипт:
```yaml
[alexvk@archbox devops]$ cat drive.google.com.yaml 
- drive.google.com: 108.177.14.194
[alexvk@archbox devops]$ cat mail.google.com.yaml 
- mail.google.com: 142.251.1.18
[alexvk@archbox devops]$ cat google.com.yaml 
- google.com: 173.194.222.100
[alexvk@archbox devops]$ cat services.yaml 
- drive.google.com: 108.177.14.194
- mail.google.com: 142.251.1.18
- google.com: 173.194.222.100
```

