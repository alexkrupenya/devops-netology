# Домашнее задание к занятию "7.5. Основы golang"

С `golang` в рамках курса, мы будем работать не много, поэтому можно использовать любой IDE. 
Но рекомендуем ознакомиться с [GoLand](https://www.jetbrains.com/ru-ru/go/).  

## Задача 1. Установите golang.
1. Воспользуйтесь инструкций с официального сайта: [https://golang.org/](https://golang.org/).
2. Так же для тестирования кода можно использовать песочницу: [https://play.golang.org/](https://play.golang.org/).

### Решение

Для установки golang воспользуюсь пакетным менеджером ОС.
```
[alexvk@archbox 7.3]$ sudo pacman -S go
resolving dependencies...
looking for conflicting packages...

Packages (1) go-2:1.18.3-1

Total Installed Size:  409,08 MiB

:: Proceed with installation? [Y/n] 
(1/1) checking keys in keyring                                                                       [############################################################] 100%
(1/1) checking package integrity                                                                     [############################################################] 100%
(1/1) loading package files                                                                          [############################################################] 100%
(1/1) checking for file conflicts                                                                    [############################################################] 100%
(1/1) checking available disk space                                                                  [############################################################] 100%
:: Processing package changes...
(1/1) installing go                                                                                  [############################################################] 100%
:: Running post-transaction hooks...
(1/1) Arming ConditionNeedsUpdate...

[alexvk@archbox 7.3]$ go version
go version go1.18.3 linux/amd64
```


## Задача 2. Знакомство с gotour.
У Golang есть обучающая интерактивная консоль [https://tour.golang.org/](https://tour.golang.org/). 
Рекомендуется изучить максимальное количество примеров. В консоли уже написан необходимый код, 
осталось только с ним ознакомиться и поэкспериментировать как написано в инструкции в левой части экрана.  

### Решение
Провел самообучение с интерактивным учебником по golang, указанным по ссылке в задании. 

## Задача 3. Написание кода. 
Цель этого задания закрепить знания о базовом синтаксисе языка. Можно использовать редактор кода 
на своем компьютере, либо использовать песочницу: [https://play.golang.org/](https://play.golang.org/).

1. Напишите программу для перевода метров в футы (1 фут = 0.3048 метр). Можно запросить исходные данные 
у пользователя, а можно статически задать в коде.
    Для взаимодействия с пользователем можно использовать функцию `Scanf`:
    ```
    package main
    
    import "fmt"
    
    func main() {
        fmt.Print("Enter a number: ")
        var input float64
        fmt.Scanf("%f", &input)
    
        output := input * 2
    
        fmt.Println(output)    
    }
    ```
 

### Решение

Для решения это задачи воспользуюсь приведенным примером. Программа запросит данные у пользователя и выведет результат работы в stdio.  
Для создания кода использовался текстовый редактор, запуск кода производился локально. 
```go
package main

import (
	"fmt"
	"math"
)

// Функция округления до количества знаков после точки
func roundFloat(val float64, precision uint) float64 {
	ratio := math.Pow(10, float64(precision))
	return math.Round(val*ratio) / ratio
}

func main() {
	var input float64
	for {
		fmt.Print("Enter a number of meters, or \"0\" to break: ")
		fmt.Scanf("%f", &input)
		if input == 0 {
			break
		}
		fmt.Println("Feet: ", roundFloat((input/0.3048), 2))
	}
}
```
Запущу программу и проверю результат работы:
```
[alexvk@archbox go]$ go run convert.go 
Enter a number of meters, or "0" to break: 10
Feet:  32.81
Enter a number of meters, or "0" to break: 25
Feet:  82.02
Enter a number of meters, or "0" to break: 49
Feet:  160.76
Enter a number of meters, or "0" to break: 0
```
Результат перевода округляется до двух знаков после запятой.  
[Исходный текст](src/convert.go)


1. Напишите программу, которая найдет наименьший элемент в любом заданном списке, например:
    ```
    x := []int{48,96,86,68,57,82,63,70,37,34,83,27,19,97,9,17,}
    ```

### Решение 

Для решения задачи воспользуюсь готовой функцией сортировки golang. После сортировки первый элемент отсортированного массива
и будет искомым результатом.
```go
package main

import (
	"fmt"
	"sort"
)

func MinimumInt(arr []int) int {
	sort.Ints(arr)
	return arr[0]
}

func main() {
	x := []int{48, 96, 86, 68, 57, 82, 63, 70, 37, 34, 83, 27, 19, 97, 9, 17}
	fmt.Println("Slice values are:\n", x)
	fmt.Println("Minimum in slice is:\n", MinimumInt(x))
}
```
Результат работы:
```
[alexvk@archbox go]$ go run minimum.go 
Slice values are:
 [48 96 86 68 57 82 63 70 37 34 83 27 19 97 9 17]
Minimum in slice is:
 9
```
[Исходный текст](src/minimum.go)


1. Напишите программу, которая выводит числа от 1 до 100, которые делятся на 3. То есть `(3, 6, 9, …)`.

В виде решения ссылку на код или сам код. 

### Решение

Решение очевидно. Это проверка целочисленного деления числа на 3. Если в результате частное равно нулю, то
делимое соответствует искомому критерию.
```go
package main

import "fmt"

func Find3() []int {
	var num int
	x := make([]int, 0)
	for num = 1; num <= 100; num++ {
		if num%3 == 0 {
			x = append(x, num)
		}
	}
	return x
}

func main() {
	fmt.Println(Find3())
}
```

Вывод результата запуска:
```
[alexvk@archbox go]$ go run div3.go 
[3 6 9 12 15 18 21 24 27 30 33 36 39 42 45 48 51 54 57 60 63 66 69 72 75 78 81 84 87 90 93 96 99]
```
[Исходный текст](src/div3.go)

## Задача 4. Протестировать код (не обязательно).

Создайте тесты для функций из предыдущего задания. 

### Решение
Создам пример теста для последнего задания, т.к. оно уже удобно для этого оформлено и главный блок расчета выделен 
в отдельную функцию. Файл задания называется "div3.go", для юнит-теста создам файл "div3_test.go". Исходный текст теста:
```go
package main

import (
	"reflect"
	"testing"
)

func TestFind3(t *testing.T) {
	z := []int{3, 6, 9, 12, 15, 18, 21, 24, 27, 30, 33, 36, 39, 42, 45, 48, 51, 54, 57, 60, 63, 66, 69, 72, 75, 78, 81, 84, 87, 90, 93, 96, 99}
	if !reflect.DeepEqual(Find3(), z) {
		t.Error("Expected numbers divided by 3")
	}
}
```
Массив "z" содержит значения, которые и буду сравнивать со значениями из результата работы функции Find3().
```
[alexvk@archbox go]$ go test div3.go div3_test.go 
ok  	command-line-arguments	0.005s
```
Тест прошел. Теперь поменяю в файле теста в массиве z значение 3 на значение 4 и запущу проверку снова:
```
[alexvk@archbox tmp]$ go test div3.go div3_test.go 
--- FAIL: TestFind3 (0.00s)
    div3_test.go:11: Expected numbers divided by 3
FAIL
FAIL	command-line-arguments	0.006s
FAIL
```
Тест не прошел, значения массивов не совпали.  
[Исходный текст](src/div3_test.go)

---

### Как cдавать задание

Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.

---

