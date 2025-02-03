extends Node

@export var hk_cost: int = 75
@export var hk_cost_jump: int = 75
@export var health_upgrade: int = 50

func upgrade():
	if len(GameManager.selected_units) < 1:
		print("No unit selected.")
		return
	
	var selected_unit = GameManager.selected_units[0]
	
	var upgrade_cost = hk_cost + hk_cost_jump * selected_unit.toughness_level
	
	if GameState.healing_kits < upgrade_cost:
		print("Not enough healing kits: " + str(GameState.healing_kits) + "/" + str(upgrade_cost))
		return
	
	print("Upgrading survivor health from " + str(selected_unit.MAX_HEALTH) + " to " + str(selected_unit.MAX_HEALTH + health_upgrade))
	
	GameState.healing_kits -= upgrade_cost
	selected_unit.toughness_level += 1
	
	selected_unit.MAX_HEALTH += health_upgrade
	selected_unit.health += health_upgrade
