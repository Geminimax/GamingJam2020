extends Node2D

func _ready():
	randomize()
	$EnemySpawner.setnav_2d($Level)
