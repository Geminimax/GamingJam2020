extends CombatStats
class_name TowerCombatStats
const MAX_LEVEL = 5

var level = 1

signal max_level_achieved

export (int) var level_up_price_base = 5
export (float) var level_up_price_increment = 1
export (float) var level_up_price_multi = 0.1
export (int) var max_health_increment
export (float) var attack_range_increment
export (float) var attack_speed_increment
export (float) var attack_damage_increment
export (bool) var knockback = false

func _ready():
    connect("max_level_achieved", get_parent(), "max_level_handle")

func get_level_up_price() -> int:
    return int(level_up_price_base + (level_up_price_increment * (level - 1))) * (1 + level_up_price_multi * (level - 1))

func level_up():
    if(level >= MAX_LEVEL):
        emit_signal("max_level_achieved")
        return false
    else:
        level += 1
        if level >= MAX_LEVEL:
            emit_signal("max_level_achieved")
        attack_range += attack_range_increment
        attack_speed += attack_speed_increment
        
        var health_percent = health/max_health
        max_health += max_health_increment
        health = health_percent * max_health
        attack_damage += attack_damage_increment
        return true
        
func attack():
    var prev_anim = controller.sprite.animation
    
    controller.sprite.play("attack")
    additional_anim()
    yield(controller.sprite,"animation_finished")
    for i in min(valid_targets.size(),max_targets):
        if knockback:
            valid_targets[i].knock_back(controller.body.global_position)
        deal_damage(valid_targets[i])
    controller.sprite.play(prev_anim)
    $Damage.play()

func additional_anim():
    pass
