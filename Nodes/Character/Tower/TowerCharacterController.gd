extends "res://Nodes/Character/BaseCharacterController.gd"
enum STATE{INACTIVE,DEFAULT, PICKUP}
const ATTACK_RANGE_MULTI = 50
var state = STATE.INACTIVE
var positioned_spot = null
var current_engaged_enemies = 0
export (int) var maximum_engaged_enemies = 3
onready var combat_stats : CombatStats = $TowerCombatStats
onready var attack_range_shape : CircleShape2D = $PhysicCharacterBody/AttackRange/CollisionShape2D.shape
onready var stats_upgrade_container : Container = $StatsUpgradeHUD/Container

func _ready():
	$PhysicCharacterBody/CharacterCollectionArea.controller = self
	$PhysicCharacterBody/DetectionArea.controller = self
	$PhysicCharacterBody/SpriteHealthBar.combat_stats = combat_stats
	update_stats()
	combat_stats.can_attack = false
	$PhysicCharacterBody/AnimatedSprite.play("inactive")
	
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

func drop(spot):
	$PhysicCharacterBody/AnimationPlayer.play("Squish")
	global_position = spot.global_position
	spot.occupy_spot(self)
	positioned_spot = spot
	if spot.active:
		state = STATE.DEFAULT
		$PhysicCharacterBody/AnimatedSprite.play("default")
		combat_stats.can_attack = true
		$PhysicCharacterBody/PhysicBodyShape.set_deferred("disabled",false)
		$PhysicCharacterBody/DetectionArea/CollisionShape2D.set_deferred("disabled",false)
	else:
		state = STATE.INACTIVE

func update_stats():
	attack_range_shape.radius = ATTACK_RANGE_MULTI * combat_stats.attack_range


func _on_AttackRange_area_entered(area):
	if(area.controller.combat_stats):
		combat_stats.add_valid_target(area.controller.combat_stats)


func _on_AttackRange_area_exited(area):
	if(area.controller.combat_stats):
		combat_stats.remove_valid_target(area.controller.combat_stats)

func _process(delta):
	$PhysicCharacterBody/RichTextLabel.text = str(current_engaged_enemies)
	set_stats_ui()

func set_stats_ui():
	stats_upgrade_container.get_node("MaxHP/VSplit/Label").text = str(combat_stats.max_health)
	stats_upgrade_container.get_node("AttackDamage/VSplit/Label").text = str(combat_stats.attack_damage)
	stats_upgrade_container.get_node("AttackSpeed/VSplit/Label").text = str(combat_stats.attack_speed)
	stats_upgrade_container.get_node("AttackRange/VSplit/Label").text = str(combat_stats.attack_range)


func _on_TowerCombatStats_health_changed():
	$PhysicCharacterBody/AnimationPlayer.play("TakeDamage")


func _on_DetectionArea_mouse_entered():
	stats_upgrade_container.show()
