extends State
class_name EnemyIdle

@export var movespeed := 40

@export var script_user : CharacterBody3D

var move_direction : Vector3
var wander_time : float

func randomize_wander():
	move_direction = Vector3(randf_range(-1,1),0,randf_range(-1,1)).normalized()
	wander_time = randf_range(1,5)
	$"../../AnimationPlayer".play("Idle")
	script_user.velocity = move_direction * script_user.movement_speed

func Enter():
	randomize_wander()
	
func Update(delta: float):
	if wander_time >0:
		wander_time-=delta
		
	else:
		randomize_wander()

func Physics_Update(Delta: float):
	pass

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
