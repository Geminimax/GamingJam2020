extends Node2D

var path = PoolVector2Array() setget set_path
onready var combat_stats = $CombatStats
func _ready():
    $AttackRadius/CollisionShape2D.shape.radius = $CombatStats.attack_range
    set_process(false)
    $SpriteHealthBar.combat_stats = combat_stats
    $DetectionArea.controller = self

func _process(delta):
    var move_dist = $CombatStats.speed * delta
    move_along_path(move_dist)

func move_along_path(distance: float):
    var start_point = position
    for i in range(path.size()):
        var distance_to_next = start_point.distance_to(path[0])
        if distance <= distance_to_next and distance >= 0.0:
            global_position = start_point.linear_interpolate(path[0], distance / distance_to_next)
            break
        elif path.size() == 1 and distance > distance_to_next:
            global_position = path[0]
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


func _on_CombatStats_death():
    queue_free()


func _on_CombatStats_health_changed():
    $CPUParticles2D.restart()
    $AnimationPlayer.play("TakeDamage")
