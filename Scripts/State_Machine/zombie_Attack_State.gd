extends State
var script_user

#First hit is fast, slow for the rest of the hits
var tick = 90
var tick_timer = 100

func _ready():
	script_user = get_parent().get_script_user()
	pass

func Enter():
	pass

func Exit():
	pass

func Update(_delta: float):
	if !script_user.current_target:
		script_user.current_target = script_user.get_closest_target()
	if script_user.current_target:
		if script_user.global_position.distance_to(script_user.current_target.global_position) < script_user.attack_range:
			if tick >= tick_timer:
					script_user.current_target.take_damage(script_user.current_damage)
					tick = 0
		else:
			transitioned.emit(self,"Zombie_Move_state")
		tick += 1
	pass

func Physics_Update(_delta: float):
	pass
