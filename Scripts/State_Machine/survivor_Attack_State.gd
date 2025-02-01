extends State
var script_user

var tick = 0
var tick_timer = 200

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
			if tick >= tick_timer:
					#script_user.animation_player.play("attack")
					script_user.current_target.take_damage(script_user.current_damage)
					tick = 0
	else:
		transitioned.emit(self,"Survivor_Idle_state")
	pass

func Physics_Update(_delta: float):
	if script_user.current_target:
		script_user.look_at(script_user.current_target.global_position)
	tick += 1
	pass
