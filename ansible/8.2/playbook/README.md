Описание функционала ansible playbook `site.yml`:

Запуск playbook осуществляется командой `ansible-playbook site.yml -i inventory/prod.yml`.
На указанные в inventory/prod.yml машины устанавливаются JDK, а на каждую отдельную машину ставится elasticsearch и kibana соответственно.
В кечестве машин использованы docker контейнеры. Затем с помощью templates сохраняются пути к исполняемым файлам ПО.

Тэг `java` для JDK служат для установки переменной java_home; затем загружается локально хранящийся пакет JDK; создается директория для хранения JDK;
пакет JDK распаковывается; по templates создаются переменные окружения. Тегирование аналогично происходит с elasticsearch и kibana, за исключением метода 
доставки пакетов - используется метод get_url для получения пакетов ПО по https из сети Интернет. Тэги `elastic` и `kibana` соответственно для elasticsearch и
kibana.

Список переменных:
```
group_vars/
├── all
│   └── vars.yml
├── elasticsearch
│   └── vars.yml
└── kibana
    └── vars.yaml
```
all/vars.yml: `java_oracle_jdk_package` имя JDK-пакета;  
all/vars.yml: `java_jdk_version` версия JDK-пакета;  
elasticsearch/vars.yml: `elastic_home`  домашняя директория  elasticsearch;  
elasticsearch/vars.yml: `elastic_version` версия elasticsearch;
kibana/vars.yml: `kibana_home` домашняя директория kibana;  
kibana/vars.yml: `kibana_version` версия kibana.  

Список templates (Jinja):
```templates
├── elk.sh.j2
├── jdk.sh.j2
└── kib.sh.j2
```
Templates нужны для определения переменных окружения для ПО.

`elk.sh.j2`: template для elasticsearch;  
`jdk.sh.j2`: template для java;  
`kib.sh.j2`: template для kibana.