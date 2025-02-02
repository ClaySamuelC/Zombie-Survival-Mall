extends CharacterBody3D

@export var SPEED = 5.0
@export var ACCELERATION = 15.0
@export var ROTATION_SPEED = 10.0
@export var OBSTACLE_DETECTION_RANGE = 1.8
@export var AVOIDANCE_FORCE = 2.0

@onready var animation_player = $AnimationPlayer
@onready var selected_indicator = $Selected_Indicator
@onready var gather_indicator = $Gather_Indicator

# Get the gravity from the project settings to be synced with RigidBody nodes
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

# Raycast configuration for obstacle detection
var ray_angles = [0, 30, 60, 90, 120, 150, 180, 210, 240, 270, 300, 330, 360]  # Angles for raycasts (in degrees)
var rays = []

var zombie_list
var current_target

var attack_range = 30
var current_damage = 100
var health = 100

var destination = Vector3(0, 0, 0)
var is_selected = false
var moving = false
var gather_tick_timer = 90
var gather_tick = 0 
var gather_mode = false
var in_gather_zone = false
var current_zone : CollisionShape3D


func _ready():
	add_to_group("survivor")
	create_ray_casts()

func _process(delta):
	if moving == true:
		move_unit_to_destination()
	pass

func move_unit(target):
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
	move_and_slide()
	
	# Handle floor detection and snapping
	if is_on_floor():
		# Reset vertical velocity when on floor
		velocity.y = 0
	
	# Optional: Jump if needed and on floor
	# if Input.is_action_just_pressed("jump") and is_on_floor():
	#     velocity.y = JUMP_VELOCITY

# Function to set new target
func set_target(target: Node3D):
	current_target = target

# Function to get distance to current target
func distance_to_target() -> float:
	if current_target:
		return global_position.distance_to(current_target.global_position)
	return 0.0

func distance_to_target_vector(vector: Vector3) -> float:
	return global_position.distance_to(vector)

# Optional: Function to check if character has roughly reached its target
func has_reached_target(threshold: float = 1.0) -> bool:
	return distance_to_target() < threshold

func create_ray_casts():
	for angle in ray_angles:
		var ray = RayCast3D.new()
		add_child(ray)
		ray.target_position = Vector3(0, 0, 1) * OBSTACLE_DETECTION_RANGE
		ray.position = Vector3(0, 1, 0)
		ray.rotate_y(deg_to_rad(angle))

func get_closest_target():
	zombie_list = get_tree().get_nodes_in_group("zombie")
	var closest_enemy
	var closest_distance = 10000
	
	for enemy in zombie_list:
		# Ensure the node is valid and not the current node itself
		var distance = self.global_transform.origin.distance_to(enemy.global_transform.origin)
		if distance < closest_distance:
			closest_distance = distance
			closest_enemy = enemy
	return closest_enemy

func move_unit_to_destination():
	var delta = get_physics_process_delta_time()
	if distance_to_target_vector(destination) > 1.4:
		moving = true
	else:
		moving = false
	if moving:
		var new_transform = transform.looking_at(destination, Vector3.UP)
		transform = transform.interpolate_with(new_transform, SPEED * delta)
		# Apply gravity
		if not is_on_floor():
			velocity.y -= gravity * delta
		
		# Calculate base direction to target
		var target_direction = (destination - global_position)
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
		#if velocity.length_squared() > 0.1:
			#var target_rotation = atan2(-velocity.x, -velocity.z)
			#rotation.y = lerp_angle(rotation.y, target_rotation, ROTATION_SPEED * delta)
		
		# Apply movement
		move_and_slide()
		
		# Handle floor detection and snapping
		if is_on_floor():
			# Reset vertical velocity when on floor
			velocity.y = 0
		
		# Optional: Jump if needed and on floor
		# if Input.is_action_just_pressed("jump") and is_on_floor():

func take_damage(damage):
	health -= damage
	if health<= 0:
		queue_free()

func go_to_gather_state():
	var state = $Survivor_Machine.current_state
	state.transitioned.emit(state,"Survivor_Gather_state")
	state = $Survivor_Machine.current_state
	pass
