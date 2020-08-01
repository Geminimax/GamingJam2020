extends Node
class_name CombatStats
signal death
signal health_changed
const BASE_ATTACK_TIME = 1.0
var controller
export (int) var max_health
export (int) var health
export (float) var speed
export (float) var attack_range
export (float) var attack_speed = 1.0
export (float) var attack_damage
var valid_targets : Array = []
export (int) var max_targets =1
var can_attack = true setget set_can_attack;

func deal_damage(target : CombatStats):
    target.take_damage(attack_damage)

func take_damage(damage_amount):
    var initial_health = health
    health -= damage_amount
    if health <= 0:
        emit_signal("death")
    health = clamp(health,0,max_health)
    if health != initial_health:
        emit_signal("health_changed")

func add_valid_target(target : CombatStats):
    #If target isn't present:  
    if(valid_targets.empty() && can_attack):
        $AttackTimer.start(BASE_ATTACK_TIME/attack_speed)
    if valid_targets.find(target) == -1:
        valid_targets.append(target)

func remove_valid_target(target: CombatStats):
    valid_targets.erase(target)

func has_valid_targets():
    return !valid_targets.empty()
func attack():
    deal_damage(valid_targets[0])
func heal_health(amount):
    var initial_health = health
    health += amount
    health = clamp(health,0,max_health)
    if health != initial_health:
        emit_signal("health_changed")

func _on_AttackTimer_timeout():
    if(!valid_targets.empty()):
        attack()
        if(can_attack):
            $AttackTimer.start(BASE_ATTACK_TIME/attack_speed)

func set_can_attack(value):
    can_attack = value
    if has_valid_targets():
        $AttackTimer.start(BASE_ATTACK_TIME/attack_speed)

func knock_back(source_dir):
    controller.knock_back(source_dir)
