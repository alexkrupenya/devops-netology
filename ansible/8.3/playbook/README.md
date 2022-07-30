Описание функционала ansible playbook `site.yml`:

Playbook из задания 8.2 переработан для использование ролей.

Перед запуском playbook нужно скачать роли: `ansible-galaxy install -r requirements.yml --roles-path roles/`.

Запуск playbook осуществляется командой `ansible-playbook site.yml -i inventory/prod.yml`.
На указанные в inventory/prod.yml машины устанавливаются JDK, а на каждую отдельную машину ставится elasticsearch и kibana соответственно.

В кечестве машин использованы docker контейнеры. Затем с помощью templates в ролях сохраняются пути к исполняемым файлам ПО.

