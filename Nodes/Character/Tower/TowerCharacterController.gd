extends "res://Nodes/Character/BaseCharacterController.gd"
enum STATE{INACTIVE,DEFAULT, PICKUP}
var state = STATE.INACTIVE
func _ready():
	$PhysicCharacterBody/CharacterCollectionArea.controller = self

func pickup():
	state = STATE.PICKUP
	print("Hello, I am being picked up")
	$PhysicCharacterBody/PhysicBodyShape.set_deferred("disabled",true)

func drop():
	state = STATE.DEFAULT
	print("Dropped!")
