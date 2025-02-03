extends Node

@export var base_bullet_cost: int = 75
@export var bullet_cost_jump : int = 75
@export var base_hk_cost : int = 75
@export var hk_cost_jump : int = 75

@export var speed_upgrade : float = 1.5

func upgrade():
	if len(GameManager.selected_units) < 1:
		print("No unit selected.")
		return
	
	var selected_unit = GameManager.selected_units[0]
	
	var hk_cost = base_hk_cost + hk_cost_jump * selected_unit.speed_level
	var bullet_cost = base_bullet_cost + bullet_cost_jump * selected_unit.speed_level
	
	var success: bool = GameState.transact(bullet_cost, hk_cost, 0, 0)
	if !success:
		return
	
	print("Upgrading survivor speed from " + str(selected_unit.SPEED) + " to " + str(selected_unit.SPEED + speed_upgrade))
	print("Survivor speed level: " + str(selected_unit.speed_level + 1))
	
	selected_unit.speed_level += 1
	selected_unit.SPEED += speed_upgrade
