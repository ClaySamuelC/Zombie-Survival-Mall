extends State
class_name CavTargeting

var is_wedge_formed = false

func Enter():
	# Transform formation into wedge
	form_wedge()

func form_wedge():
	# Implement your wedge formation logic here
	print("wedge up")
	is_wedge_formed = true

func Update(_delta: float):
	# Wait until wedge is formed before transitioning
	if is_wedge_formed:
		transitioned.emit(self, "CavCharge")

func Physics_Update(_delta: float):
	pass
