# Task 1

*Используя докер образ centos:7 как базовый и документацию по установке и запуску Elastcisearch:*

*Используя докер образ centos:7 как базовый и документацию по установке и запуску Elastcisearch:*

* *составьте Dockerfile-манифест для elasticsearch*
* *соберите docker-образ и сделайте push в ваш docker.io репозиторий*
* *запустите контейнер из получившегося образа и выполните запрос пути / c хост-машины*

*Требования к elasticsearch.yml:*

* *данные path должны сохраняться в /var/lib*
* *имя ноды должно быть netology_test*

*В ответе приведите:*

* *текст Dockerfile манифеста*
* *ссылку на образ в репозитории dockerhub*
* *ответ elasticsearch на запрос пути / в json виде*

Решение:

Для установки Elastisearch лучше использовать предлагаемый по ссылке https://www.elastic.co/guide/en/elasticsearch/reference/current/rpm.html#rpm-repo 
репозиторий и метод установки, поскольку в этом случае будет наиболее полно соблюдена концепция IAC. В случае использования репозитория можно 
не задумываться о версионировании получаемого ПО, поскольку не будут использоваться абсолютные пути.
Теперь в соответствии с приведенной ссылкой составлю Dockerfile, используя в качестве базы centos version 7.  
Создаю локальный текстовый файл с указанием данных по репозиторию elasticsearch, далее выполняю шаги по инструкции по ссылке, приведенной выше.  
Системную переменную vm.max_map_count мануал рекомендует установить в 262144, т.е. на хост-машине выполняю ``sysctl -w vm.max_map_count=262144``.
Далее, скопировав оригинальный файл elasticsearch.yml, редактирую его по заданию. Поскольку сервис учебный и нет необходимости иметь безопасное 
защищенное соединение, отключаю параметры безопасности.
И добавляю параметр ``discovery.type: single-node``.  
Сборка образа:
```
docker build -t alexkrupenya/escentos .
```
Ссылка на Dockerfile: [Dockerfile](Dockerfile)  
Ссылка на elasticsearch.yml: [elasticsearch.yml](config/elasticsearch.yml)  
Ссылка на elasticsearch.repo: [elasticsearch.repo](config/elasticsearch.repo)  
Запрос GET к свежеиспеченному серверу:
```
sh-4.2$ curl --request GET localhost:9200/
{
  "name" : "netology_test",
  "cluster_name" : "netology",
  "cluster_uuid" : "iYPXo4NXT0uW6xiQTA-HSg",
  "version" : {
    "number" : "8.0.1",
    "build_flavor" : "default",
    "build_type" : "rpm",
    "build_hash" : "801d9ccc7c2ee0f2cb121bbe22ab5af77a902372",
    "build_date" : "2022-02-24T13:55:40.601285296Z",
    "build_snapshot" : false,
    "lucene_version" : "9.0.0",
    "minimum_wire_compatibility_version" : "7.17.0",
    "minimum_index_compatibility_version" : "7.0.0"
  },
  "tagline" : "You Know, for Search"
}
```

# Task 2

*В этом задании вы научитесь:*

*создавать и удалять индексы*
*изучать состояние кластера*
*обосновывать причину деградации доступности данных*
*Ознакомтесь с документацией и добавьте в elasticsearch 3 индекса, в соответствии со таблицей:*

| Имя | Количество реплик | Количество шард |
|-----|-------------------|-----------------|
| ind-1| 0 | 1 |
| ind-2 | 1 | 2 |
| ind-3 | 2 | 4 |

*Получите список индексов и их статусов, используя API и приведите в ответе на задание.*

*Получите состояние кластера elasticsearch, используя API.*

*Как вы думаете, почему часть индексов и кластер находится в состоянии yellow?*

*Удалите все индексы.*

Решение:

Создаю индексы с помощью API согласно документации:
```
bash-4.2$ curl --request PUT localhost:9200/ind-1 --header 'Content-Type: application/json' -d'{ "settings": { "number_of_replicas":0, "number_of_shards":1 }}'
{"acknowledged":true,"shards_acknowledged":true,"index":"ind-1"}
bash-4.2$ curl --request PUT localhost:9200/ind-2 --header 'Content-Type: application/json' -d'{ "settings": { "number_of_replicas":1, "number_of_shards":2 }}'
{"acknowledged":true,"shards_acknowledged":true,"index":"ind-2"}
bash-4.2$ curl --request PUT localhost:9200/ind-3 --header 'Content-Type: application/json' -d'{ "settings": { "number_of_replicas": 2, "number_of_shards": 4 }}'
{"acknowledged":true,"shards_acknowledged":true,"index":"ind-3"}bash-4.2$
```
Посмотрю список индексов:

