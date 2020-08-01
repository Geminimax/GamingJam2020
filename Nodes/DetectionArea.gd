extends Area2D

var controller

func _ready():
    controller.current_engaged_enemies = 0
    controller.maximum_engaged_enemies = 100000
    controller.combat_stats = $CombatStats
