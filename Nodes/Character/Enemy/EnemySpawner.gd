extends Node2D

signal next_wave_time(time)

export (Array,Resource) var wave_configuration
var nav_2d: Navigation2D = null setget setnav_2d
onready var start = global_position
var end
var path = null
var reset_path = true

func _ready():
    end = get_parent().get_node("EnemyObjective").global_position

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

var current_enemy = null
var enemy_quantity = 0
var next_wave_wait = 1.0
var enemy_spawn_wait = 0.5
var wave_interval = 0.0

func spawn_wave():
    wave_count += 1
    #get_parent().wait_times.push_back(wave_interval + WAVE_BASE_TIME)
    wave_interval = 0.0
    for wave in wave_configuration:
        if wave_count > wave.wave_count and wave.wave_count > 0:
            break
        for enemy in wave.enemy_configuration:
            current_enemy = enemy.enemy_type
            enemy_quantity = enemy.enemy_count + (wave_count - 1) * enemy.enemy_count_progression
            if enemy_quantity > 0:
                for i in range(enemy_quantity):
                    spawn_enemy(current_enemy)
                    yield(get_tree().create_timer(enemy_spawn_wait), "timeout")

func spawn_enemy(type: PackedScene):
    var enemy = type.instance()
    add_child(enemy)
    enemy.global_position = start
    enemy_spawn_wait = enemy.wait_time
    wave_interval += enemy.wave_interval
    enemy.set_path(path)
