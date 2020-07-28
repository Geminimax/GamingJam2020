extends Area2D

var available = true



func occupy_spot():
    available = false
    visible = false
    $CollisionShape2D.set_deferred("disabled",true)

func empty_spot():
    visible = true
    available = true
    $CollisionShape2D.set_deferred("disabled",false)
