# Task 1
Разреженные файлы -- в информатике это понятие означает, что в компьютерном файле с большим количеством пустого пространства, хранящемся на диске, операционная система займет меньше дискового пространства. Цель достигается записью специальных метаданных небольшого объема, описывающих местоположение и размер пустых блоков, вместо фактической записи этих блоков. Полный блок будет записан на диск только в том случае, если блок содержит "непустые", то есть настоящие данные.  
При чтении таких файлов ОС заменяет указанные метаданные на настоящие блоки данных. Приложение пользователя не замечает этой подмены.  
Большинство современных файловых систем поддерживают sparse файлы. Это ОС семейства Unix/Linux, но не HFS+ от Apple. Sparse файлы были добавлены Apple в AFS.  
Sparse файлы часто используются в дампах баз данных, лог-файлах, и при создании образов дисков.  
Преимущества: экономия дискового пространства.  
Недостатки: разреженные файлы могут стать весьма фрагментированными; отчеты системы о свободном пространстве могут вводить в заблуждение; копирование файлов программой, не поддерживающей sparse файлы, может привести к неожиданным эффектам - минимальный из них это заполнение пустым пространством всего свободного места на диске.  

# Task 2

Теретически хардлинк и файл, на который он ссылается, не могут иметь разные права доступа и владельцев. Файл - безымянный бинарный объект на устройстве, имеющий номер inode. Имя файла -- строковое значение в файловой таблице. Жесткая ссылка - еще одна запись в файловой таблице, ссылающаяся на тот же номер inode, который имеет файл-источник. Таким образом по логике построений файловой структуры жесткая ссылке не может иметь права доступа и владельца, отличных от файла-источника.  
Покажу это на примерах.  
<pre>
vagrant@vagrant:~$ echo "test" > test_file && ln test_file test_hard
vagrant@vagrant:~$ stat test_file test_hard 
  File: test_file
  Size: 5         	Blocks: 8          IO Block: 4096   regular file
Device: fd00h/64768d	Inode: 131095      Links: 2
Access: (0664/-rw-rw-r--)  Uid: ( 1000/ vagrant)   Gid: ( 1000/ vagrant)
Access: 2021-11-27 06:48:44.923349711 +0000
Modify: 2021-11-27 06:48:44.923349711 +0000
Change: 2021-11-27 06:48:44.923349711 +0000
 Birth: -
  File: test_hard
  Size: 5         	Blocks: 8          IO Block: 4096   regular file
Device: fd00h/64768d	Inode: 131095      Links: 2
Access: (0664/-rw-rw-r--)  Uid: ( 1000/ vagrant)   Gid: ( 1000/ vagrant)
Access: 2021-11-27 06:48:44.923349711 +0000
Modify: 2021-11-27 06:48:44.923349711 +0000
Change: 2021-11-27 06:48:44.923349711 +0000
 Birth: -
</pre>
Номер inode одинаков для файла и хардлинка.  
Теперь меняю владельца и права доступа на файл.  
``vagrant@vagrant:~$ sudo chown nobody test_file && sudo chmod 777 test_file``  
Посмотрю листинг файлов.  
``vagrant@vagrant:~$ ls -la test_file test_hard ``  
``-rwxrwxrwx 2 nobody vagrant 5 Nov 27 06:48 test_file``   
``-rwxrwxrwx 2 nobody vagrant 5 Nov 27 06:48 test_hard``   
Видно, что права доступа и владелец файла идентичны с правами и владельцем хардлинка.  
Обратное также верно.  

# Task 3
``[alexvk@archbox vagrant]$ vagrant destroy``  
Текущий инстанс удален, что можно проверить листингом директории *~/VirtualBox\ VMs/  
Создам новый Vagrantfile с содержимым:  
<pre>
Vagrant.configure("2") do |config|
  config.vm.box = "bento/ubuntu-20.04"
  config.vm.provider :virtualbox do |vb|
    lvm_experiments_disk0_path = "/tmp/lvm_experiments_disk0.vmdk"
    lvm_experiments_disk1_path = "/tmp/lvm_experiments_disk1.vmdk"
    vb.customize ['createmedium', '--filename', lvm_experiments_disk0_path, '--size', 2560]
    vb.customize ['createmedium', '--filename', lvm_experiments_disk1_path, '--size', 2560]
    vb.customize ['storageattach', :id, '--storagectl', 'SATA Controller', '--port', 1, '--device', 0, '--type', 'hdd', '--medium', lvm_experiments_disk0_path]
    vb.customize ['storageattach', :id, '--storagectl', 'SATA Controller', '--port', 2, '--device', 0, '--type', 'hdd', '--medium', lvm_experiments_disk1_path]
  end
