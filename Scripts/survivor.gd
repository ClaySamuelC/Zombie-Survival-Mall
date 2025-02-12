extends CharacterBody3D

@export var SPEED = 5.0
@export var ACCELERATION = 15.0
@export var ROTATION_SPEED = 10.0
@export var OBSTACLE_DETECTION_RANGE = 1.8
@export var AVOIDANCE_FORCE = 2.0

@onready var animation_player = $Low_Poly_Survivor_Empyt_Hands_Rifle/AnimationPlayer
@onready var selected_indicator = $Selected_Indicator
@onready var gather_indicator = $Gather_Indicator
@onready var gui = get_node("/root/Main/GUI/")
@onready var nav: NavigationAgent3D = $NavigationAgent3D


signal soldier_died

# Get the gravity from the project settings to be synced with RigidBody nodes
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

var zombie_list
var current_target

@export var attack_range = 20
@export var current_damage = 100
@export var health = 100
@export var MAX_HEALTH = 100

var destination = Vector3(0, 0, 0)
var is_selected = false
var moving = false
var gather_tick_timer = 90
var gather_tick = 0 
var gather_mode = false
var in_gather_zone = false
var current_zone : CollisionShape3D

var scrounge_speed : int = 1

var toughness_level : int = 0
var damage_level : int = 0
var speed_level : int = 0
var scrounge_level : int = 0
var weight = 0.1

func _ready():
	add_to_group("survivor")
	$"..".num_soldiers += 1
	soldier_died.connect($"..".decrement_soldiers)


func _process(delta):
	heal()
	if moving == true:
		animation_player.play("Walk_Forward")
		move_unit_to_destination()
	else:
		animation_player.play("Idle")
	pass

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
	if distance_to_target_vector(destination) > 1.5:
		moving = true
	else:
		moving = false
	if moving:
		if is_instance_valid(current_target):
			var new_transform = transform.looking_at(current_target.global_position, Vector3.UP)
			transform = transform.interpolate_with(new_transform, SPEED * get_process_delta_time())
		
		var direction
		
		nav.target_position = destination
		
		direction = nav.get_next_path_position() - global_position
		
		direction = direction.normalized()
		
		velocity = velocity.lerp(direction * SPEED, ACCELERATION * get_process_delta_time())
		
		# Apply movement
		move_and_slide()
		
		# Handle floor detection and snapping
		if is_on_floor():
			# Reset vertical velocity when on floor
			velocity.y = 0
		

func take_damage(damage):
	health -= damage
	if health <= 0:
		soldier_died.emit()
		queue_free()

func go_to_gather_state():
	var state = $Survivor_Machine.current_state
	state.transitioned.emit(state,"Survivor_Gather_state")
	state = $Survivor_Machine.current_state
	pass

func heal():
	if health < MAX_HEALTH:
		if GameState.healing_kits > 0:
			health = MAX_HEALTH
			GameState.healing_kits -= 1
			gui.flash_minus("heal_kit",1)
