extends "res://Nodes/UI/BaseHealthbar.gd"
export (int) var sprite_base_width
export (int) var sprite_base_height
onready var fill = $Fill
onready var frame = $Frame
func _ready():
    fill.region_rect.size.y = sprite_base_height
    frame.region_rect.size.x = sprite_base_width
    frame.region_rect.size.y = sprite_base_height

func update_health_bar_value(current_value,max_value):
    var fill_amount = float(current_value)/float(max(1,max_value))
    fill.region_rect.size.x = fill_amount * sprite_base_width
    position.x = -sprite_base_width/2
