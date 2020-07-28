extends Node2D

export (PackedScene) var GenericEnemy
export (PackedScene) var RareEnemy

export (Array,Resource) var wave_configuration
var nav_2d: Navigation2D = null setget setnav_2d
var start = Vector2(70, 350)
var end = Vector2(700, 450)
var path = null
var reset_path = true

var is_ready = false

func _ready():
	set_process(false)
	print("enemy spawner ready")

func _process(delta):
	pass

func gen_path(start: Vector2, end: Vector2):
	var new_path = nav_2d.get_simple_path(start, end)
	path = new_path

# TODO @arsukeey Fazer o start e end (objective) serem recebidos por argumentos aqui
func setnav_2d(value: Navigation2D):
	if value != null:
		nav_2d = value
		gen_path(start, end)
		$WaveCooldown.start()
		is_ready = true

const ENEMIES_PER_WAVE = 3

var enemies_count = 0
var wave = false

func spawn_wave():
	print(path)
	print("spawning wave")
	wave = true
	$EnemyCooldown.start()

func _on_EnemyCooldown_timeout():
	enemies_count += 1
	print("timeout enemy cooldown")
	if enemies_count >= ENEMIES_PER_WAVE:
		enemies_count = 0
		wave = false
		$EnemyCooldown.stop()
	spawn_enemy()

func spawn_enemy():
	var enemy
	if randf() <= 0.4:
		enemy = RareEnemy.instance()
	else:
		enemy = GenericEnemy.instance()
	add_child(enemy)
	enemy.position = start
	enemy.set_path(path)
