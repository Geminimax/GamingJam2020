extends PanelContainer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.


func add_enemy_count_display(display):
    $HBoxContainer.add_child(display)
    
func clear():
    for n in $HBoxContainer.get_children():
        n.free()
