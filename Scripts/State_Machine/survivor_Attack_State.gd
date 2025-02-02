extends State
var script_user

var tick = 0
var tick_timer = 80

func _ready():
	script_user = get_parent().get_script_user()
	pass

func Enter():
	pass

func Exit():
	pass

func Update(_delta: float):
	$"../../GunShot".visible = false
	#We only want to make this check if we don't have a target yet I think?
	#Probably this logic should be changed to have some zone around the person
	#and if their current_target leaves the zone then they recalculate only zombies in the zone
	if !script_user.current_target:
		script_user.current_target = script_user.get_closest_target()
	if script_user.current_target:
		if script_user.global_position.distance_to(script_user.current_target.global_position) < script_user.attack_range:
			script_user.look_at(script_user.current_target.global_position)
			if tick >= tick_timer:
					#script_user.animation_player.play("attack")
					script_user.current_target.take_damage(script_user.current_damage)
					$"../../GunShot".visible = true
					GameState.bullets -= 1
					tick = 0

	else:
		transitioned.emit(self,"Survivor_Idle_state")
	pass

func Physics_Update(_delta: float):
	tick += 1
	pass
