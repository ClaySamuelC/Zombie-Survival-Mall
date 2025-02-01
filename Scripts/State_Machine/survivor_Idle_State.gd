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
	script_user.current_target = script_user.get_closest_target()
	if script_user.current_target:
		if script_user.global_position.distance_to(script_user.current_target.global_position) < script_user.attack_range:
			transitioned.emit(self,"Survivor_Attack_state")

func Physics_Update(_delta: float):
	pass
