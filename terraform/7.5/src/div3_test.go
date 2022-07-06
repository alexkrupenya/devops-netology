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
