extends Node2D

var wave_max_time = -1
var wave_base_time

func _ready():
	randomize()
	$WaveWait.wait_time = $EnemySpawner1.FIRST_WAVE_WAIT
	wave_base_time = $EnemySpawner1.WAVE_BASE_TIME
	$EnemySpawner1.setnav_2d($Level)
	$EnemySpawner2.setnav_2d($Level)
	$WaveWait.start()

func spawn_wave_enemyspawners():
	# 0 - type, 1 - quantity, 2 - type...
	# used to display next wave enemies
	wave_max_time = -1
	var spawners = get_tree().get_nodes_in_group("spawners")
	for i in spawners.size():
		var types = []
		var count = []
		
		wave_max_time = max(wave_max_time, spawners[i].wave_interval)
		var wave_count = spawners[i].wave_count
		for wave in spawners[i].wave_configuration:
			for enemy in wave.enemy_configuration:
				types.push_back(enemy.enemy_type)
				count.push_back(enemy.enemy_count + wave_count * enemy.enemy_count_progression)
		match i:
			0:
				make_wave_panel($Panel1, types, count)
	
	$WaveWait.wait_time = wave_max_time + wave_base_time
	$WaveWait.start()
			  
func make_wave_panel(panel: Panel, types, count):
	panel.rect_size.x *= types.size()
	for i in types.size():
		var sprite = types[i].instance().get_node("Sprite")
		sprite.position = Vector2(i * 30 - 25,  5)
		$Panel1.add_child(sprite)

	for n in count:
		var lbl = Label.new()
		lbl.text = "x" + str(n)
		lbl.align = 1
		lbl.valign = 2
		$Panel1.add_child(lbl)
