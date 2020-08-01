extends Node2D

onready var combat_stats = $CombatStats
onready var current_engaged_enemies = 0
onready var maximum_engaged_enemies = 100000
var body = self

func _ready():
    $DetectionArea.controller = self

func _process(delta):
    $Furnace/SpriteHealthBar.update_health_bar_value($CombatStats.health, $CombatStats.max_health)
