extends Node2D

signal enemy_on_end
signal enemy_spawning
signal spawn_finished
export (Array,Resource) var wave_configuration
var nav_2d: Navigation2D = null setget setnav_2d
onready var start = global_position
var end
var path = null

func _ready():
    end = get_parent().get_node("EnemyObjective").global_position
    connect("enemy_spawning", get_parent(), "enemy_spawning")

func gen_path(start: Vector2, end: Vector2):
    var new_path = nav_2d.get_simple_path(start, end, true)
    path = new_path

# TODO @arsukeey Fazer o start e end (objective) serem recebidos por argumentos aqui
func setnav_2d(value: Navigation2D):
    if value != null:
        nav_2d = value
        gen_path(start, end)

const ENEMIES_PER_WAVE = 3

const WAVE_BASE_TIME = 0.0
const FIRST_WAVE_WAIT = 3.0

var enemies_count = 0
var wave_count = 0
var completed = false
var current_enemy = null
var enemy_quantity = 0
var next_wave_wait = 1.0
var enemy_spawn_wait = 0.5
var wave_interval = 0.0
var should_spawn = true
var current_wave_progress = 0
var current_wave_configuration = 0
#func spawn_wave():
#    wave_count += 1
#    wave_interval = 0.0
#    for wave in wave_configuration:
#        if wave_count > wave.wave_count and wave.wave_count > 0:
#            break
#        for enemy in wave.enemy_configuration:
#            current_enemy = enemy.enemy_type
#            enemy_quantity = enemy.enemy_count + (wave_count - 1) * enemy.enemy_count_progression
#            if enemy_quantity > 0:
#                for i in range(enemy_quantity):
#                    if should_spawn:
#                        spawn_enemy(current_enemy)
#                        yield(get_tree().create_timer(enemy_spawn_wait), "timeout")
func spawn_wave(wave_time):
    if current_wave_configuration >= wave_configuration.size():
        completed = true
        return
    if(current_wave_progress > wave_configuration[current_wave_configuration].wave_count):
        current_wave_progress = 0
        current_wave_configuration += 1
        if current_wave_configuration >= wave_configuration.size():
            completed = true
            return
    current_wave_progress += 1
    var total_enemy_count = get_total_enemy_count()
    var wave = wave_configuration[current_wave_configuration]
    for enemy in wave.enemy_configuration:
            current_enemy = enemy.enemy_type
            enemy_quantity = enemy.enemy_count + (current_wave_progress - 1) * enemy.enemy_count_progression
            if enemy_quantity > 0:
                for i in range(enemy_quantity):
                    if should_spawn:
                        spawn_enemy(current_enemy)
                        yield(get_tree().create_timer(wave_time/total_enemy_count), "timeout")
    
    emit_signal("spawn_finished")
func stop_all_enemies(kill: bool):
    for enemy in get_tree().get_nodes_in_group("enemies"):
        if kill:
            enemy.queue_free()
        else:
            enemy.path = []
func get_total_enemy_count():
    var count = 0
    var wave = wave_configuration[current_wave_configuration]
    for enemy in wave.enemy_configuration:
        count += enemy.enemy_count + (current_wave_progress - 1) * enemy.enemy_count_progression
    return count
func spawn_enemy(type: PackedScene):
    emit_signal("enemy_spawning")
    var enemy = type.instance()
    enemy.add_to_group("enemies")
    enemy.connect("enemy_on_end", get_parent(), "enemy_reached_end")
    enemy.connect("tree_exited", get_parent(), "visible_enemies_decrease")
    add_child(enemy)
    enemy.global_position = start
    enemy_spawn_wait = enemy.wait_time
    wave_interval += enemy.wave_interval
    enemy.set_path(path)

func get_total_waves():
    var count = 0
    for wave in wave_configuration:
        count += wave.wave_count
    return count
