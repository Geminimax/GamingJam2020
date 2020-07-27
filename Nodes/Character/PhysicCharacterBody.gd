extends KinematicBody2D
class_name PhysicCharacterBody

var velocity : Vector2 = Vector2()

func _process(delta):
	move_and_slide(velocity)
