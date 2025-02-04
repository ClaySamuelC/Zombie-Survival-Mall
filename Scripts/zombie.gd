extends CharacterBody3D

@export var SPEED = 5.0
@export var ACCELERATION = 15.0
@export var JUMP_VELOCITY = 4.5
@export var ROTATION_SPEED = 10.0
@export var OBSTACLE_DETECTION_RANGE = 3
@export var AVOIDANCE_FORCE = 3.0

# Get the gravity from the project settings to be synced with RigidBody nodes
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

# Raycast configuration for obstacle detection
var ray_angles = [0, 30, 60, 90, 120, 150, 180, 210, 240, 270, 300, 330]  # Angles for raycasts (in degrees)
var attack_ray_angles = [180, 210, 150]  # Angles for raycasts (in degrees)
var rays = []
var attack_rays = []
var survivor_list

var current_target
var health = 100
var attack_range = 3
var current_damage = 30

var destination = Vector3(0, 0, 0)

@onready var animation_player = $AnimationPlayer


func _ready():
	add_to_group("zombie")
	create_ray_casts()

func move_unit(target):
	if !check_for_debris():
		current_target = target
		var delta = get_physics_process_delta_time()
		# Apply gravity
		if not is_on_floor():
			velocity.y -= gravity * delta
		
		# Calculate base direction to target
		var target_direction = (current_target.global_position - global_position)
		target_direction.y = 0  # Keep movement on the horizontal plane
		target_direction = target_direction.normalized()
		
		# Calculate avoidance direction
		var avoidance = Vector3.ZERO
		var num_collisions = 0
		
		# Check all raycasts for obstacles
		for ray in rays:
			if ray.is_colliding():
				var collision_point = ray.get_collision_point()
				var collision_normal = ray.get_collision_normal()
				var distance = global_position.distance_to(collision_point)
				
				# Calculate avoidance vector (stronger when closer to obstacle)
				var avoidance_vector = collision_normal * (1.0 - distance / OBSTACLE_DETECTION_RANGE)
				avoidance += avoidance_vector
				num_collisions += 1
		
		# Average the avoidance vector if there were collisions
		if num_collisions > 0:
			avoidance = (avoidance / num_collisions) * AVOIDANCE_FORCE
		
		# Combine target direction with avoidance
		var final_direction = (target_direction + avoidance).normalized()
		
		# Apply horizontal movement with acceleration
		var target_velocity = final_direction * SPEED
		velocity.x = move_toward(velocity.x, target_velocity.x, ACCELERATION * delta)
		velocity.z = move_toward(velocity.z, target_velocity.z, ACCELERATION * delta)
		
		# Rotate character to face movement direction
		if velocity.length_squared() > 0.1:
			var target_rotation = atan2(-velocity.x, -velocity.z)
			rotation.y = lerp_angle(rotation.y, target_rotation, ROTATION_SPEED * delta)
		
		# Apply movement
		#TODO Do something about when they are surrounded they flip around in every direction
		move_and_slide()
		
		# Handle floor detection and snapping
		if is_on_floor():
			# Reset vertical velocity when on floor
			velocity.y = 0

# Function to set new target
func set_target(target: Node3D):
	current_target = target

# Function to get distance to current target
func distance_to_target() -> float:
	if current_target:
		return global_position.distance_to(current_target.global_position)
	return 0.0

# Optional: Function to check if character has roughly reached its target
func has_reached_target(threshold: float = 1.0) -> bool:
	return distance_to_target() < threshold

func get_closest_target():
	survivor_list = get_tree().get_nodes_in_group("survivor")
	var closest_enemy
	var closest_distance = 10000
	
	for enemy in survivor_list:
		var distance = self.global_transform.origin.distance_to(enemy.global_transform.origin)
		if distance < closest_distance:
			closest_distance = distance
			closest_enemy = enemy
	return closest_enemy

func create_ray_casts():
	for angle in ray_angles:
		var ray = RayCast3D.new()
		add_child(ray)
		ray.target_position = Vector3(0, 0, 1) * OBSTACLE_DETECTION_RANGE
		ray.position = Vector3(0, 1, 0)
		ray.rotate_y(deg_to_rad(angle))
		rays.append(ray)
	for angle in attack_ray_angles:
		var ray = RayCast3D.new()
		add_child(ray)
		ray.target_position = Vector3(0, 0, 1) * (OBSTACLE_DETECTION_RANGE - 1) 
		ray.position = Vector3(0, 1.5, 0)
		ray.rotate_y(deg_to_rad(angle))
		attack_rays.append(ray)


func take_damage(damage):
	health = health - damage
	if health <= 0:
		GameState.zombie_kills += 1
		queue_free()

func check_for_debris():
	var debris_in_way = false
	for ray in attack_rays:
		if ray.is_colliding() and is_instance_valid(ray.get_collider()):
			if ray.get_collider().is_in_group("debris"):
				debris_in_way = true
				ray.get_collider().take_damage(current_damage)
	return debris_in_way
	
