extends Node2D

# grupo spawners
# grupo panels

signal level_restart
signal level_done(next_level)
export (PackedScene) var next_level
export (PackedScene) var enemy_count_display

var running = true
var wave_max_time = -1
var base_hp
var wave_base_time = 1
var panels = []
var visible_enemies = 0
var waves_to_next_level = 0
export (float) var base_wave_time = 9.0
export (float) var wave_time_progress = 2.0
export (float) var rest_time = 6.0
var total_wave_count = 0


var fireworks = preload("res://Nodes/VictoryFireworks.tscn")
onready var dynfont = DynamicFont.new()

func _ready():
    randomize()
    #font.size = 16
    
    #$HeartBox.setup(START_BASE_HP
    var spawners = get_tree().get_nodes_in_group("spawners")
    for spawner in spawners:
        spawner.setnav_2d($Level)
    waves_to_next_level = spawners[0].get_total_waves()
    for panel in get_tree().get_nodes_in_group("panels"):
        panels.push_back(panel)
    $WaveTimer.start()

func _process(delta):
    base_hp = $EnemyObjective/CombatStats.health
    if running:
        if get_tree().get_nodes_in_group("spawners")[0].wave_count >= waves_to_next_level and visible_enemies <= 0:
            handle_win()
            running = false
        if base_hp <= 0:
            handle_defeat()
            running = false

func handle_win():
    $WaveTimer.stop()
    $WavesRemaining.visible = false
    var spawners = get_tree().get_nodes_in_group("spawners")
    $ResultMessage.text = "Victory!"
    for s in spawners:
        s.should_spawn = false
    fireworks()
    yield(get_tree().create_timer(5.0),"timeout")
    emit_signal("level_done", next_level)

func fireworks():
    for child in $ResultMessage.get_children():
        var particle_instance = fireworks.instance()
        child.add_child(particle_instance)

func handle_defeat():
    $ResultMessage.text = "Defeat"
    var spawners = get_tree().get_nodes_in_group("spawners")
    $WaveTimer.stop()
    for s in spawners:
        s.stop_all_enemies(true)
    yield(get_tree().create_timer(5.0),"timeout")
    emit_signal("level_restart")
    
func spawn_wave_enemyspawners():
    if(total_wave_count >= waves_to_next_level):
        return
    var time = base_wave_time + wave_time_progress * total_wave_count
    total_wave_count += 1
    
    var spawners = get_tree().get_nodes_in_group("spawners")
    var wave_count = spawners[0].wave_count
    
    $WavesRemaining.text = "Waves remaining: " + str(waves_to_next_level - total_wave_count)
    for i in spawners.size():
        var types = []
        var count = []
        print("spawner wi - " + str(spawners[i].wave_interval))
        wave_max_time = max(wave_max_time, spawners[i].wave_interval)
        
        var wave = spawners[i].wave_configuration[spawners[i].current_wave_configuration]
        for enemy in wave.enemy_configuration:
            types.push_back(enemy.enemy_type)
            count.push_back(enemy.enemy_count + (spawners[i].current_wave_progress) * enemy.enemy_count_progression)
        make_wave_panel(panels[i], types, count)
        spawners[i].spawn_wave(time)
    $WaveTimer.start(time)
    
              
func make_wave_panel(panel, types, count):
    panel.visible = true
    panel.clear()
    for i in types.size():
#
#        var sprite = Sprite.new()
#        sprite.texture = texture
#        sprite.position = Vector2(i * 31 + 10,  12)
        var texture = types[i].instance().get_node("Sprite").frames.get_frame("default", 0)
        var display = enemy_count_display.instance()
        display.texture = texture
        display.count = count[i]
        panel.add_enemy_count_display(display)

#    for i in count.size():
#        var lbl = Label.new()
#        lbl.text = "x" + str(count[i])
#        lbl.margin_top = 32.0
#        lbl.margin_left = 5 + i * 31
#        panel.add_child(lbl)
    
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
        

func _on_MainCharacterController_player_coins(amount):
    $CoinDisplay/Label.text = str(amount)


func _on_RestTimer_timeout():
    spawn_wave_enemyspawners()


func _on_WaveTimer_timeout():
    $RestTimer.start(rest_time)
