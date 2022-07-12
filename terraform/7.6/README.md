# Домашнее задание к занятию "7.6. Написание собственных провайдеров для Terraform."

*Бывает, что*
* *общедоступная документация по терраформ ресурсам не всегда достоверна,*
* *в документации не хватает каких-нибудь правил валидации или неточно описаны параметры,*
* *понадобиться использовать провайдер без официальной документации,*
* *может возникнуть необходимость написать свой провайдер для системы используемой в ваших проектах.*

## Задача 1.
*Давайте потренируемся читать исходный код AWS провайдера, который можно склонировать от сюда:*
*[https://github.com/hashicorp/terraform-provider-aws.git](https://github.com/hashicorp/terraform-provider-aws.git).*
*Просто найдите нужные ресурсы в исходном коде и ответы на вопросы станут понятны.*

1. *Найдите, где перечислены все доступные `resource` и `data_source`, приложите ссылку на эти строки в коде на гитхабе.*

### Решение

Для изучения кода провайлера aws склонирую репозиторий; после успешного клонирования можно изучать код.  
По аналогии с туториалом от hashicorp https://learn.hashicorp.com/tutorials/terraform/provider-setup?in=terraform/providers#explore-provider-schema ,
поищу подстроку DataSourceMap в дереве репозитория:
```
[alexvk@archbox terraform-provider-aws]$ find . -type f -exec grep -H "DataSourceMap" {} \;
./internal/provider/provider.go:                        "aws_location_map":              location.DataSourceMap(),
./internal/service/location/map_data_source.go:func DataSourceMap() *schema.Resource {
```
Таким образом, файл provider.go ожидаемо содержит искомый ресурс. Визуально это действительно так. [DataSourceMap здесь](https://github.com/hashicorp/terraform-provider-aws/blob/main/internal/provider/provider.go#L426).

Аналогично поступаю с ResourceMap. [ResourceMap здесь](https://github.com/hashicorp/terraform-provider-aws/blob/main/internal/provider/provider.go#L920).

2. *Для создания очереди сообщений SQS используется ресурс `aws_sqs_queue` у которого есть параметр `name`.*
    * *С каким другим параметром конфликтует `name`? Приложите строчку кода, в которой это указано.*
    * *Какая максимальная длина имени?*
    * *Какому регулярному выражению должно подчиняться имя?*

### Решение

* queue_Schema описана в файле https://github.com/hashicorp/terraform-provider-aws/blob/main/internal/service/sqs/queue.go. "name" конфликтует с "name_prefix", [как указано здесь](https://github.com/hashicorp/terraform-provider-aws/blob/main/internal/service/sqs/queue.go#L87) -- ``ConflictsWith: []string{"name_prefix"},``
* максимальная длина имени равна 80 символам, [как указано здесь](https://github.com/hashicorp/terraform-provider-aws/blob/main/internal/service/sqs/queue.go#L427)
* регулярное выражение для имени -- [здесь](https://github.com/hashicorp/terraform-provider-aws/blob/main/internal/service/sqs/queue.go#L427), и имеет вид `^[a-zA-Z0-9_-]{1,80}$`

## Задача 2. (Не обязательно)
В рамках вебинара и презентации мы разобрали как создать свой собственный провайдер на примере кофемашины.
Также вот официальная документация о создании провайдера:
[https://learn.hashicorp.com/collections/terraform/providers](https://learn.hashicorp.com/collections/terraform/providers).

1. Проделайте все шаги создания провайдера.
2. В виде результата приложение ссылку на исходный код.
3. Попробуйте скомпилировать провайдер, если получится то приложите снимок экрана с командой и результатом компиляции.

---

### Как cдавать задание

Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.

---
