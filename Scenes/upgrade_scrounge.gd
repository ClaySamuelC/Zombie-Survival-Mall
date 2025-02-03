extends Node

@export var bullet_cost: int = 75
@export var bullet_cost_jump : int = 75
@export var hk_cost : int = 75
@export var hk_cost_jump : int = 75
@export var debris_cost : int = 75
@export var debris_cost_jump : int = 75

@export var scrounge_upgrade : int = 1

func upgrade():
	if len(GameManager.selected_units) < 1:
		print("No unit selected.")
		return
	
	var selected_unit = GameManager.selected_units[0]
	
	var hk_upgrade_cost = hk_cost + hk_cost_jump * selected_unit.scrounge_level
	var bullets_upgrade_cost = bullet_cost + bullet_cost_jump * selected_unit.scrounge_level
	var debris_upgrade_cost = debris_cost + debris_cost_jump * selected_unit.scrounge_level
	
	if GameState.healing_kits < hk_upgrade_cost:
		print("Not enough healing kits: " + str(GameState.healing_kits) + "/" + str(hk_upgrade_cost))
		return
	
	if GameState.bullets < bullets_upgrade_cost:
		print("Not enough bullets: " + str(GameState.bullets) + "/" + str(bullets_upgrade_cost))
		return
	
	if GameState.debris < debris_upgrade_cost:
		print("Not enough bullets: " + str(GameState.debris) + "/" + str(debris_upgrade_cost))
		return
	
	print("Upgrading survivor scrounge from " + str(selected_unit.scrounge_level) + " to " + str(selected_unit.scrounge_level + scrounge_upgrade))
	
	GameState.bullets -= bullets_upgrade_cost
	GameState.healing_kits -= hk_upgrade_cost
	GameState.debris -= debris_upgrade_cost
	selected_unit.scrounge_level += 1
	
	selected_unit.scrounge_speed += scrounge_upgrade
