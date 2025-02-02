extends Node3D

# Parameters for Camera Control
@export_range(0, 1000) var movement_speed: float = 64
@export_range(0, 1000) var rotation_speed: float = 5
@export_range(0, 1000, 0.1) var zoom_speed: float = 50
@export_range(0, 1000) var min_zoom: float = 32
@export_range(0, 1000) var max_zoom: float = 256
@export_range(0, 90) var min_elevation_angle: float = 10
@export_range(0, 90) var max_elevation_angle: float = 90
@export var edge_margin: float = 50
@export var allow_rotation: bool = true
@export var allow_zoom: bool = true
@export var allow_pan: bool = true

# Camera Nodes
@onready var camera = $Elevation/MainCamera
@onready var elevation_node = $Elevation

# Runtime State
var is_rotating: bool = false
var is_panning: bool = false
var last_mouse_position: Vector2
var zoom_level: float = 1

func _ready() -> void:
	# Initialize zoom level
	zoom_level = camera.position.z

func _process(delta: float) -> void:
	if not is_panning:
		handle_keyboard_movement(delta)
		if allow_rotation:
			handle_rotation(delta)
		if allow_zoom:
			handle_zoom(delta)
	else:
		if allow_pan:
			handle_panning(delta)

# handling inputs
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("camera_rotate"):
		is_rotating = true
		last_mouse_position = get_viewport().get_mouse_position()
	elif event.is_action_released("camera_rotate"):
		is_rotating = false

	if event.is_action_pressed("camera_pan"):
		is_panning = true
		last_mouse_position = get_viewport().get_mouse_position()
	elif event.is_action_released("camera_pan"):
		is_panning = false

	if event.is_action_pressed("zoom_in"):
		zoom_level -= zoom_speed
	elif event.is_action_pressed("zoom_out"):
		zoom_level += zoom_speed

# Movement
func handle_keyboard_movement(delta: float) -> void:
	var direction = Vector3.ZERO
	if Input.is_action_pressed("camera_up"):
		direction.z -= 1
	if Input.is_action_pressed("camera_down"):
		direction.z += 1
	if Input.is_action_pressed("camera_left"):
		direction.x -= 1
	if Input.is_action_pressed("camera_right"):
		direction.x += 1

	if direction != Vector3.ZERO:
		direction = direction.normalized()
		translate_object_local(direction * movement_speed * delta)

# Rotation
func handle_rotation(delta: float) -> void:
	if is_rotating:
		var mouse_displacement = get_viewport().get_mouse_position() - last_mouse_position
		last_mouse_position = get_viewport().get_mouse_position()

		# Horizontal rotation
		rotation.y -= deg_to_rad(mouse_displacement.x * rotation_speed * delta)

		# Elevation
		var elevation_angle = rad_to_deg(elevation_node.rotation.x)
		elevation_angle = clamp(
			elevation_angle - mouse_displacement.y * rotation_speed * delta,
			-max_elevation_angle,
			-min_elevation_angle
		)
		elevation_node.rotation.x = deg_to_rad(elevation_angle)

# Zoom
func handle_zoom(delta: float) -> void:
	zoom_level = clamp(zoom_level, min_zoom, max_zoom)
	camera.position.z = lerp(camera.position.z, zoom_level, 0.1)

# Panning
func handle_panning(delta: float) -> void:
	if is_panning:
		var current_mouse_pos = get_viewport().get_mouse_position()
		var displacement = current_mouse_pos - last_mouse_position
		last_mouse_position = current_mouse_pos

		translate_object_local(Vector3(-displacement.x, 0, -displacement.y) * 0.1)
