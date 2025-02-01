extends Node

@onready var camera = $RTSController/Elevation/MainCamera
var selected_unit: Node3D = null

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("mouse_click"):
		handle_left_click()
	elif event.is_action_pressed("right_click"):
		handle_right_click()

func handle_left_click() -> void:
	if not camera:
		push_error("Camera is null!")
		return
	
	var mouse_pos = get_viewport().get_mouse_position()
	var ray_length = 1000
	
	var from = camera.project_ray_origin(mouse_pos)
	var to = from + camera.project_ray_normal(mouse_pos) * ray_length
	
	var space_state = get_parent().get_world_3d().direct_space_state
	var query = PhysicsRayQueryParameters3D.create(from, to)
	
	var result = space_state.intersect_ray(query)

	if result:
		if result.collider and result.collider.is_in_group("survivor"):
			select_unit(result.collider)
		else:
			deselect_unit()
	else:
		deselect_unit()

func handle_right_click() -> void:
	if not selected_unit:
		return
		
	var mouse_pos = get_viewport().get_mouse_position()
	var ray_length = 1000
	
	var from = camera.project_ray_origin(mouse_pos)
	var to = from + camera.project_ray_normal(mouse_pos) * ray_length
	
	var space_state = get_parent().get_world_3d().direct_space_state
	var query = PhysicsRayQueryParameters3D.create(from, to)
	
	var result = space_state.intersect_ray(query)
	if result:
		move_selected_unit(result.position)

func select_unit(unit: Node3D) -> void:
	if selected_unit == unit:
		return  # Avoid reselection
	
	# Corrected condition to check selected_unit
	if selected_unit:
		selected_unit.is_selected = false
	
	selected_unit = unit
	selected_unit.is_selected = true

func move_selected_unit(target_position: Vector3) -> void:
	print(target_position)
	if not selected_unit:
		return
		
	selected_unit.destination = target_position
	selected_unit.move_unit_to_destination()

func deselect_unit() -> void:
	if selected_unit:
		selected_unit.is_selected = false
		selected_unit = null
