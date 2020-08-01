extends VBoxContainer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var texture setget set_texture
var count setget set_count

func set_texture(value):
    texture = value
    $Icon.texture = texture

func set_count(value):
    count = value
    $Text.bbcode_text = "[center]x" + str(value)