end
</pre>
``vagrant up`` создает новую конфигурацию Ubuntu 20.04, поместив два файла виртуальных дисков в каталог /tmp.  
<pre>
[alexvk@archbox vagrant]$ ls -n /tmp/
total 32
srwxrwxrwx 1 1000 1000       0 Nov 27 12:23 dbus-rFZSyeKzhc
<b>-rw------- 1 1000 1000 2097152 Nov 27 12:52 lvm_experiments_disk0.vmdk
-rw------- 1 1000 1000 2097152 Nov 27 12:52 lvm_experiments_disk1.vmdk</b>
drwx------ 3    0    0      60 Nov 27 11:43 systemd-private-2d013406297c45a5bcbd8445b4e22cea-systemd-logind.service-vWAgRE
drwx------ 3    0    0      60 Nov 27 11:43 systemd-private-2d013406297c45a5bcbd8445b4e22cea-systemd-timesyncd.service-FwqJv5
drwx------ 3    0    0      60 Nov 27 12:23 systemd-private-2d013406297c45a5bcbd8445b4e22cea-upower.service-3ap5W7
drwx------ 2 1000 1000      40 Nov 27 12:05 Temp-d28b5d9e-c297-45a0-be75-159f85f4e362
</pre>

Выполняю логин на созданный бокс. Посмотрю блочные устройства:  
<pre>
vagrant@vagrant:~$ lsblk -i
NAME                 MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
sda                    8:0    0   64G  0 disk 
|-sda1                 8:1    0  512M  0 part /boot/efi
|-sda2                 8:2    0    1K  0 part 
`-sda5                 8:5    0 63.5G  0 part 
  |-vgvagrant-root   253:0    0 62.6G  0 lvm  /
  `-vgvagrant-swap_1 253:1    0  980M  0 lvm  [SWAP]
sdb                    8:16   0  2.5G  0 disk 
sdc                    8:32   0  2.5G  0 disk 
</pre>
Вывод - успешное завершение задачи.

# Task 4
Задача - разбить диск /dev/sdb на два раздела, 2G и остаток.  
Выполняю.  
Итог:  
<pre>
vagrant@vagrant:~$ sudo fdisk -l /dev/sdb
Disk /dev/sdb: 2.51 GiB, 2684354560 bytes, 5242880 sectors
Disk model: VBOX HARDDISK   
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: dos
Disk identifier: 0xb2f1e82b

Device     Boot   Start     End Sectors  Size Id Type
/dev/sdb1          2048 4196351 4194304    2G 83 Linux
/dev/sdb2       4196352 5242879 1046528  511M 83 Linux
</pre>

# Task 5
С помощью sfdisk необходимо перенести таблицу разделов на /dev/sdc.  
Выполняю.  
<pre>
vagrant@vagrant:~$ sudo sfdisk -d /dev/sdb | sudo sfdisk /dev/sdc
Checking that no-one is using this disk right now ... OK

Disk /dev/sdc: 2.51 GiB, 2684354560 bytes, 5242880 sectors
Disk model: VBOX HARDDISK   
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes

>>> Script header accepted.
>>> Script header accepted.
>>> Script header accepted.
>>> Script header accepted.
>>> Created a new DOS disklabel with disk identifier 0xb2f1e82b.
/dev/sdc1: Created a new partition 1 of type 'Linux' and of size 2 GiB.
/dev/sdc2: Created a new partition 2 of type 'Linux' and of size 511 MiB.
/dev/sdc3: Done.

New situation:
Disklabel type: dos
Disk identifier: 0xb2f1e82b

Device     Boot   Start     End Sectors  Size Id Type
/dev/sdc1          2048 4196351 4194304    2G 83 Linux
/dev/sdc2       4196352 5242879 1046528  511M 83 Linux

