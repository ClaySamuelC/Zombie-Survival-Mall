extends Node

@onready var camera = $"../RTSController/Elevation/MainCamera"
var selected_unit: Node3D = null

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("mouse_click"):
		handle_left_click(event)
	elif event.is_action_pressed("right_click"):
		handle_right_click(event)

func handle_left_click(event: InputEventMouseButton) -> void:
	var mouse_pos = get_viewport().get_mouse_position()
	var ray_length = 1000
	
	var from = camera.project_ray_origin(mouse_pos)
	var to = from + camera.project_ray_normal(mouse_pos) * ray_length
	
	var space_state = get_parent().get_world_3d().direct_space_state
	var query = PhysicsRayQueryParameters3D.create(from, to)
	
	var result = space_state.intersect_ray(query)
	
	if result:
		if result.collider and result.collider.has_method("selected"):
			select_unit(result.collider)
		else:
			# If we click anywhere that's not a regiment, deselect current regiment
			deselect_unit()
	else:
		deselect_unit()

func handle_right_click(event: InputEventMouseButton) -> void:
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
		move_selected_regiment(result.position)

func select_unit(unit: Node3D) -> void:
	if selected_unit == unit:
		return  # Don't reselect if it's already selected
		
	if select_unit:
		selected_unit.is_selected = false
	
	selected_unit = unit
	selected_unit.is_selected = true
	print("Selected Unit: ", selected_unit)

func move_selected_regiment(target_position: Vector3) -> void:
	if not selected_unit:
		return
		
	# Calculate direction to target (ignoring Y axis for rotation)
	var direction = target_position - selected_unit.global_position
	direction.y = 0  # Ignore height difference for rotation
	
	# Store both target position and rotation
	selected_unit.target_position = target_position
	selected_unit.target_rotation = direction.normalized()
	selected_unit.start_movement()  # New method to handle movement phases

func deselect_unit() -> void:
	if selected_unit:
		selected_unit.is_selected = false
		selected_unit = null
