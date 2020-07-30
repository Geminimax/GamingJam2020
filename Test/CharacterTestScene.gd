extends Node2D

func _ready():
    randomize()
    $EnemySpawner1.setnav_2d($Level)
    $EnemySpawner2.setnav_2d($Level)