The partition table has been altered.
Calling ioctl() to re-read partition table.
Syncing disks.
</pre>
Проверяем полученный результат:  
<pre>
vagrant@vagrant:~$ sudo fdisk -l /dev/sdc
Disk /dev/sdc: 2.51 GiB, 2684354560 bytes, 5242880 sectors
Disk model: VBOX HARDDISK   
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: dos
Disk identifier: 0xb2f1e82b

Device     Boot   Start     End Sectors  Size Id Type
/dev/sdc1          2048 4196351 4194304    2G 83 Linux
/dev/sdc2       4196352 5242879 1046528  511M 83 Linux
</pre>
Ok, done. Теперь имеется копия MBR с диска sdb на диске sdc.

# Task 6

man 8 mdadm в помощь...  
Вдумчивое чтение команды --create приводит к искомому результату.  
<pre>
vagrant@vagrant:~$ sudo mdadm --create /dev/md0 --level=raid1 --raid-devices=2 /dev/sd[bc]1
mdadm: Note: this array has metadata at the start and
    may not be suitable as a boot device.  If you plan to
    store '/boot' on this device please ensure that
    your boot-loader understands md/v1.x metadata, or use
    --metadata=0.90
Continue creating array? y
mdadm: Defaulting to version 1.2 metadata
mdadm: array /dev/md0 started.
</pre>
Проверяю.  
<pre>
vagrant@vagrant:~$ sudo mdadm --detail /dev/md0
/dev/md0:
           Version : 1.2
     Creation Time : Sat Nov 27 10:36:02 2021
        Raid Level : raid1
        Array Size : 2094080 (2045.00 MiB 2144.34 MB)
     Used Dev Size : 2094080 (2045.00 MiB 2144.34 MB)
      Raid Devices : 2
     Total Devices : 2
       Persistence : Superblock is persistent

       Update Time : Sat Nov 27 10:36:13 2021
             State : clean 
    Active Devices : 2
   Working Devices : 2
    Failed Devices : 0
     Spare Devices : 0

Consistency Policy : resync

              Name : vagrant:0  (local to host vagrant)
              UUID : 7192f812:cbf91f26:1b296f7e:1beafb21
            Events : 17

    Number   Major   Minor   RaidDevice State
       0       8       17        0      active sync   /dev/sdb1
       1       8       33        1      active sync   /dev/sdc1
</pre>

# Task 7

Аналогично задаче 6.  
<pre>
vagrant@vagrant:~$ sudo mdadm --create /dev/md1 --level=raid0 --raid-devices=2 /dev/sd[bc]2
mdadm: Defaulting to version 1.2 metadata
mdadm: array /dev/md1 started.
vagrant@vagrant:~$ sudo mdadm --detail /dev/md1
/dev/md1:
           Version : 1.2
     Creation Time : Sat Nov 27 10:40:04 2021
        Raid Level : raid0
        Array Size : 1042432 (1018.00 MiB 1067.45 MB)
      Raid Devices : 2
     Total Devices : 2
       Persistence : Superblock is persistent

       Update Time : Sat Nov 27 10:40:04 2021
             State : clean 
    Active Devices : 2
   Working Devices : 2
    Failed Devices : 0
     Spare Devices : 0

            Layout : -unknown-
        Chunk Size : 512K

Consistency Policy : none

              Name : vagrant:1  (local to host vagrant)
              UUID : 049b3755:33d40006:2c62d950:b6d4d34d
            Events : 0

    Number   Major   Minor   RaidDevice State
       0       8       18        0      active sync   /dev/sdb2
       1       8       34        1      active sync   /dev/sdc2
</pre>
Получен stripe массив.  

# Task 8
man lvm; man pvcreate.  
<pre>
vagrant@vagrant:~$ sudo pvcreate /dev/md0 /dev/md1
  Physical volume "/dev/md0" successfully created.
  Physical volume "/dev/md1" successfully created.

