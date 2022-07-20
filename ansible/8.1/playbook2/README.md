# Самоконтроль выполненения задания

1. Где расположен файл с `some_fact` из второго пункта задания?
   Ответ: в каталоге `playbook/group_vars/all/examp.yml`
2. Какая команда нужна для запуска вашего `playbook` на окружении `test.yml`?
   Ответ: команда `ansible-playbook ./playbook/site.yml -i ./playbook/inventory/test.yml`
3. Какой командой можно зашифровать файл?
   Ответ: командой `ansible-vault encrypt filename`
4. Какой командой можно расшифровать файл?
   Ответ: командой `ansible-vault decrypt filename`
5. Можно ли посмотреть содержимое зашифрованного файла без команды расшифровки файла? Если можно, то как?
   Ответ: да, можно. команда для: `ansible-vault view filename`
6. Как выглядит команда запуска `playbook`, если переменные зашифрованы?
   Ответ: `ansible-playbook ./playbook/site.yml -i ./playbook/inventory/prod.yml --ask-vault-password`
7. Как называется модуль подключения к host на windows?
   Ответ: нужен поиск. Посмотрю документацию: 
   ```[alexvk@archbox playbook]$ ansible-doc -t connection -l | grep Microsoft
   psrp                           Run tasks over Microsoft PowerShell Remoting...
   winrm                          Run tasks over Microsoft's WinRM
   ```
8. Приведите полный текст команды для поиска информации в документации ansible для модуля подключений ssh
   Ответ: `ansible-doc -t connection ssh`
9. Какой параметр из модуля подключения `ssh` необходим для того, чтобы определить пользователя, под которым необходимо совершать подключение?
   ```
   - remote_user
        User name with which to login to the remote server, normally set by the remote_user keyword.
        If no user is supplied, Ansible will let the SSH client binary choose the user as it normally.
        [Default: (null)]
        set_via:
          cli:
          - name: user
            option: --user
          env:
          - name: ANSIBLE_REMOTE_USER
          ini:
          - key: remote_user
            section: defaults
          keyword:
          - name: remote_user
          vars:
          - name: ansible_user
          - name: ansible_ssh_user
   ```
   