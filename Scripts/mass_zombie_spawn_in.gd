extends Node3D

var spawning = false
@export var zombie_spawn_time_in_seconds = 4

@export var zombie_spawn_time_floor = .5

var speed_up_spawns = false
@export var spawn_reduction_percent = .9
@export var spawn_rate_update_duration = 15

var current_spawn_count = 0

var spawning_limit = 40

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	spawn_zombie()
	pass

func spawn_zombie():
	if current_spawn_count < spawning_limit:
		spawning = true
		var zombie = load("res://Scenes/zombie.tscn")
		var object = zombie.instantiate()
		self.get_parent_node_3d().add_child(object)
		object.set_global_position(self.global_position + Vector3(randi_range(0,20),self.global_position.y,randi_range(0,40)))
		
		current_spawn_count += 1
