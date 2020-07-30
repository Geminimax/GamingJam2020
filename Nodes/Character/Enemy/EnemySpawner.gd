extends Node2D

export (Array,Resource) var wave_configuration
var nav_2d: Navigation2D = null setget setnav_2d
export (Vector2) var start = global_position
export (Vector2) var end = Vector2(700, 450)
var path = null
var reset_path = true

var is_ready = false

func _ready():
    $WaveCooldown.wait_time = FIRST_WAVE_WAIT
    set_process(false)

func _process(delta):
    pass

func gen_path(start: Vector2, end: Vector2):
    var new_path = nav_2d.get_simple_path(start, end, true)
    path = new_path

# TODO @arsukeey Fazer o start e end (objective) serem recebidos por argumentos aqui
func setnav_2d(value: Navigation2D):
    if value != null:
        nav_2d = value
        gen_path(start, end)
        $WaveCooldown.start()
        is_ready = true

const ENEMIES_PER_WAVE = 3

const WAVE_BASE_TIME = 2.0
const FIRST_WAVE_WAIT = 3.0

var enemies_count = 0
var wave_count = 0

var current_enemy = null
var enemy_quantity = 0
var next_wave_wait = 1.0
var enemy_spawn_wait = 0.5

func spawn_wave():
    wave_count += 1
    $WaveCooldown.wait_time = WAVE_BASE_TIME + next_wave_wait
    print($WaveCooldown.wait_time)
    for wave in wave_configuration:
        if wave_count > wave.wave_count:
            break
        for enemy in wave.enemy_configuration:
            current_enemy = enemy.enemy_type
            enemy_quantity = enemy.enemy_count + (wave_count - 1) * enemy.enemy_count_progression
            next_wave_wait = float(float(enemy.enemy_count) * enemy_spawn_wait + wave_count * enemy.enemy_count_progression)
            if enemy_quantity > 0:
                for i in range(enemy_quantity):
                    spawn_enemy(current_enemy)
                    yield(get_tree().create_timer(0.5), "timeout")

func spawn_enemy(type: PackedScene):
    var enemy = type.instance()
    add_child(enemy)
    enemy.position = start
    enemy_spawn_wait = enemy.wait_time
    enemy.set_path(path)