vagrant@vagrant:~$ sudo pvdisplay 
  --- Physical volume ---
  PV Name               /dev/sda5
  VG Name               vgvagrant
  PV Size               <63.50 GiB / not usable 0   
  Allocatable           yes (but full)
  PE Size               4.00 MiB
  Total PE              16255
  Free PE               0
  Allocated PE          16255
  PV UUID               Mx3LcA-uMnN-h9yB-gC2w-qm7w-skx0-OsTz9z
   
  "/dev/md0" is a new physical volume of "<2.00 GiB"
  --- NEW Physical volume ---
  PV Name               /dev/md0
  VG Name               
  PV Size               <2.00 GiB
  Allocatable           NO
  PE Size               0   
  Total PE              0
  Free PE               0
  Allocated PE          0
  PV UUID               URc5Kc-stXU-Pmop-c5kh-c3My-8V9w-QVLEdT
   
  "/dev/md1" is a new physical volume of "1018.00 MiB"
  --- NEW Physical volume ---
  PV Name               /dev/md1
  VG Name               
  PV Size               1018.00 MiB
  Allocatable           NO
  PE Size               0   
  Total PE              0
  Free PE               0
  Allocated PE          0
  PV UUID               MAuPnK-LvFB-Bu0j-kWiB-Ccpb-GLUO-PCLgMp

</pre>
Задача выполнена.

# Task 9
man lvm; man vgcreate.  
<pre>
vagrant@vagrant:~$ sudo vgcreate vg0 /dev/md0 /dev/md1
  Volume group "vg0" successfully created

vagrant@vagrant:~$ sudo vgdisplay
  --- Volume group ---
  VG Name               vgvagrant
  System ID             
  Format                lvm2
  Metadata Areas        1
  Metadata Sequence No  3
  VG Access             read/write
  VG Status             resizable
  MAX LV                0
  Cur LV                2
  Open LV               2
  Max PV                0
  Cur PV                1
  Act PV                1
  VG Size               <63.50 GiB
  PE Size               4.00 MiB
  Total PE              16255
  Alloc PE / Size       16255 / <63.50 GiB
  Free  PE / Size       0 / 0   
  VG UUID               PaBfZ0-3I0c-iIdl-uXKt-JL4K-f4tT-kzfcyE
   
  --- Volume group ---
  VG Name               vg0
  System ID             
  Format                lvm2
  Metadata Areas        2
  Metadata Sequence No  1
  VG Access             read/write
  VG Status             resizable
  MAX LV                0
  Cur LV                0
  Open LV               0
  Max PV                0
  Cur PV                2
  Act PV                2
  VG Size               <2.99 GiB
  PE Size               4.00 MiB
  Total PE              765
  Alloc PE / Size       0 / 0   
  Free  PE / Size       765 / <2.99 GiB
  VG UUID               ckICJy-zDTe-aYtl-2fdU-HmuE-7SBk-1lid7f
</pre>
Задача выполнена.

# Task 10

man lvcreate.  
<pre>
vagrant@vagrant:~$ sudo lvcreate -L 100m vg0  /dev/md1
  Logical volume "lvol0" created.
</pre>
Выполню проверки (man vgs, man pvs, man lvs):  
<pre>
vagrant@vagrant:~$ sudo vgs
  VG        #PV #LV #SN Attr   VSize   VFree
  vg0         2   1   0 wz--n-  <2.99g 2.89g
  vgvagrant   1   2   0 wz--n- <63.50g    0 
vagrant@vagrant:~$ sudo pvs
  PV         VG        Fmt  Attr PSize    PFree  
  /dev/md0   vg0       lvm2 a--    <2.00g  <2.00g
  /dev/md1   vg0       lvm2 a--  1016.00m 916.00m
  /dev/sda5  vgvagrant lvm2 a--   <63.50g      0 
vagrant@vagrant:~$ sudo lvs
  LV     VG        Attr       LSize   Pool Origin Data%  Meta%  Move Log Cpy%Sync Convert
  lvol0  vg0       -wi-a----- 100.00m                                                    
  root   vgvagrant -wi-ao---- <62.54g                                                    
  swap_1 vgvagrant -wi-ao---- 980.00m                                                    
</pre>

# Task 11
Создать ext4 на lvol0.  
<pre>
vagrant@vagrant:~$ sudo mkfs.ext4 /dev/vg0/lvol0 
mke2fs 1.45.5 (07-Jan-2020)
Creating filesystem with 25600 4k blocks and 25600 inodes

Allocating group tables: done                            
Writing inode tables: done                            
Creating journal (1024 blocks): done
Writing superblocks and filesystem accounting information: done
</pre>

