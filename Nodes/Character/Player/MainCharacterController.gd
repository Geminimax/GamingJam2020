extends "res://Nodes/Character/BaseCharacterController.gd"

var holdable_character_in_range = null setget set_holdable_character_in_range;
var holded_character = null
var drop_distance = 60
var cast_distance = 60
var currency_amount = 0

export (int,LAYERS_2D_PHYSICS) var character_pickup_layer
export (int,LAYERS_2D_PHYSICS) var character_drop_layer
onready var hold_position = $PhysicCharacterBody/HoldPosition
onready var upgrade_progress = $UpgradeProgressUI

func _ready():
    Global.player = self

func _process(delta):
    if body:
        var movement_direction = (get_horizontal_input() + get_vertical_input()).normalized()
        body.velocity = lerp(body.velocity, movement_direction * move_speed, accel_lerp_weight * delta)
        
    if holded_character:
        holded_character.global_position = hold_position.global_position
        if Input.is_action_just_pressed("drop_tower"):
            var drop_position = body.global_position + Vector2.RIGHT.rotated(get_mouse_angle()) * drop_distance 
            var collider = check_cast(drop_position,character_drop_layer)
            print(collider)
            if collider:
                drop_character(collider)
    else:
        var cast_position = body.global_position + Vector2.RIGHT.rotated(get_mouse_angle()) * drop_distance 
        var collider = check_cast(cast_position,character_pickup_layer)
        print(collider)
        if collider:
            var collect_area = collider
            set_holdable_character_in_range(collect_area.controller)
        else:
            set_holdable_character_in_range(null)

        if holdable_character_in_range:
            if Input.is_action_just_pressed("pick_tower"):
               
                pick_character()
            elif Input.is_action_just_pressed("upgrade_tower"):
                var cost = holdable_character_in_range.get_
                

func check_cast(cast_position,layer):
    var space_state = get_world_2d().direct_space_state
    var result = space_state.intersect_point(cast_position,1,[],layer,true,true)
    if(result):
        return result[0].collider

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
    
func drop_character(drop_spot):
    if(drop_spot.available):
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


func _on_CurrencyCollectionArea_area_entered(area):
    currency_amount += 1
    area.collect_currency()
