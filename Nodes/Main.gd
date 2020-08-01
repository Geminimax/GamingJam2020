extends Node2D

var next_level = null
var current_level
var new_music = null
export (PackedScene) var level1

func _ready():
	var initial_level = level1.instance()
	add_child(initial_level)
	current_level = initial_level
	current_level.connect("level_done", self, "on_level_done")
	current_level.connect("level_restart", self, "restart_level")

func on_level_done(next_level):
	pass

func restart_level():
	pass
