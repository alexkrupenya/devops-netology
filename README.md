# Task 4

Выполняю vagrant init и меняю файла Vagrantfile на указаныне в задании строки
либо сразу инициализирую указанную VM:
<pre>
vagrant init bento/ubuntu-20.04
</pre>
затем vagrant up - установка ресурсов, образа VM и начальная конфигурация.

Выключаю VM: vagrant halt

# Task 5

Для запуска GUI изменяю файл Vagrantfile следующим образом:
<pre>
Vagrant.configure("2") do |config|
  config.vm.box = "bento/ubuntu-20.04"

    config.vm.provider "virtualbox" do |v|
       v.gui = true
    end
end
</pre>

Ресурсы системы можно увидеть в GUI: "Machine"->"Settings"->"System".

По дефолту имеется RAM: 1G, CPUs: 2, Storage (virtual disk): 64G.

Второй способ: vagrant ssh default, затем lscpu (CPU data), lsmem (RAM data),
lsbk -l - количество выделенного пространства на постоянном носителе, в этом 
случае /dev/sda.

# Task 6

Для изменения конфигурации (RAM, CPUs) редактирую Vagrantfile так:

<pre>
Vagrant.configure("2") do |config|
  config.vm.box = "bento/ubuntu-20.04"

    config.vm.provider "virtualbox" do |v|
       v.gui = true
       v.memory = 4096
       v.cpus = 4
    end

end
</pre>

Далее: vagrant up --provision

В приведенном примере в VM RAM увеличена до 4G, CPUs до 4 шт.

# Task 8

Искомая переменная: HISTFILESIZE.
Если N>0, то по достижении N строк файл истории усекается путем 
удаления самых старых значений. При N=0 история не сохраняется. 
man 1 bash, bash v.5.0.17, страница Shell Variables, en_US.

Опция ignoreboth является сокращением для ignorespace и ignoredups. В случае, если строка начинается
с символа пробела и повторяет предыдущую в истории, то она не сохраняется.

# Task 9

Так называемый механизм brace expansion, или замена выражений. Применяется для генерации произвольных 
строк. man 1 bash, страница Brace Expansion, bash v.5.0.17, en_US.

# Task 10

Использую brace expansion из task 9 для создания 10000 файлов.

В пустом каталоге: touch {1..1000}

Проверим: ls -1 | wc -l
Файлы в количестве 10000 созданы.

Теперь попробую создать 300000 файлов.
rm *; touch {1..300000}

Получаю сообщение об ошибке bash: /usr/bin/touch: Argument list too long

Проблема в системном вызове execve и константе ARG_MAX.
Произведена попытка передать слишком длинный параметр.
Решение: использовать цикл for.

# Task 11

[[ expression ]] возвращает 0 или 1 в соответствие с результатом вычисления выражения expression.

выражение [[ -d /tmp ]] вернет 0 или 1 в зависимости от наличий каталога /tmp  в FS.
Набросаем скрипт:

<pre>
#!/bin/bash

FD="/tmp"

if ( [[ -d $FD ]] ) then
	echo "directory" $FD "exists!";
else
	echo "directory" $FD "doesn't exist!"; 
fi

</pre>

# Task 12

Создам новый каталог и симлинки на интепретатор bash:
<pre>
mkdir /tmp/new_path_directory && ln -s $(which bash) /tmp/new_path_directory/bash
sudo ln -s $(which bash) /usr/local/bin/bash
</pre>

Меняю переменную PATH:
<pre>
export PATH="/tmp/new_path_directory":"/usr/local/bin":"/bin"
</pre>
Директива "type -a bash" даст искомый вывод.
Значение переменной PATH сохранится на время действия текущего инстанса bash.
Чтобы  не терять назначенные глобально пути, можно добавить в PATH в конец строки
:$PATH

# Task 13

Утилита at - аналог однократного будильника. Задание, назначенное ею, выполнится 
один раз и безусловно.
batch похож на at, но задание выполнится при определенном уровне нагрузки системы,
по дефолту ниже 0.8, либо по значению параметра нагрузки, указанного в инстансе atd.

