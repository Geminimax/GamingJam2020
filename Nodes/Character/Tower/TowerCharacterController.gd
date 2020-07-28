extends "res://Nodes/Character/BaseCharacterController.gd"
enum STATE{INACTIVE,DEFAULT, PICKUP}
var state = STATE.INACTIVE
var positioned_spot = null
func _ready():
	$PhysicCharacterBody/CharacterCollectionArea.controller = self
	
func pickup_range_entered():
	$PhysicCharacterBody/Selector.visible = true

func pickup_range_exited():
	$PhysicCharacterBody/Selector.visible = false

func pickup():
	if(positioned_spot):
		positioned_spot.empty_spot()
		positioned_spot = null
	state = STATE.PICKUP
	$PhysicCharacterBody/PhysicBodyShape.set_deferred("disabled",true)

func drop(spot):
	$PhysicCharacterBody/AnimationPlayer.play("Squish")
	global_position = spot.global_position
	spot.occupy_spot()
	positioned_spot = spot
	state = STATE.DEFAULT
