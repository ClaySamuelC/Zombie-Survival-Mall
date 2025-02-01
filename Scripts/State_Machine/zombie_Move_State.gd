extends State

var script_user

func _ready():
	script_user = get_parent().get_script_user()
	pass

func Enter():
	pass

func Exit():
	pass

func Update(_delta: float):
	var target = script_user.get_closest_target()
	if null == target:
		transitioned.emit(self,"Zombie_Idle_state")
	else:
		script_user.destination = target.global_position
		if script_user.global_position.distance_to(target.global_position) < script_user.attack_range:
			transitioned.emit(self,"Zombie_Attack_state")
		else:
			script_user.move_unit(target)


func Physics_Update(_delta: float):
	pass
