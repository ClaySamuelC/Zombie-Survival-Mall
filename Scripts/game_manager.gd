extends Node3D

@onready var gather_cursor = load("res://Assets/cursors/pickaxe.png")
@onready var default_cursor = load("res://Assets/cursors/default_cursor.png")

@onready var camera =  get_node("/root/Main/RTSController/Elevation/MainCamera")
@onready var selection_box = get_node("/root/Main/CanvasLayer/Control/SelectionBox")
@onready var soldier_control = get_node("/root/Main/GUI/GUI_Control/Soldier_Control")
@onready var gui = get_node("/root/Main/GUI/")

var dragging = false
var drag_start = Vector2()
var drag_end = Vector2()

var all_modes = {
	"debris_mode" = false,
	"gather_mode" = false,
	"molotov_mode" = false
}

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("gather_mode"):
		# This is cleared in handle_right_click
		if len(GameState.selected_units) > 0:
			Input.set_custom_mouse_cursor(gather_cursor)
		
		all_modes["gather_mode"] = true
		Input.set_custom_mouse_cursor(gather_cursor)
		turn_off_other_modes("gather_mode")

	if event.is_action_pressed("debris_mode"):
		# This is cleared in handle_right_click
		all_modes["debris_mode"] = true
		turn_off_other_modes("debris_mode")
	
	if event.is_action_pressed("molotov_mode"):
		# This is cleared in handle_right_click
		all_modes["molotov_mode"] = true
		turn_off_other_modes("molotov_mode")
	
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.is_pressed():
				var mouse_pos = get_viewport().get_mouse_position()
				if soldier_control.get_global_rect().has_point(mouse_pos):
					print("skipping click in control")
					return
				
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
			
			if event.is_released():
				if all_modes["debris_mode"] == true:
					place_debris()
				elif all_modes["molotov_mode"] == true:
					place_molotov()
				else:
					pass
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
					GameState.append_selected_units(survivor)
					survivor.is_selected = true
					survivor.selected_indicator.visible = true

func select_unit(unit: Node3D):
	deselect_all()
	GameState.append_selected_units(unit)
	unit.is_selected = true

func deselect_all():
	for unit in GameState.selected_units:
		if unit and is_instance_valid(unit):
			unit.is_selected = false
			unit.selected_indicator.visible = false
	GameState.set_selected_units([])
	
	Input.set_custom_mouse_cursor(default_cursor)

func handle_right_click() -> void:
	all_modes["debris_mode"] = false
	all_modes["molotov_mode"] = false
	
	if GameState.selected_units.is_empty():
		return
	
	var mouse_pos = get_viewport().get_mouse_position()
	var from = camera.project_ray_origin(mouse_pos)
	var to = from + camera.project_ray_normal(mouse_pos) * 1000
	var query = PhysicsRayQueryParameters3D.create(from, to)
	var result = get_parent().get_world_3d().direct_space_state.intersect_ray(query)
	
	if result:
		var target_pos = result.position
		for unit in GameState.selected_units:
			if unit and is_instance_valid(unit):
				unit.destination = target_pos
				unit.move_unit_to_destination()
				if all_modes["gather_mode"] == true:
					unit.gather_mode = true
					unit.go_to_gather_state()
					# Get it's state and trasmit it'self to gather mode
				else:
					unit.gather_mode = false
	all_modes["gather_mode"] = false
	Input.set_custom_mouse_cursor(default_cursor)

func place_debris():
	if GameState.debris >= 1:
		var mouse_pos = get_viewport().get_mouse_position()
		var from = camera.project_ray_origin(mouse_pos)
		var to = from + camera.project_ray_normal(mouse_pos) * 1000
		var query = PhysicsRayQueryParameters3D.create(from, to)
		var result = get_parent().get_world_3d().direct_space_state.intersect_ray(query)
		
		#Stops debris from stacking/being built on walls
		if result.position.y < .5 && result.get("collider") && !result.get("collider").is_in_group("debris"):
			var location = result.position
			var pre_load = load("res://Scenes/debris.tscn")
			var debris = pre_load.instantiate()
			add_child(debris)
			debris.set_global_position(location + Vector3(0,1,0))
			GameState.debris -= 1
	else:
		print("out of debris")

func place_molotov():
	if GameState.molotov >= 1:
		var mouse_pos = get_viewport().get_mouse_position()
		var from = camera.project_ray_origin(mouse_pos)
		var to = from + camera.project_ray_normal(mouse_pos) * 1000
		var query = PhysicsRayQueryParameters3D.create(from, to)
		var result = get_parent().get_world_3d().direct_space_state.intersect_ray(query)
		
		if result:
			var location = result.position
			var pre_load = load("res://Scenes/molotov_aoe.tscn")
			var molotov = pre_load.instantiate()
			add_child(molotov)
			molotov.set_global_position(location + Vector3(0,1,0))
			GameState.molotov -= 1
			gui.flash_minus("molotov", 1)
			all_modes["molotov_mode"] = false
	else:
		print("out of molotov")

func turn_off_other_modes(mode_to_keep_on : String):
	for mode in all_modes:
		if !mode_to_keep_on == mode:
			all_modes[mode] = false
	pass
