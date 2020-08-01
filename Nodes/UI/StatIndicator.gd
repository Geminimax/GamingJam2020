extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var amount = 0 setget set_amount
export (Texture) var icon_texture
# Called when the node enters the scene tree for the first time.
func _ready():
    $VSplit/Icon.texture = icon_texture

func set_amount(value):
    amount = value
    $VSplit/Label.text = str(amount)
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass
