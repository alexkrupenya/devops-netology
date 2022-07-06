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
