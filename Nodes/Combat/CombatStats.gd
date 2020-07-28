extends Node
class_name CombatStats
signal death

export (int) var max_health
export (int) var health
export (int) var attack_range
export (int) var attack_speed
export (int) var attack_damage

func deal_damage(target : CombatStats):
    target.take_damage(attack_damage)

func take_damage(damage_amount):
    health -= damage_amount
    if(health <= 0):
        emit_signal("death")
    health = clamp(0,health,max_health)
