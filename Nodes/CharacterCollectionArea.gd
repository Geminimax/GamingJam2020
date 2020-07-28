extends Area2D

var controller

func pickup():
	controller.pickup()
	
func pickup_range_entered():
	controller.pickup_range_entered()
