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
