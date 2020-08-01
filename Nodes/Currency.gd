extends Area2D
const FOLLOW_PLAYER_RADIUS = 80
var approach_speed = 0
var approach_accel = 50
var velocity = Vector2()

func _ready():
    set_as_toplevel(true)
    
func _process(delta):
    var player = Global.player
    $AnimatedSprite.modulate.a = $Timer.time_left / 10
    if player:
        if global_position.distance_to(player.body.global_position) < FOLLOW_PLAYER_RADIUS:
            global_position = global_position + global_position.direction_to(player.body.global_position) * approach_speed * delta
            approach_speed += delta * approach_accel
    global_position += velocity * delta
    velocity = velocity.linear_interpolate(Vector2.ZERO,delta * 2)

func collect_currency():
    queue_free()

func _on_Timer_timeout():
    queue_free()
