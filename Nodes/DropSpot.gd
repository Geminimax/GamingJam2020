extends Area2D

var available = true
export (bool) var active = true
var occupying

func occupy_spot(tower):
    available = false
    visible = false
    occupying = tower
    $CollisionShape2D.set_deferred("disabled",true)

func empty_spot():
    visible = true
    available = true
    $CollisionShape2D.set_deferred("disabled",false)
