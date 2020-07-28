extends "res://Nodes/Character/BaseCharacterNavigation.gd"

var speed = 400.0
var path = PoolVector2Array() setget set_path

func _ready():
    character = $EnemySprite
    gen_path($ExampleObjective.global_position)
    
func _process(delta):
    pass
    
func set_path(val: PoolVector2Array):
    pass
