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
	var target = script_user.current_target
	if null == target:
		transitioned.emit(self,"Zombie_Idle_state")
	else:
		script_user.destination = target.global_position
		if script_user.global_position.distance_to(target.global_position) < script_user.attack_range:
			script_user.animation_player.play("attack")
			target.work_node(script_user)
		else:
			script_user.move_unit(target)

	#if script_user.current_target == null emit idle state
	# else move towards target. 
	#if in distance then emit attack


func Physics_Update(_delta: float):
	pass
