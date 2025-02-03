extends State
var script_user

var random = 0

func _ready():
	script_user = get_parent().get_script_user()
	pass

func Enter():
	pass

func Exit():
	pass

func Update(_delta: float):
	# Will get put in this state when they click G, select a unit, and then right click
	if script_user.in_gather_zone:
		script_user.gather_tick += 1
		script_user.gather_indicator.visible = true
		if script_user.gather_tick > script_user.gather_tick_timer:
			random = randi_range(0,script_user.current_zone.sound_list.size()-1)
			script_user.current_zone.gather(script_user.scrounge_speed)
			Audio.play_sound(load(script_user.current_zone.sound_list[random]), script_user.global_position,-randi_range(-20,-25),250)
			script_user.gather_tick = 0
	
	if script_user.gather_mode == false:
		script_user.gather_indicator.visible = false
		transitioned.emit(self,"Survivor_Attack_state")

func Physics_Update(_delta: float):
	pass
