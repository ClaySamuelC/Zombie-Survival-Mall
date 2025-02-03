extends State

var script_user
var target

func _ready():
	script_user = get_parent().get_script_user()
	pass

func Enter():
	pass

func Exit():
	pass

func Update(_delta: float):
	if null == script_user.current_target:
		target = script_user.get_closest_target()
	if null == target:
		transitioned.emit(self,"Zombie_Idle_state")
	else:
		script_user.destination = target.global_position
		if script_user.global_position.distance_to(target.global_position) < script_user.attack_range:
			transitioned.emit(self,"Zombie_Attack_state")
		else:
			script_user.look_at(script_user.destination)
			script_user.move_unit(target)

func Physics_Update(_delta: float):
	pass
