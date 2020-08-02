extends "res://Nodes/Character/BaseCharacterController.gd"
enum STATE{INACTIVE,DEFAULT, PICKUP}
const ATTACK_RANGE_MULTI = 50
var state = STATE.INACTIVE
var positioned_spot = null
var current_engaged_enemies = 0
export (int) var maximum_engaged_enemies = 3
onready var combat_stats  = $TowerCombatStats
onready var attack_range_shape : CircleShape2D = $PhysicCharacterBody/AttackRange/CollisionShape2D.shape
onready var stats_upgrade_container : Container = $CanvasLayer/StatsUpgradeHUD/Container
onready var draw_radius  = $PhysicCharacterBody/DrawRadius

func _ready():
    $PhysicCharacterBody/CharacterCollectionArea.controller = self
    $PhysicCharacterBody/DetectionArea.controller = self
    $PhysicCharacterBody/SpriteHealthBar.combat_stats = combat_stats
    update_stats()
    combat_stats.controller = self
    combat_stats.can_attack = false
    $PhysicCharacterBody/AnimatedSprite.play("inactive")
    draw_radius.deactivate()
    
func pickup_range_entered():
    $PhysicCharacterBody/Selector.visible = true

func pickup_range_exited():
    $PhysicCharacterBody/Selector.visible = false

func pickup():
    if(positioned_spot):
        positioned_spot.empty_spot()
        positioned_spot = null
    state = STATE.PICKUP
    $PhysicCharacterBody/AnimatedSprite.play("inactive")
    combat_stats.can_attack = false
    $PhysicCharacterBody/PhysicBodyShape.set_deferred("disabled",true)
    $PhysicCharacterBody/DetectionArea/CollisionShape2D.set_deferred("disabled",true)
    draw_radius.deactivate()

func drop(spot):
    $PhysicCharacterBody/AnimationPlayer.play("Squish")
    global_position = spot.global_position
    spot.occupy_spot(self)
    positioned_spot = spot
    if spot.active && combat_stats.health > 0:
        combat_stats.can_attack = true
        draw_radius.activate()
        state = STATE.DEFAULT
        $PhysicCharacterBody/AnimatedSprite.play("default")
        combat_stats.can_attack = true
        $PhysicCharacterBody/PhysicBodyShape.set_deferred("disabled",false)
        $PhysicCharacterBody/DetectionArea/CollisionShape2D.set_deferred("disabled",false)
    else:
        state = STATE.INACTIVE

func update_stats():
    attack_range_shape.radius = ATTACK_RANGE_MULTI * combat_stats.attack_range
    set_stats_ui()  

func _on_AttackRange_area_entered(area):
    if(area.controller.combat_stats):
        combat_stats.add_valid_target(area.controller.combat_stats)


func _on_AttackRange_area_exited(area):
    if(area.controller.combat_stats):
        combat_stats.remove_valid_target(area.controller.combat_stats)

func _process(delta):
    $CanvasLayer/StatsUpgradeHUD.rect_position = global_position
    update_stats()

func set_stats_ui():
    stats_upgrade_container.get_node("MaximumAttackingEnemies").set_amount(maximum_engaged_enemies)
    stats_upgrade_container.get_node("AttackDamage").set_amount(combat_stats.attack_damage)
    stats_upgrade_container.get_node("AttackSpeed").set_amount(combat_stats.attack_speed)
    stats_upgrade_container.get_node("AttackRange").set_amount(combat_stats.attack_range)
    stats_upgrade_container.get_node("MaxHp").set_amount(combat_stats.max_health)
    stats_upgrade_container.get_node("UpgradeCost").set_amount(int(combat_stats.get_level_up_price()))
    draw_radius.radius =  ATTACK_RANGE_MULTI * combat_stats.attack_range

func _on_TowerCombatStats_health_changed():
    $PhysicCharacterBody/AnimationPlayer.play("TakeDamage")

func show_stats():
    stats_upgrade_container.show()

func hide_stats():
    stats_upgrade_container.hide()

func quick_hide_stats():
    stats_upgrade_container.quick_hide()

func quick_show_stats():
    stats_upgrade_container.quick_show()

func max_level_handle():
        stats_upgrade_container.get_node("UpgradeCost").set_modulate(Color(1, 0, 0))


func _on_TowerCombatStats_death():
    state = STATE.INACTIVE
    $PhysicCharacterBody/PhysicBodyShape.set_deferred("disabled",true)
    $PhysicCharacterBody/DetectionArea/CollisionShape2D.set_deferred("disabled",true)
    $PhysicCharacterBody/AnimatedSprite.play("inactive")
    combat_stats.can_attack = false
