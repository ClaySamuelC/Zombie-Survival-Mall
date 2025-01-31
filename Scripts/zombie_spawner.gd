extends Node3D

var spawning = false
var zombie_spawn_time_in_seconds = 4

var zombie_spawn_time_floor = .6

var speed_up_spawns = false
var spawn_reduction_rate = .3
var spawn_check_rate = 4

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	spawn_skelly()
	handle_spawn_timer()
	pass

func spawn_skelly():
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
		zombie_spawn_time_in_seconds = zombie_spawn_time_in_seconds - spawn_reduction_rate
		print("zombie_spawn_time_in_seconds="+str(zombie_spawn_time_in_seconds))
		await get_tree().create_timer(spawn_check_rate).timeout
		speed_up_spawns = false
