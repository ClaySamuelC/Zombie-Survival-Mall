extends Node

@export var bullet_cost: int = 50
@export var bullet_cost_jump: int = 50
@export var damage_upgrade: int = 5

func upgrade():
	if len(GameManager.selected_units) < 1:
		print("No unit selected.")
		return
	
	var selected_unit = GameManager.selected_units[0]
	
	var upgrade_cost = bullet_cost + bullet_cost_jump * selected_unit.damage_level
	
	if GameState.bullets < upgrade_cost:
		print("Not enough bullets: " + str(GameState.bullets) + "/" + str(upgrade_cost))
		return
	
	print("Upgrading survivor damage from " + str(selected_unit.current_damage) + " to " + str(selected_unit.current_damage + damage_upgrade))
	
	GameState.bullets -= upgrade_cost
	selected_unit.damage_level += 1
	
	selected_unit.current_damage += 50
