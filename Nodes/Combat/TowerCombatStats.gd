extends CombatStats

const MAX_LEVEL = 5

var level = 1
export (int) var level_up_price_base = 5
export (int) var level_up_price_increment = 1
export (int) var level_up_price_multi = 0.1
export (int) var max_health_increment
export (float) var attack_range_increment
export (float) var attack_speed_increment
export (float) var attack_damage_increment

func get_level_up_price():
    return (level_up_price_base + (level_up_price_increment * (level - 1))) * (1 + level_up_price_multi * (level - 1))

func level_up():
    if(level >= MAX_LEVEL):
        return false
    else:
        level += 1
        attack_range += attack_range_increment
        attack_speed += attack_speed_increment
        
        var health_percent = health/max_health
        max_health += max_health_increment
        health = health_percent * max_health
        attack_damage += attack_damage_increment
        return true