```
bash-4.2$ curl --request GET 'localhost:9200/_cat/indices?v' 
health status index uuid                   pri rep docs.count docs.deleted store.size pri.store.size
green  open   ind-1 LDYvaOOGRu6jCM00ce1KYA   1   0          0            0       225b           225b
yellow open   ind-3 VMYO82cpTnWqXakoXOTJTw   4   2          0            0       900b           900b
yellow open   ind-2 2-Ofhv_fQLa1CMhuwRpIXQ   2   1          0            0       450b           450b
```
Статус индексов поштучно:
```
bash-4.2$ curl --request GET 'localhost:9200/_cluster/health/ind-1?pretty' 
{
  "cluster_name" : "netology",
  "status" : "green",
  "timed_out" : false,
  "number_of_nodes" : 1,
  "number_of_data_nodes" : 1,
  "active_primary_shards" : 1,
  "active_shards" : 1,
  "relocating_shards" : 0,
  "initializing_shards" : 0,
  "unassigned_shards" : 0,
  "delayed_unassigned_shards" : 0,
  "number_of_pending_tasks" : 0,
  "number_of_in_flight_fetch" : 0,
  "task_max_waiting_in_queue_millis" : 0,
  "active_shards_percent_as_number" : 100.0
}
bash-4.2$ curl --request GET 'localhost:9200/_cluster/health/ind-2?pretty' 
{
  "cluster_name" : "netology",
  "status" : "yellow",
  "timed_out" : false,
  "number_of_nodes" : 1,
  "number_of_data_nodes" : 1,
  "active_primary_shards" : 2,
  "active_shards" : 2,
  "relocating_shards" : 0,
  "initializing_shards" : 0,
  "unassigned_shards" : 2,
  "delayed_unassigned_shards" : 0,
  "number_of_pending_tasks" : 0,
  "number_of_in_flight_fetch" : 0,
  "task_max_waiting_in_queue_millis" : 0,
  "active_shards_percent_as_number" : 44.44444444444444
}
bash-4.2$ curl --request GET 'localhost:9200/_cluster/health/ind-3?pretty' 
{
  "cluster_name" : "netology",
  "status" : "yellow",
  "timed_out" : false,
  "number_of_nodes" : 1,
  "number_of_data_nodes" : 1,
  "active_primary_shards" : 4,
  "active_shards" : 4,
  "relocating_shards" : 0,
  "initializing_shards" : 0,
  "unassigned_shards" : 8,
  "delayed_unassigned_shards" : 0,
  "number_of_pending_tasks" : 0,
  "number_of_in_flight_fetch" : 0,
  "task_max_waiting_in_queue_millis" : 0,
  "active_shards_percent_as_number" : 44.44444444444444
}
```
Посмотрим общее состояние кластера через API:
```
bash-4.2$ curl --request GET localhost:9200/_cluster/health/?pretty=true
{
  "cluster_name" : "netology",
  "status" : "yellow",
  "timed_out" : false,
  "number_of_nodes" : 1,
  "number_of_data_nodes" : 1,
  "active_primary_shards" : 8,
  "active_shards" : 8,
  "relocating_shards" : 0,
  "initializing_shards" : 0,
  "unassigned_shards" : 10,
  "delayed_unassigned_shards" : 0,
  "number_of_pending_tasks" : 0,
  "number_of_in_flight_fetch" : 0,
  "task_max_waiting_in_queue_millis" : 0,
  "active_shards_percent_as_number" : 44.44444444444444
}
```

Индексы находятся в статусе **Yellow** не все, а лишь те, у которых была указана репликация. Поскольку наш сервер standalone и других серверов нет, то реплицироваться им было некуда.

Удаление созданных ранее индексов:
```
bash-4.2$ curl --request DELETE  localhost:9200/ind-1  
{"acknowledged":true}
bash-4.2$ curl --request DELETE  localhost:9200/ind-2
{"acknowledged":true}
bash-4.2$ curl --request DELETE  localhost:9200/ind-3
{"acknowledged":true}
```
Снова проверю список индексов:
```
bash-4.2$ curl --request GET 'localhost:9200/_cat/indices?v' 
health status index uuid pri rep docs.count docs.deleted store.size pri.store.size
```
Как видно из листинга, индексы отсутствуют.  

# Task 3

*В данном задании вы научитесь:*

* *создавать бэкапы данных*
* *восстанавливать индексы из бэкапов*

*Создайте директорию {путь до корневой директории с elasticsearch в образе}/snapshots.*

*Используя API зарегистрируйте данную директорию как snapshot repository c именем netology_backup.*

*Приведите в ответе запрос API и результат вызова API для создания репозитория.*

*Создайте индекс test с 0 реплик и 1 шардом и приведите в ответе список индексов.*

*Создайте snapshot состояния кластера elasticsearch.*

*Приведите в ответе список файлов в директории со snapshotами.*

*Удалите индекс test и создайте индекс test-2. Приведите в ответе список индексов.*

*Восстановите состояние кластера elasticsearch из snapshot, созданного ранее.*

*Приведите в ответе запрос к API восстановления и итоговый список индексов.*

Решение:

