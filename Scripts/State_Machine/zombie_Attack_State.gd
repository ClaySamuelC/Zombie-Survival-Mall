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
	#If distance < attack range
	#Play attack attack animation
	#target.damage(script_user.damage)
	
	#Else Emit move State
	pass

func Physics_Update(_delta: float):
	pass
