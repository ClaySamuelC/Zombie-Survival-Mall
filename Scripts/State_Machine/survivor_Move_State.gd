extends State

var script_user

func _ready():
	script_user = get_parent().get_script_user()
	script_user.find_targer()
	pass

func Enter():
	pass

func Exit():
	pass

func Update(_delta: float):
	var target = script_user.destination
	if script_user.global_position.distance_to(target) > 1:
		script_user.move_unit_by_vector(target)
	else:
		transitioned.emit(self,"Survivor_Idle_state")

func Physics_Update(_delta: float):
	pass
