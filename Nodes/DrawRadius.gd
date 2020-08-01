extends Node2D
signal radius_entered(area)

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var amount = 14
export (float) var radius = 10 setget set_radius
export (PackedScene) var circleDot
# Called when the node enters the scene tree for the first time.
        
        
func update_radius():
    for children in get_children():
        children.queue_free()
    for i in range(amount):
        var c = circleDot.instance()
        add_child(c)
        c.position = Vector2.UP.rotated(deg2rad(i * (360/amount))) * radius
        c.rotation = deg2rad(i * (360/amount))


func _on_Area2D_area_entered(area):
    emit_signal("radius_entered",area)

func deactivate():
    visible = false
func activate():
    visible = true

func set_radius(value):
    radius = value
    amount = radius/2.5
    update_radius()
