extends Node3D

@onready var camera =  get_node("/root/Main/RTSController/Elevation/MainCamera")
@onready var selection_box = get_node("/root/Main/CanvasLayer/Control/SelectionBox")

var selected_units: Array[Node3D] = []
var dragging = false
var drag_start = Vector2()
var drag_end = Vector2()

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.is_pressed():
				selection_box.size = Vector2(0,0)
				# Start dragging
				dragging = true
				drag_start = event.position
				drag_end = event.position
				selection_box.show()
			else:
				# End dragging
				dragging = false
				selection_box.hide()
				handle_box_selection(drag_start, drag_end)
	elif event is InputEventMouseMotion and dragging:
		drag_end = event.position
		update_selection_box()
	
	if event.is_action_pressed("right_click"):
		handle_right_click()

func update_selection_box():
	var start = drag_start
	var end = drag_end
	var top_left = Vector2(min(start.x, end.x), min(start.y, end.y))
	var bottom_right = Vector2(max(start.x, end.x), max(start.y, end.y))
	
	selection_box.position = top_left
	selection_box.size = bottom_right - top_left

func handle_box_selection(start: Vector2, end: Vector2):
	var rect = Rect2()
	rect.position.x = min(start.x, end.x)
	rect.position.y = min(start.y, end.y)
	rect.size.x = abs(end.x - start.x)
	rect.size.y = abs(end.y - start.y)
	
	# Check if it's a single click (small area)
	if rect.size.x < 1 and rect.size.y < 1:
		# Raycast for single unit selection
		var from = camera.project_ray_origin(start)
		var to = from + camera.project_ray_normal(start) * 1000
		var query = PhysicsRayQueryParameters3D.create(from, to)
		var result = get_parent().get_world_3d().direct_space_state.intersect_ray(query)
		if result and result.collider.is_in_group("survivor"):
			select_unit(result.collider)
		else:
			deselect_all()
	else:
		# Box selection for multiple units
		var survivors = get_tree().get_nodes_in_group("survivor")
		deselect_all()
		for survivor in survivors:
			# Check if the unit is within the camera's view frustum
			if camera.is_position_in_frustum(survivor.global_position):
				var screen_pos = camera.unproject_position(survivor.global_position)
				if rect.has_point(screen_pos):
					selected_units.append(survivor)
					survivor.is_selected = true

func select_unit(unit: Node3D):
	deselect_all()
	selected_units.append(unit)
	unit.is_selected = true

func deselect_all():
	for unit in selected_units:
		unit.is_selected = false
	selected_units.clear()

func handle_right_click() -> void:
	if selected_units.is_empty():
		return
	
	var mouse_pos = get_viewport().get_mouse_position()
	var from = camera.project_ray_origin(mouse_pos)
	var to = from + camera.project_ray_normal(mouse_pos) * 1000
	var query = PhysicsRayQueryParameters3D.create(from, to)
	var result = get_parent().get_world_3d().direct_space_state.intersect_ray(query)
	
	if result:
		var target_pos = result.position
		for unit in selected_units:
			unit.destination = target_pos
			unit.move_unit_to_destination()
