extends Node3D

var SPEED = 40.0
var direction = Vector3.ZERO
var enemy_team 

@onready var mesh = $MeshInstance3D
@onready var ray = $RayCast3D

func _ready() -> void:
	# If direction is not set, default to forward
	if direction == Vector3.ZERO:
		direction = transform.basis.z.normalized()

func _physics_process(delta: float) -> void:
	# Move in the given direction
	position += direction * SPEED * delta

	# Check for collision
	if ray.is_colliding():
		var collider = ray.get_collider()
		if collider and collider.is_in_group(enemy_team):
			collider.die()
		
		queue_free()

func set_enemy_team(team:String):
	enemy_team = team
