extends Node2D
enum STATE{FOLLOW_PATH, ATTACKING}
var state = STATE.FOLLOW_PATH
var path = PoolVector2Array() setget set_path
onready var combat_stats = $CombatStats
var current_target = null
var flock_distancing_speed = 20

signal enemy_on_end

export (int, LAYERS_2D_PHYSICS) var enemy_layer = 0

export (float) var wait_time = 0.5
export (float) var wave_interval = 0.3
export (PackedScene) var coin_scene 
export (float) var coin_velocity_range = 60
export (float) var drop_coin_amount = 3

func _ready():
    $AttackRadius/CollisionShape2D.shape.radius = $CombatStats.attack_range
    set_process(false)
    $TinySpriteHealthbar.combat_stats = combat_stats
    $DetectionArea.controller = self

func _process(delta):
    if(state == STATE.FOLLOW_PATH):
        var move_dist = $CombatStats.speed * delta
        move_along_path(move_dist)
    else: 
        var direction_to_target = global_position.direction_to(current_target.body.global_position)
        var close = get_close_enemies()
        var resulting = Vector2()
        for i in close:
            if i.collider.controller.current_target == current_target:
                var opposite_direction = -global_position.direction_to(i.collider.global_position)
                resulting =+ opposite_direction
        if(global_position.distance_to(current_target.body.global_position) > combat_stats.attack_range):
            resulting += direction_to_target
        global_position += resulting.normalized() * flock_distancing_speed * delta
        
func move_along_path(distance: float):
    var start_point = global_position
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

func get_close_enemies():
    var space_state = get_world_2d().direct_space_state
    var shape : CircleShape2D = CircleShape2D.new()
    shape.radius = 10
    var physicsShape : Physics2DShapeQueryParameters = Physics2DShapeQueryParameters.new()
    physicsShape.collision_layer = enemy_layer
    physicsShape.collide_with_areas = true
    physicsShape.transform = self.global_transform
    physicsShape.set_shape(shape)
    physicsShape.exclude = [$DetectionArea]
    var result = space_state.intersect_shape(physicsShape,32) 
   # print(result)
    return result
    
func handle_enemy_reaching_end():
    emit_signal("enemy_on_end")
    queue_free()
    
func spawn_coin():
    var coin = coin_scene.instance()
    get_parent().add_child(coin)
    coin.global_position = global_position
    coin.velocity = Vector2.RIGHT.rotated(deg2rad(rand_range(0,360))) * rand_range(-coin_velocity_range,coin_velocity_range)
    
func set_path(value: PoolVector2Array):
    path = value
    if value.size() == 0:
        return
    set_process(true)


func _on_CombatStats_death():
    for i in range(drop_coin_amount):
         spawn_coin()
    queue_free()


func _on_CombatStats_health_changed():
    $CPUParticles2D.restart()
    $AnimationPlayer.play("TakeDamage")


func _on_AttackRadius_area_entered(area):
    var controller = area.controller
    if (controller.current_engaged_enemies >= controller.maximum_engaged_enemies):
       return
    controller.current_engaged_enemies += 1
    if current_target == null:
        current_target = area.controller
    combat_stats.add_valid_target(area.controller.combat_stats)
    state = STATE.ATTACKING

func _on_AttackRadius_area_exited(area):
    if area.controller ==  current_target:
        current_target = null
        area.controller.current_engaged_enemies -= 1
    combat_stats.remove_valid_target(area.controller.combat_stats)
    if !combat_stats.has_valid_targets():
        state = STATE.FOLLOW_PATH
