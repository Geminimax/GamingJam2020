extends "res://Nodes/Character/BaseCharacterController.gd"
enum STATE{INACTIVE,DEFAULT, PICKUP}
const ATTACK_RANGE_MULTI = 50
var state = STATE.INACTIVE
var positioned_spot = null
onready var combat_stats : CombatStats = $TowerCombatStats
onready var attack_range_shape : CircleShape2D = $PhysicCharacterBody/AttackRange/CollisionShape2D.shape

func _ready():
    $PhysicCharacterBody/CharacterCollectionArea.controller = self
    $PhysicCharacterBody/SpriteHealthBar.combat_stats = combat_stats
    update_stats()
    
func pickup_range_entered():
    $PhysicCharacterBody/Selector.visible = true

func pickup_range_exited():
    $PhysicCharacterBody/Selector.visible = false

func pickup():
    if(positioned_spot):
        positioned_spot.empty_spot()
        positioned_spot = null
    state = STATE.PICKUP
    $PhysicCharacterBody/PhysicBodyShape.set_deferred("disabled",true)

func drop(spot):
    $PhysicCharacterBody/AnimationPlayer.play("Squish")
    global_position = spot.global_position
    spot.occupy_spot()
    positioned_spot = spot
    state = STATE.DEFAULT

func update_stats():
    attack_range_shape.radius = ATTACK_RANGE_MULTI * combat_stats.attack_range


func _on_AttackRange_area_entered(area):
    print("Enemy range entered")
    if(area.controller.combat_stats):
        combat_stats.add_valid_target(area.controller.combat_stats)


func _on_AttackRange_area_exited(area):
    if(area.controller.combat_stats):
        combat_stats.remove_valid_target(area.controller.combat_stats)