Определяю путь к снапшотам с помощью API:
```
sh-4.2$ curl --request POST localhost:9200/_snapshot/netology_backup --header 'Content-Type: application/json' -d'{"type": "fs", "settings": { "location":"/usr/share/elasticsearch/snapshots" }}'
{
  "acknowledged" : true
}
```
В лог-файле появилась запись:
```
[2022-03-05T12:31:26,418][INFO ][o.e.r.RepositoriesService] [netology_test] put repository [netology_backup]
```
Репозиторий для бэкапов определен. Можно опросить его статус:
```
sh-4.2$ curl http://localhost:9200/_snapshot/netology_backup?pretty
{
  "netology_backup" : {
    "type" : "fs",
    "settings" : {
      "location" : "/usr/share/elasticsearch/snapshots"
    }
  }
}
```
Создаю индекс test с 1 шардом и 0 реплик:
```
sh-4.2$ curl --request PUT localhost:9200/test --header 'Content-Type: application/json' -d'{ "settings": { "number_of_replicas": 0, "number_of_shards": 1 }}'
{"acknowledged":true,"shards_acknowledged":true,"index":"test"}
```
Опрос статуса индекса:
```
sh-4.2$ curl localhost:9200/test?pretty
{
  "test" : {
    "aliases" : { },
    "mappings" : { },
    "settings" : {
      "index" : {
        "routing" : {
          "allocation" : {
            "include" : {
              "_tier_preference" : "data_content"
            }
          }
        },
        "number_of_shards" : "1",
        "provided_name" : "test",
        "creation_date" : "1646483940940",
        "number_of_replicas" : "0",
        "uuid" : "9q5mEWqvSLOFEzva3mxoTA",
        "version" : {
          "created" : "8000199"
        }
      }
    }
  }
}
```

Создаю бэкап (снапшот) текущих данных:
```
sh-4.2$ curl --request PUT localhost:9200/_snapshot/netology_backup/elasticsearch?wait_for_completion=true
{"snapshot":{"snapshot":"elasticsearch","uuid":"hvmMnVfIQVyFN7EP545XPw","repository":"netology_backup","version_id":8000199,"version":"8.0.1","indices":[".geoip_databases","test"],"data_streams":[],"include_global_state":true,"state":"SUCCESS","start_time":"2022-03-05T12:44:07.485Z","start_time_in_millis":1646484247485,"end_time":"2022-03-05T12:44:08.886Z","end_time_in_millis":1646484248886,"duration_in_millis":1401,"failures":[],"shards":{"total":2,"failed":0,"successful":2},"feature_states":[{"feature_name":"geoip","indices":[".geoip_databases"]}]}}
```
Список файлов в директории со снапшотами:
```
sh-4.2$ ls -la /usr/share/elasticsearch/snapshots/
total 48
drwxr-xr-x 1 elasticsearch elasticsearch  4096 Mar  5 12:44 .
drwxr-xr-x 1 root          root           4096 Mar  5 11:52 ..
-rw-r--r-- 1 elasticsearch elasticsearch   846 Mar  5 12:44 index-0
-rw-r--r-- 1 elasticsearch elasticsearch     8 Mar  5 12:44 index.latest
drwxr-xr-x 4 elasticsearch elasticsearch  4096 Mar  5 12:44 indices
-rw-r--r-- 1 elasticsearch elasticsearch 17442 Mar  5 12:44 meta-hvmMnVfIQVyFN7EP545XPw.dat
-rw-r--r-- 1 elasticsearch elasticsearch   363 Mar  5 12:44 snap-hvmMnVfIQVyFN7EP545XPw.dat
sh-4.2$ 
```
Удаление индекса test:
```
sh-4.2$ curl --request DELETE localhost:9200/test  
{"acknowledged":true}
```
Создаю новый индекс test-2:
```
sh-4.2$ curl --request PUT localhost:9200/test-2 --header 'Content-Type: application/json' -d'{ "settings": { "number_of_replicas": 0, "number_of_shards": 1 }}'
{"acknowledged":true,"shards_acknowledged":true,"index":"test-2"} 
```
Проверка статуса нового индекса:
```
sh-4.2$ curl --request GET localhost:9200/_cat/indices?v
health status index  uuid                   pri rep docs.count docs.deleted store.size pri.store.size
green  open   test-2 lF9bQRByQhClpFspRdaxdA   1   0          0            0       225b           225b
```
Восстановление из бэкапа:
```
sh-4.2$ curl --request POST localhost:9200/_snapshot/netology_backup/elasticsearch/_restore --header 'Content-Type: application/json' -d'{ "include_global_state": true }'
{"accepted":true}
```
Просмотрю список индексов:
```
sh-4.2$ curl --request GET localhost:9200/_cat/indices?v
health status index  uuid                   pri rep docs.count docs.deleted store.size pri.store.size
green  open   test-2 lF9bQRByQhClpFspRdaxdA   1   0          0            0       225b           225b
green  open   test   qhkCtFBxQzyzLHBaTPH4Ug   1   0          0            0       225b           225b
sh-4.2$ 
```
Как видно из листинга, индекс **test** восстановлен из бэкапа.