# Task 12
Смонтировать раздел /dev/vg0/lvol0 на /tmp/new:  
<pre>
vagrant@vagrant:~$ sudo mkdir /tmp/new
vagrant@vagrant:~$ sudo mount /dev/vg0/lvol0 /tmp/new
vagrant@vagrant:~$ df -h
Filesystem                  Size  Used Avail Use% Mounted on
udev                        447M     0  447M   0% /dev
tmpfs                        99M  704K   98M   1% /run
/dev/mapper/vgvagrant-root   62G  1.5G   57G   3% /
tmpfs                       491M     0  491M   0% /dev/shm
tmpfs                       5.0M     0  5.0M   0% /run/lock
tmpfs                       491M     0  491M   0% /sys/fs/cgroup
/dev/sda1                   511M  4.0K  511M   1% /boot/efi
vagrant                     106G   36G   70G  34% /vagrant
tmpfs                        99M     0   99M   0% /run/user/1000
/dev/mapper/vg0-lvol0        93M   72K   86M   1% /tmp/new
</pre>
Сделано.  

# Task 13
Поместить в /mnt тестовый файл.   
<pre>
vagrant@vagrant:~$ cd /tmp/new
vagrant@vagrant:/tmp/new$ sudo wget https://mirror.yandex.ru/ubuntu/ls-lR.gz -O /tmp/new/test.gz
--2021-11-27 11:11:26--  https://mirror.yandex.ru/ubuntu/ls-lR.gz
Resolving mirror.yandex.ru (mirror.yandex.ru)... 213.180.204.183, 2a02:6b8::183
Connecting to mirror.yandex.ru (mirror.yandex.ru)|213.180.204.183|:443... connected.
HTTP request sent, awaiting response... 200 OK
Length: 22616106 (22M) [application/octet-stream]
Saving to: ‘/tmp/new/test.gz’

/tmp/new/test.gz     100%[====================>]  21.57M  2.43MB/s    in 11s     

2021-11-27 11:11:37 (1.94 MB/s) - ‘/tmp/new/test.gz’ saved [22616106/22616106]
</pre>

# Task 14
Поместить вывод lsblk.  
<pre>vagrant@vagrant:/tmp/new$ lsblk -i
NAME                 MAJ:MIN RM  SIZE RO TYPE  MOUNTPOINT
sda                    8:0    0   64G  0 disk  
|-sda1                 8:1    0  512M  0 part  /boot/efi
|-sda2                 8:2    0    1K  0 part  
`-sda5                 8:5    0 63.5G  0 part  
  |-vgvagrant-root   253:0    0 62.6G  0 lvm   /
  `-vgvagrant-swap_1 253:1    0  980M  0 lvm   [SWAP]
sdb                    8:16   0  2.5G  0 disk  
|-sdb1                 8:17   0    2G  0 part  
| `-md0                9:0    0    2G  0 raid1 
|   `-vg0-lvol0      253:2    0  100M  0 lvm   /tmp/new
`-sdb2                 8:18   0  511M  0 part  
  `-md1                9:1    0 1018M  0 raid0 
sdc                    8:32   0  2.5G  0 disk  
|-sdc1                 8:33   0    2G  0 part  
| `-md0                9:0    0    2G  0 raid1 
|   `-vg0-lvol0      253:2    0  100M  0 lvm   /tmp/new
`-sdc2                 8:34   0  511M  0 part  
  `-md1                9:1    0 1018M  0 raid0 
vagrant@vagrant:/tmp/new$ lsblk
NAME                 MAJ:MIN RM  SIZE RO TYPE  MOUNTPOINT
sda                    8:0    0   64G  0 disk  
├─sda1                 8:1    0  512M  0 part  /boot/efi
├─sda2                 8:2    0    1K  0 part  
└─sda5                 8:5    0 63.5G  0 part  
  ├─vgvagrant-root   253:0    0 62.6G  0 lvm   /
  └─vgvagrant-swap_1 253:1    0  980M  0 lvm   [SWAP]
sdb                    8:16   0  2.5G  0 disk  
├─sdb1                 8:17   0    2G  0 part  
│ └─md0                9:0    0    2G  0 raid1 
└─sdb2                 8:18   0  511M  0 part  
  └─md1                9:1    0 1018M  0 raid0 
    └─vg0-lvol0      253:2    0  100M  0 lvm   /tmp/new
