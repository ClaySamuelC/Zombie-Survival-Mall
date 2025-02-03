extends Node

@export var base_hk_cost: int = 75
@export var hk_cost_jump: int = 75
@export var health_upgrade: int = 50

func upgrade():
	if len(GameManager.selected_units) < 1:
		print("No unit selected.")
		return
	
	var selected_unit = GameManager.selected_units[0]
	
	var hk_cost = base_hk_cost + hk_cost_jump * selected_unit.toughness_level
	
	var success: bool = GameState.transact(0, hk_cost, 0, 0)
	if !success:
		return
	
	print("Upgrading survivor health from " + str(selected_unit.MAX_HEALTH) + " to " + str(selected_unit.MAX_HEALTH + health_upgrade))
	
	selected_unit.toughness_level += 1
	
	selected_unit.MAX_HEALTH += health_upgrade
	selected_unit.health += health_upgrade
