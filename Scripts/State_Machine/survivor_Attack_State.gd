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
	if script_user.global_position.distance_to(script_user.current_target.global_position) < script_user.attack_range:
		if tick >= tick_timer:
				script_user.animation_player.play("attack")
				script_user.current_target.take_damage(script_user.current_damage)
	else:
		transitioned.emit(self,"Survivor_Idle_state")

			#emit move
	#If distance < attack range
	#Play attack attack animation
	#target.damage(script_user.damage)
	
	#Else Emit move State
	pass

func Physics_Update(_delta: float):
	pass
