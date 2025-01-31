extends State
class_name CavCharge
@export var walk_slow_speed := 10.0
@export var walk_speed := 15.0
@export var run_speed := 25.0

var horse_line: StaticBody3D
var riders
var target_position: Vector3
var initial_position: Vector3
var formation_width: float
var formation_depth: float

func Enter():
	horse_line = get_parent().get_horse_line()
	
	initial_position = horse_line.global_position
	horse_line.initial_position = horse_line.global_position
	
	target_position = horse_line.target_position
	riders = get_parent().get_horse_line().get_riders()
	
	# Calculate formation dimensions
	calculate_formation_dimensions()
	
	set_movement_phase()

func calculate_formation_dimensions():
	# Assuming riders are in a line, calculate width and depth
	if riders.size() > 1:
		var first_rider = riders[0]
		var last_rider = riders[-1]
		formation_width = first_rider.global_position.distance_to(last_rider.global_position)
		formation_depth = 1.0  # Adjust based on your formation depth
	else:
		formation_width = 1.0
		formation_depth = 1.0

func set_movement_phase():
	var distance_to_target = horse_line.global_position.distance_to(target_position)
	
	for rider in riders:
		if distance_to_target > 50:
			rider.get_animation_player().play("walkSlow")
			horse_line.move_speed = walk_slow_speed
		elif distance_to_target > 35:
			rider.get_animation_player().play("walk")
			horse_line.move_speed = walk_speed
		else:
			rider.get_animation_player().play("run")
			horse_line.move_speed = run_speed

func Update(_delta: float):
	set_movement_phase()
	
	# Check if we've passed the target
	var to_target = target_position - initial_position
	var current_progress = horse_line.global_position - initial_position
	if to_target.dot(to_target) <= current_progress.dot(to_target) + 1 :
		transitioned.emit(self, "CavIdle")

func Physics_Update(_delta: float):
	pass
