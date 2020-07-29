extends Node
class_name CombatStats
signal death
const BASE_ATTACK_TIME = 1.0
export (int) var max_health
export (int) var health
export (float) var attack_range
export (float) var attack_speed = 1.0
export (float) var attack_damage
var valid_targets : Array = []

func deal_damage(target : CombatStats):
    target.take_damage(attack_damage)

func take_damage(damage_amount):
    health -= damage_amount
    if health <= 0:
        emit_signal("death")
    health = clamp(0,health,max_health)

func add_valid_target(target : CombatStats):
    #If target isn't present:  
    if(valid_targets.empty()):
        $AttackTimer.start(BASE_ATTACK_TIME/attack_speed)
    if valid_targets.find(target) == -1:
        valid_targets.append(target)

func remove_valid_target(target: CombatStats):
    valid_targets.erase(target)
      
func attack():
    deal_damage(valid_targets[0])


func _on_AttackTimer_timeout():
    if(!valid_targets.empty()):
        attack()
        $AttackTimer.start(BASE_ATTACK_TIME/attack_speed)
