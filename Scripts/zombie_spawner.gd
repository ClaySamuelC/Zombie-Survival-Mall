extends Node3D

var spawning = false
@export var zombie_spawn_time_in_seconds = 2.4

@export var zombie_spawn_time_floor = .7

var speed_up_spawns = false
@export var spawn_reduction_percent = .9
@export var spawn_rate_update_duration = 10

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	spawn_zombie()
	handle_spawn_timer()
	pass

func spawn_zombie():
	if !spawning:
		spawning = true
		var zombie = load("res://Scenes/zombie.tscn")
		var object = zombie.instantiate()
		self.get_parent_node_3d().add_child(object)
		object.set_global_position(self.global_position)
		
		await get_tree().create_timer(zombie_spawn_time_in_seconds).timeout
		
		spawning = false

func handle_spawn_timer():
	if !speed_up_spawns && zombie_spawn_time_in_seconds >= zombie_spawn_time_floor:
		speed_up_spawns = true
		zombie_spawn_time_in_seconds = zombie_spawn_time_in_seconds * spawn_reduction_percent
		
		await get_tree().create_timer(spawn_rate_update_duration).timeout
		
		speed_up_spawns = false
