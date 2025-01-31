extends FogVolume

@export var duration: float = 8.0  # Duration in seconds for the fog to dissipate
@export var size_range: Vector3 = Vector3(0.8, 2, 2)  # Min and max scale range for the fog
@export var vertical_speed_range: Vector2 = Vector2(0.01, 0.03)  # Range for vertical (upward) speed
@export var horizontal_speed_range: Vector2 = Vector2(0.02, 1)  # Range for horizontal (forward) speed

var size_mod: float = 0.0
var elapsed_time: float = 0.0  # Tracks how much time has passed
var initial_density: float = .8  # Store the initial fog density

func _ready() -> void:
	# Create a unique material instance for this fog object
	if material and material is FogMaterial:
		var unique_material = material.duplicate()
		material = unique_material  # Assign the unique material to this fog instance
		
		# Generate a random gray color between white and black
		var gray_value = randf_range(0.1, .5)
		var gray_color = Color(gray_value, gray_value, gray_value)
		
		initial_density = material.density
		material.set_emission(gray_color)  # Set the emission color
		material.set_albedo(gray_color)  # Set the albedo color
	else:
		push_error("FogVolume must have a FogMaterial assigned as its material_override!")
	
	# Randomize the fog's size
	var random_scale = Vector3(
		randf_range(size_range.x, size_range.y),
		randf_range(size_range.x, size_range.y),
		randf_range(size_range.x, size_range.y)
	)
	scale = random_scale

func _process(delta: float) -> void:
	if material and material is FogMaterial:
		size_mod = randf_range(0.001, 0.005)
		# Update elapsed time
		elapsed_time += delta
		size.x += size_mod
		size.y += size_mod
		size.z += size_mod
		
		# Move the fog forward and upward with some randomness
		var random_vertical_speed = randf_range(vertical_speed_range.x, vertical_speed_range.y)
		var random_forward_speed = randf_range(horizontal_speed_range.x, horizontal_speed_range.y)
		position += transform.basis.x * random_forward_speed * delta  # Forward movement
		position += transform.basis.y * random_vertical_speed * delta  # Upward movement
		
		# Gradually reduce the density over time using smoother interpolation
		if elapsed_time < duration:
			# Use an easing function for smoother density reduction
			var progress = elapsed_time / duration
			var eased_progress = progress * (2 - progress)  # Quadratic easing for smoother reduction
			material.density = lerp(initial_density, 0.0, eased_progress)
		else:
			# Remove the fog after it has fully dissipated
			queue_free()
