extends Node2D

var combat_stats : CombatStats setget set_combat_stats

func set_combat_stats(value):
	combat_stats = value
	combat_stats.connect("health_changed",self,"on_health_changed")
	on_health_changed()

func update_health_bar_value(current_value,max_value):
	pass

func on_health_changed():
	update_health_bar_value(combat_stats.health, combat_stats.max_health)
