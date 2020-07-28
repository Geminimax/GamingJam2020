extends "res://Nodes/Character/BaseCharacterController.gd"

var holdable_character_in_range = null
var holded_character = null
var drop_distance = 60
onready var drop_cast : RayCast2D = $PhysicCharacterBody/RayCast2D
onready var hold_position = $PhysicCharacterBody/HoldPosition

func _process(delta):
	if body:
		var movement_direction = (get_horizontal_input() + get_vertical_input()).normalized()
		body.velocity = lerp(body.velocity, movement_direction * move_speed, accel_lerp_weight * delta)
	if holded_character:
		holded_character.global_position = hold_position.global_position
		if(Input.is_action_just_pressed("drop_tower")):
			var drop_position = body.global_position + Vector2.RIGHT.rotated(get_mouse_angle()) * drop_distance 
			if(check_blocks_drop(drop_position)):
				return
			holded_character.global_position = drop_position
			holded_character.drop()
			holdable_character_in_range = holded_character
			holded_character = null
	elif holdable_character_in_range:
		if(Input.is_action_just_pressed("pick_tower")):
			holded_character = holdable_character_in_range
			holdable_character_in_range = null
			holded_character.pickup()
			
func check_blocks_drop(drop_position):
	drop_cast.cast_to = drop_position -  body.global_position 
	drop_cast.force_raycast_update()
	return drop_cast.is_colliding()

func get_mouse_angle():
	var mouse_position = get_global_mouse_position()
	return body.global_position.direction_to(mouse_position).angle()
func get_vertical_input():
	var input = 0
	if(Input.is_action_pressed("move_up")):
		input = -1
	elif(Input.is_action_pressed("move_down")):
		input = 1
	return Vector2(0,input)
	
func get_horizontal_input():
	var input = 0
	if(Input.is_action_pressed("move_left")):
		input = -1
	elif(Input.is_action_pressed("move_right")):
		input = 1
	return Vector2(input,0)


func _on_CollectionRange_area_entered(area):
	print("Character collected")
	area.pickup_range_entered()
	holdable_character_in_range = area.controller
