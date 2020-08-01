extends Node2D

# grupo spawners
# grupo panels

signal level_restart
signal level_done(next_level)
export (PackedScene) var next_level

var running = true
var wave_max_time = -1
var base_hp
var wave_base_time = 1
var panels = []
var font = load("res://Assets/Pixeled.ttf")
var visible_enemies = 0
const WAVES_TO_NEXT_LEVEL = 4

var fireworks = preload("res://Nodes/VictoryFireworks.tscn")
onready var dynfont = DynamicFont.new()

func _ready():
    randomize()
    dynfont.font_data = preload("res://Assets/Pixeled.ttf")
    dynfont.size = 7
    #font.size = 16
    
    #$HeartBox.setup(START_BASE_HP)
    
    var spawners = get_tree().get_nodes_in_group("spawners")
    $WaveWait.wait_time = spawners[0].FIRST_WAVE_WAIT
    wave_base_time = spawners[0].WAVE_BASE_TIME
    for spawner in spawners:
        spawner.setnav_2d($Level)
        $WaveWait.connect("timeout", spawner, "spawn_wave")

    for panel in get_tree().get_nodes_in_group("panels"):
        panel.rect_size.y = 54
        panels.push_back(panel)
    $WaveWait.start()

func _process(delta):
    base_hp = $EnemyObjective/CombatStats.health
    if running:
        if get_tree().get_nodes_in_group("spawners")[0].wave_count >= WAVES_TO_NEXT_LEVEL and visible_enemies <= 0:
            handle_win()
            running = false
        if base_hp <= 0:
            handle_defeat()
            running = false

func handle_win():
    $WaveWait.stop()
    $WavesRemaining.visible = false
    var spawners = get_tree().get_nodes_in_group("spawners")
    $ResultMessage.text = "Victory!"
    for s in spawners:
        s.should_spawn = false
    fireworks()
    emit_signal("level_done", next_level)

func fireworks():
    for child in $ResultMessage.get_children():
        var particle_instance = fireworks.instance()
        child.add_child(particle_instance)

func handle_defeat():
    $ResultMessage.text = "Defeat"
    var spawners = get_tree().get_nodes_in_group("spawners")
    $WaveWait.stop()
    for s in spawners:
        s.stop_all_enemies(true)
    emit_signal("level_restart")
    
func spawn_wave_enemyspawners():
    wave_max_time = -1.0
    var spawners = get_tree().get_nodes_in_group("spawners")
    var wave_count = spawners[0].wave_count
    
    if wave_count >= WAVES_TO_NEXT_LEVEL:
        $WaveWait.stop()
        return

    $WavesRemaining.text = "Waves remaining: " + str(WAVES_TO_NEXT_LEVEL - wave_count)
    for i in spawners.size():
        var types = []
        var count = []
        print("spawner wi - " + str(spawners[i].wave_interval))
        wave_max_time = max(wave_max_time, spawners[i].wave_interval)
        print("wave max time - " + str(wave_max_time))
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
        sprite.position = Vector2(i * 31 + 13,  12)
        panel.add_child(sprite)

    for i in count.size():
        var lbl = Label.new()
        lbl.text = "x" + str(count[i])
        lbl.margin_top = 32.0
        lbl.margin_left = 5 + i * 31
        lbl.add_font_override("font", dynfont)
        panel.add_child(lbl)
    
func enemy_spawning():
    visible_enemies += 1
    print(visible_enemies)  

func visible_enemies_decrease():
    visible_enemies -= 1
    print(visible_enemies)
    
func enemy_reached_end():
    base_hp -= 1
    print("base hp - " + str(base_hp))
    $HeartBox.update_hearts(base_hp)
        
static func delete_all_children(node):
    for n in node.get_children():
        node.remove_child(n)
        n.queue_free()

func _on_MainCharacterController_player_coins(amount):
    $CoinDisplay/Label.text = str(amount)
