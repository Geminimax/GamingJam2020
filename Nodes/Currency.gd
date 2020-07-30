extends Area2D
const FOLLOW_PLAYER_RADIUS = 80
var approach_speed = 0
var approach_accel = 50

func _process(delta):
    var player = Global.player
    if player:
        if global_position.distance_to(player.body.global_position) < FOLLOW_PLAYER_RADIUS:
            global_position = global_position + global_position.direction_to(player.body.global_position) * approach_speed * delta
            approach_speed += delta * approach_accel
            


func collect_currency():
    queue_free()
