extends "res://Nodes/Character/Enemy/GenericEnemy.gd"

func _ready():
    $Area2D/CollisionShape2D.shape.radius = $CombatStats.attack_range
