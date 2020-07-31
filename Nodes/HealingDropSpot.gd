extends "res://Nodes/DropSpot.gd"
export (float) var recover_amount_per_tick = 20
func occupy_spot(tower):
	.occupy_spot(tower)
	$HealingTimer.start()

func empty_spot():
	.empty_spot()
	$HealingTimer.stop()


func _on_HealingTimer_timeout():
	if occupying:
		var stats  = occupying.combat_stats
		var amount = recover_amount_per_tick/100.0
		print(amount)
		print(amount * float(stats.max_health))
		print("Healing")
		stats.heal_health(amount * float(stats.max_health))
