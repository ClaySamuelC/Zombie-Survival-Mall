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
	#Will get put in this state when they click G, select a unit, and then right click
	if script_user.in_gather_zone:
		script_user.gather_tick += 1
		script_user.gather_indicator.visible = true
		if script_user.gather_tick > script_user.gather_tick_timer:
			script_user.current_zone.gather()
			script_user.gather_tick = 0
	
	if script_user.gather_mode == false:
		script_user.gather_indicator.visible = false
		transitioned.emit(self,"Survivor_Attack_state")
func Physics_Update(_delta: float):
	pass
