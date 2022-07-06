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
