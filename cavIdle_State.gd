extends State
class_name CavIdle

var riders

func Enter():
	riders = get_parent().get_horse_line().get_riders()
	# Assuming you have a formation manager or similar to handle positioning
	for rider in riders:
		rider.idle_animation()
		rider.move_speed = 0

func Exit():
	for rider in riders:
		rider.move_speed = rider.initial_move_speed

func Update(_delta: float):
	# Check if unit is selected and player has clicked somewhere
	if get_parent().get_horse_line().is_selected and Input.is_action_pressed("right_click"):
		transitioned.emit(self, "CavTargeting")

func Physics_Update(_delta: float):
	for rider in riders:
		rider.idle_animation()
	pass
