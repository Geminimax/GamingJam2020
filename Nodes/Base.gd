extends Node2D

onready var combat_stats = $CombatStats
onready var current_engaged_enemies = 0
onready var maximum_engaged_enemies = 100000
var body = self

func _ready():
    $DetectionArea.controller = self
