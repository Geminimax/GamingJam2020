extends Node2D

var wave_max_time = -1
var base_hp = 5
var wave_base_time
var panels = []
var font = load("res://Assets/Pixeled.ttf")
const WAVES_TO_NEXT_LEVEL = 4

func _ready():
    randomize()
    #font.size = 16
    $WaveWait.wait_time = $EnemySpawner1.FIRST_WAVE_WAIT
    wave_base_time = $EnemySpawner1.WAVE_BASE_TIME
    for spawner in get_tree().get_nodes_in_group("spawners"):
        spawner.setnav_2d($Level)

    for panel in get_tree().get_nodes_in_group("panels"):
        panel.rect_size.y = 54
        panels.push_back(panel)
    $WaveWait.start()

func handle_win():
    var spawners = get_tree().get_nodes_in_group("spawners")
    for i in spawners:
        i.stop_all_enemies(true)
    
func spawn_wave_enemyspawners():
    wave_max_time = -1
    var spawners = get_tree().get_nodes_in_group("spawners")
    var wave_count = spawners[0].wave_count
    
    if wave_count >= WAVES_TO_NEXT_LEVEL:
        $WaveWait.stop()
        handle_win()
        return
    $WavesRemaining.text = "Waves remaining: " + str(WAVES_TO_NEXT_LEVEL - wave_count)
    for i in spawners.size():
        var types = []
        var count = []
        
        wave_max_time = max(wave_max_time, spawners[i].wave_interval)
        
        for wave in spawners[i].wave_configuration:
            for enemy in wave.enemy_configuration:
                types.push_back(enemy.enemy_type)
                count.push_back(enemy.enemy_count + (wave_count + 1) * enemy.enemy_count_progression)
        make_wave_panel(panels[i], types, count)
    
    $WaveWait.wait_time = wave_max_time + wave_base_time
    $WaveWait.start()
              
func make_wave_panel(panel: Panel, types, count):
    panel.rect_size.x = 30 * types.size()
    panel.visible = true
    delete_all_children(panel)
    for i in types.size():
        var texture = types[i].instance().get_node("Sprite").frames.get_frame("default", 0)
        
        var sprite = Sprite.new()
        sprite.texture = texture
        sprite.position = Vector2(i * 30 + 10,  12)
        panel.add_child(sprite)

    for i in count.size():
        var lbl = Label.new()
        lbl.text = "x" + str(count[i])
        lbl.margin_top = 40.0
        lbl.margin_left = 5 + i * 30
        panel.add_child(lbl)
        lbl.add_font_override("font", font)

func enemy_reached_end():
    base_hp -= 1
        
static func delete_all_children(node):
    for n in node.get_children():
        node.remove_child(n)
        n.queue_free()
