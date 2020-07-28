extends "res://Nodes/Character/BaseCharacterController.gd"

var holdable_character_in_range = null setget set_holdable_character_in_range;
var holded_character = null
var drop_distance = 80
var cast_distance = 80
onready var drop_cast : RayCast2D = $PhysicCharacterBody/DropSpotRaycast
onready var character_cast : RayCast2D = $PhysicCharacterBody/CharacterRaycast
onready var hold_position = $PhysicCharacterBody/HoldPosition


func _process(delta):
	if body:
		var movement_direction = (get_horizontal_input() + get_vertical_input()).normalized()
		body.velocity = lerp(body.velocity, movement_direction * move_speed, accel_lerp_weight * delta)
		
	if holded_character:
		holded_character.global_position = hold_position.global_position
		if Input.is_action_just_pressed("drop_tower"):
			var drop_position = body.global_position + Vector2.RIGHT.rotated(get_mouse_angle()) * drop_distance 
			if check_cast(drop_position,drop_cast):
				drop_character()
	else:		
		var cast_position = body.global_position + Vector2.RIGHT.rotated(get_mouse_angle()) * drop_distance 
		if(check_cast(cast_position,character_cast)):
			var collect_area = character_cast.get_collider()
			set_holdable_character_in_range(collect_area.controller)
		else:
			set_holdable_character_in_range(null)
			
		if holdable_character_in_range:
			if Input.is_action_just_pressed("pick_tower"):
				pick_character()
				

func check_cast(cast_position,raycast):
	raycast.cast_to = cast_position -  body.global_position 
	raycast.force_raycast_update()
	return raycast.is_colliding()

func set_holdable_character_in_range(new):
	var previous = holdable_character_in_range
	if(previous == new):
		return
	if(previous):
		previous.pickup_range_exited()
		
	if(new):
		new.pickup_range_entered()
	holdable_character_in_range = new

func pick_character():
	holded_character = holdable_character_in_range
	holded_character.pickup()
	set_holdable_character_in_range(null)
	
func drop_character():
	var drop_spot = drop_cast.get_collider()
	if(drop_spot and drop_spot.available):
		holded_character.drop(drop_spot)
		set_holdable_character_in_range(holded_character)
		holded_character = null
		

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