sdc                    8:32   0  2.5G  0 disk  
├─sdc1                 8:33   0    2G  0 part  
│ └─md0                9:0    0    2G  0 raid1 
└─sdc2                 8:34   0  511M  0 part  
  └─md1                9:1    0 1018M  0 raid0 
    └─vg0-lvol0      253:2    0  100M  0 lvm   /tmp/new
</pre>

# Task 15
Протестировать целостность файла.  
Вывод:  
<pre>
vagrant@vagrant:/tmp/new$ gzip -t /tmp/new/test.gz
vagrant@vagrant:/tmp/new$ echo $?
0
</pre>

# Task 16

Переместить содержимое PV с raid0 на raid1 с помощью pvmove.  
man pvmove.  
<pre>
vagrant@vagrant:/tmp/new$ sudo pvmove /dev/md1
  /dev/md1: Moved: 52.00%
  /dev/md1: Moved: 100.00%

vagrant@vagrant:/tmp/new$ lsblk -i
NAME                 MAJ:MIN RM  SIZE RO TYPE  MOUNTPOINT
sda                    8:0    0   64G  0 disk  
|-sda1                 8:1    0  512M  0 part  /boot/efi
|-sda2                 8:2    0    1K  0 part  
`-sda5                 8:5    0 63.5G  0 part  
  |-vgvagrant-root   253:0    0 62.6G  0 lvm   /
  `-vgvagrant-swap_1 253:1    0  980M  0 lvm   [SWAP]
sdb                    8:16   0  2.5G  0 disk  
|-sdb1                 8:17   0    2G  0 part  
| `-md0                9:0    0    2G  0 raid1 
|   `-vg0-lvol0      253:2    0  100M  0 lvm   /tmp/new
`-sdb2                 8:18   0  511M  0 part  
  `-md1                9:1    0 1018M  0 raid0 
sdc                    8:32   0  2.5G  0 disk  
|-sdc1                 8:33   0    2G  0 part  
| `-md0                9:0    0    2G  0 raid1 
|   `-vg0-lvol0      253:2    0  100M  0 lvm   /tmp/new
`-sdc2                 8:34   0  511M  0 part  
  `-md1                9:1    0 1018M  0 raid0 
</pre>
Перенос успешно произведен, как видно из дерева связей lsblk.  

# Task 17
Делаю /dev/sdc1 в массиве md0 faulty.  
<pre>
vagrant@vagrant:/tmp/new$ sudo mdadm /dev/md0 --fail /dev/sdc1
mdadm: set /dev/sdc1 faulty in /dev/md0

vagrant@vagrant:/tmp/new$ sudo mdadm --detail /dev/md0
/dev/md0:
           Version : 1.2
     Creation Time : Sat Nov 27 10:36:02 2021
        Raid Level : raid1
        Array Size : 2094080 (2045.00 MiB 2144.34 MB)
     Used Dev Size : 2094080 (2045.00 MiB 2144.34 MB)
      Raid Devices : 2
     Total Devices : 2
       Persistence : Superblock is persistent

       Update Time : Sat Nov 27 11:35:29 2021
             State : clean, degraded 
    Active Devices : 1
   Working Devices : 1
    Failed Devices : 1
     Spare Devices : 0

Consistency Policy : resync

              Name : vagrant:0  (local to host vagrant)
              UUID : 7192f812:cbf91f26:1b296f7e:1beafb21
            Events : 19

    Number   Major   Minor   RaidDevice State
       0       8       17        0      active sync   /dev/sdb1
       -       0        0        1      removed

       1       8       33        -      faulty   /dev/sdc1

</pre>

# Task 18
Вывод dmesg о проблеме с /dev/sdc1:
<pre>
[ 6159.324016] md/raid1:md0: Disk failure on sdc1, disabling device.
               md/raid1:md0: Operation continuing on 1 devices.
</pre>

# Task 19 
Тестирую файл на доступность:  
<pre>
vagrant@vagrant:/tmp/new$ gzip -t /tmp/new/test.gz && echo $?
0
</pre>

# Task 20
Уничтожаю тестовую guest-машину с помощью vagrant destroy.  
<pre>
[alexvk@archbox vagrant]$ vagrant destroy
    default: Are you sure you want to destroy the 'default' VM? [y/N] y
==> default: Destroying VM and associated drives...
</pre>
