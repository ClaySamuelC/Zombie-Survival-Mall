extends StaticBody3D

@export var enemy_team: String
@export var friendly_team: String
@export var friendly_lines: String
@export var friendly_regiment: String
@export var color: Color
@export var move_speed: float = 5.0
@export var rotation_speed: float = 2.0
@export var rotation_threshold: float = 0.1

var target_position: Vector3 = Vector3.ZERO
var target_rotation: Vector3
var is_selected: bool = false
var is_turning: bool = false
var is_moving: bool = false

var soldiers: Array[CharacterBody3D]
var lines: Array
var ranks = 2

func _ready() -> void:
	add_to_group(friendly_regiment)
	lines = get_lines()
	for line in lines:
		line.add_to_group(friendly_lines)
		var children = line.get_children()
		for child in children:
			soldiers.append(child)
	
	for soldier in soldiers:
		soldier.add_to_group(friendly_team)
		soldier.set_enemy_team(enemy_team)
		set_soldier_color(soldier, color)

func _physics_process(delta: float) -> void:
	if is_turning:
		handle_turning(delta)
	elif is_moving:
		handle_moving(delta)

func start_movement() -> void:
	is_turning = true
	is_moving = false
	reconsolidate()  # Ensure formation is proper before moving

func handle_turning(delta: float) -> void:
   # Calculate center of formation safely
	var center = Vector3.ZERO
	var valid_soldiers = []
	
	# Get fresh list of soldiers and filter out null entries
	get_soldiers()
	for soldier in soldiers:
		if is_instance_valid(soldier):
			center += soldier.global_position
			valid_soldiers.append(soldier)
	
	# Safety check - if no valid soldiers, use current position as center
	if valid_soldiers.size() == 0:
		center = global_position
	else:
		center /= valid_soldiers.size()
	# Get current forward direction
	var current_direction = global_transform.basis.x
	current_direction.y = 0
	
	# Calculate angle to target
	var target_angle = atan2(target_rotation.x, target_rotation.z)
	var current_angle = atan2(current_direction.x, current_direction.z)
	
	# Rotate towards target
	var angle_diff = wrapf(target_angle - current_angle, -PI, PI)
	
	if abs(angle_diff) < rotation_threshold:
		# Finished turning, start moving
		is_turning = false
		is_moving = true
		return
	
	# Store original position relative to center
	var offset = global_position - center
	
	# Apply rotation around center
	rotate_y(sign(angle_diff) * rotation_speed * delta)
	
	# Adjust position to maintain center point
	global_position = center + offset.rotated(Vector3.UP, sign(angle_diff) * rotation_speed * delta)
	
	reconsolidate()

func handle_moving(delta: float) -> void:
	var direction = target_position - global_position
	direction.y = 0  # Keep unit at same height
	
	if direction.length() < 0.1:
		# Reached destination
		is_moving = false
		reconsolidate()  # Final formation adjustment
		return
		
	# Move towards target
	position += direction.normalized() * move_speed * delta
	reconsolidate()  # Update soldier positions during movement

# Helper function to set the color of a soldier
func set_soldier_color(soldier: Node, color: Color) -> void:
	var rig = soldier.get_node("Rig") if soldier.has_node("Rig") else null
	if rig and rig is MeshInstance3D:
		var material = rig.get_surface_override_material(0)
		if material == null:
			material = StandardMaterial3D.new()
			rig.set_surface_override_material(0, material)
		material.albedo_color = color

func regiment():
	pass

func get_lines():
	var new_lines = []
	lines = get_children()
	
	for line in lines:
		if line.is_in_group("line"):
			new_lines.append(line)
	return new_lines

func get_soldiers():
	get_lines()
	for line in lines:
		var children = line.get_children()
		for child in children:
			soldiers.append(child)
	return soldiers

func reconsolidate():
	var current_lines = get_lines()
	for line in current_lines:
		line.update_positions()
