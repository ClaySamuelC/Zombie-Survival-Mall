extends Node

# Author: ClaySamuelC

var bullets: int = 10000
var debris: int = 10000
var healing_kits: int = 10000
var zombie_kills: int = 0
var molotov: int = 7
@onready var gui = get_node("/root/Main/GUI/")

var selected_units: Array[Node3D] = []

signal on_unit_selected(unit: Node3D)

func set_selected_units(units: Array[Node3D]) -> void:
	selected_units = units
	if selected_units.is_empty():
		on_unit_selected.emit(null)
	else:
		on_unit_selected.emit(selected_units[0])
	
func append_selected_units(unit: Node3D) -> void:
	selected_units.append(unit)
	on_unit_selected.emit(selected_units[0])

# returns true if transaction succeeds, false if it fails
func transact(bullet_cost: int = 0, hk_cost: int = 0, debris_cost: int = 0, molotov_cost: int = 0) -> bool: 
	var success: bool = true
	if bullets < bullet_cost:
		print("Not enough bullets: " + str(bullets) + "/" + str(bullet_cost))
		success = false
	if healing_kits < hk_cost:
		print("Not enough healing kits: " + str(healing_kits) + "/" + str(hk_cost))
		success = false
	if debris < debris_cost:
		print("Not enough debris: " + str(debris) + "/" + str(debris_cost))
		success = false
	if molotov < molotov_cost:
		print("Not enough molotovs: " + str(molotov) + "/" + str(molotov_cost))
		success = false
		
	if !success:
		return false
	
	print("Successful transaction!")
	if bullet_cost > 0:
		print("Spending " + str(bullet_cost) + " bullets")
		bullets -= bullet_cost
		gui.flash_minus("bullet",bullet_cost)
		
	if hk_cost > 0:
		print("Spending " + str(hk_cost) + " healing kits")
		healing_kits -= hk_cost
		gui.flash_minus("heal_kit",hk_cost)

	if debris_cost > 0:
		print("Spending " + str(debris_cost) + " debris")
		debris -= debris_cost
		gui.flash_minus("debris",debris_cost)
		
	if molotov_cost > 0:
		print("Spending " + str(molotov_cost) + " molotovs")
		molotov -= molotov_cost
		gui.flash_minus("molotov",molotov_cost)
	
	return true
