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
    wave_max_time = -1
    for spawner in get_tree().get_nodes_in_group("spawners"):
        wave_max_time = max(wave_max_time, spawner.wave_interval)
    $WaveWait.wait_time = wave_max_time + wave_base_time
    print($WaveWait.wait_time)
    $WaveWait.start()
