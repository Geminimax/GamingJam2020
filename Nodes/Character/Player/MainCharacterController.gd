extends "res://Nodes/Character/BaseCharacterController.gd"

var holded_character = null
onready var hold_position = $PhysicCharacterBody/HoldPosition
onready var drop_position = $PhysicCharacterBody/DropPosition
func _process(delta):
    if body:
        var movement_direction = (get_horizontal_input() + get_vertical_input()).normalized()
        body.velocity = lerp(body.velocity, movement_direction * move_speed, accel_lerp_weight * delta)
    if holded_character:
        holded_character.global_position = hold_position.global_position
        if(Input.is_action_just_pressed("drop_tower")):
            holded_character.global_position = drop_position.global_position
            holded_character.drop()
            holded_character = null
        
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
    area.pickup()
    holded_character = area.controller
