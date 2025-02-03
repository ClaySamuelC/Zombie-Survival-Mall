extends Node

@export var bullet_cost: int = 75
@export var bullet_cost_jump : int = 75
@export var hk_cost : int = 75
@export var hk_cost_jump : int = 75

@export var speed_upgrade : float = 1.5

func upgrade():
	if len(GameManager.selected_units) < 1:
		print("No unit selected.")
		return
	
	var selected_unit = GameManager.selected_units[0]
	
	var hk_upgrade_cost = hk_cost + hk_cost_jump * selected_unit.speed_level
	var bullets_upgrade_cost = bullet_cost + bullet_cost_jump * selected_unit.speed_level
	
	if GameState.healing_kits < hk_upgrade_cost:
		print("Not enough healing kits: " + str(GameState.healing_kits) + "/" + str(hk_upgrade_cost))
		return
	
	if GameState.bullets < bullets_upgrade_cost:
		print("Not enough bullets: " + str(GameState.bullets) + "/" + str(bullets_upgrade_cost))
		return
	
	print("Upgrading survivor speed from " + str(selected_unit.SPEED) + " to " + str(selected_unit.SPEED + speed_upgrade))
	print("Survivor speed level: " + str(selected_unit.speed_level + 1))
	
	GameState.bullets -= bullets_upgrade_cost
	GameState.healing_kits -= hk_upgrade_cost
	selected_unit.speed_level += 1
	
	selected_unit.SPEED += speed_upgrade
