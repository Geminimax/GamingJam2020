extends "res://Nodes/Combat/CombatStats.gd"

var path = PoolVector2Array() setget set_path

var pos: Vector2

func _ready():
    set_process(false)

func _process(delta):
    var move_dist = speed * delta
    move_along_path(move_dist)

func move_along_path(distance: float):
    var start_point = pos
    for i in range(path.size()):
        var distance_to_next = start_point.distance_to(path[0])
        if distance <= distance_to_next and distance >= 0.0:
            pos = start_point.linear_interpolate(path[0], distance / distance_to_next)
            break
        elif path.size() == 1 and distance > distance_to_next:
            pos = path[0]
            set_process(false)
            handle_enemy_reaching_end()
        distance -= distance_to_next
        start_point = path[0]
        path.remove(0)

func handle_enemy_reaching_end():
    queue_free()

func set_path(value: PoolVector2Array):
    path = value
    if value.size() == 0:
        return
    set_process(true)
