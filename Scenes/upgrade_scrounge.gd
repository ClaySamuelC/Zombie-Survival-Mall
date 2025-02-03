extends Node

@export var base_bullet_cost: int = 75
@export var bullet_cost_jump : int = 75
@export var base_hk_cost : int = 75
@export var hk_cost_jump : int = 75
@export var base_debris_cost : int = 75
@export var debris_cost_jump : int = 75

@export var scrounge_upgrade : int = 1

func upgrade():
	if len(GameManager.selected_units) < 1:
		print("No unit selected.")
		return
	
	var selected_unit = GameManager.selected_units[0]
	
	var hk_cost = base_hk_cost + hk_cost_jump * selected_unit.scrounge_level
	var bullet_cost = base_bullet_cost + bullet_cost_jump * selected_unit.scrounge_level
	var debris_cost = base_debris_cost + debris_cost_jump * selected_unit.scrounge_level
	
	var success: bool = GameState.transact(bullet_cost, hk_cost, debris_cost, 0)
	if !success:
		return
	
	print("Upgrading survivor scrounge speed from " + str(selected_unit.scrounge_level) + "/sec to " + str(selected_unit.scrounge_level + scrounge_upgrade) + "/sec")
	
	selected_unit.scrounge_level += 1
	
	selected_unit.scrounge_speed += scrounge_upgrade
