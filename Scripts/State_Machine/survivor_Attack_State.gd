extends State
var script_user

var windup = randi_range(0,15)
var windup_timer = 0

func _ready():
	script_user = get_parent().get_script_user()

func Update(_delta: float):
	$"../../GunShot".visible = false
	#We only want to make this check if we don't have a target yet I think?
	#Probably this logic should be changed to have some zone around the person
	#and if their current_target leaves the zone then they recalculate only zombies in the zone
	if !script_user.current_target:
		script_user.current_target = script_user.get_closest_target()
	if script_user.current_target:
		windup_timer += 1
		var new_transform = script_user.transform.looking_at(script_user.current_target.global_position, Vector3.UP)
		script_user.transform = script_user.transform.interpolate_with(new_transform, script_user.SPEED * _delta)
		if script_user.global_position.distance_to(script_user.current_target.global_position) < script_user.attack_range and GameState.bullets > 0 and windup_timer > windup:
			if script_user.attack_tick >= script_user.attack_tick_timer:
					script_user.current_target.take_damage(script_user.current_damage)
					$"../../GunShot".visible = true
					Audio.play_sound(load("res://Sounds/Shotgun_gunshot.ogg"), script_user.global_position,-randi_range(-15,-25),250)
					GameState.bullets -= 1
					script_user.attack_tick = 0
					windup_timer = 0

	else:
		transitioned.emit(self,"Survivor_Idle_state")


func Physics_Update(_delta: float):
	script_user.attack_tick += 1
