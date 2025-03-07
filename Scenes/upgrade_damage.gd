extends Node

@export var base_bullet_cost: int = 50
@export var bullet_cost_jump: int = 50
@export var damage_upgrade: int = 5

func get_bullet_cost(level: int) -> int:
	return base_bullet_cost + bullet_cost_jump * level

func upgrade():
	if GameState.selected_units.is_empty():
		print("No unit selected.")
		return
	
	var selected_unit = GameState.selected_units[0]
	
	var bullet_cost = get_bullet_cost(selected_unit.damage_level)
	
	var success: bool = GameState.transact(bullet_cost, 0, 0, 0)
	if !success:
		return
	
	print("Upgrading survivor damage from " + str(selected_unit.current_damage) + " to " + str(selected_unit.current_damage + damage_upgrade))
	
	selected_unit.damage_level += 1
	selected_unit.current_damage += 50
