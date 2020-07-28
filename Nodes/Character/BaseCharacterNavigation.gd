extends Node

var character: Sprite
onready var nav2d: Navigation2D = $Navigation2D
onready var line2d: Line2D = $Line2D

func gen_path(objective: Vector2):
    var new_path = nav2d.get_simple_path(character.global_position, objective)
    line2d.points = new_path
    character.path = new_path
