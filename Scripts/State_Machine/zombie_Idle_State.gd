extends State

var script_user
var survivor_list

func _ready():
	script_user = get_parent().get_script_user()
	pass


func Enter():
	pass

func Exit():
	pass

func Update(_delta: float):
	survivor_list = get_tree().get_nodes_in_group("survivor")
	
	if survivor_list.size() > 0:
		pass
	else:
		transitioned.emit(self,"Zombie_Move_State")
	pass

func Physics_Update(_delta: float):
	pass
