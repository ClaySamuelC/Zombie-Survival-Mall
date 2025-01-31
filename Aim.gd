extends State
class_name Aim

var animation_player
var uninteruptable_animations = ["Aim","Reload","Fire"]

func _ready():
	animation_player = self.get_parent().get_animation_player()

func Enter():
	pass

func Exit():
	pass

func Update(_delta: float):
	pass


func Physics_Update(_delta: float):
	if !uninteruptable_animations.has(animation_player.get_current_animation()):
		animation_player.play("Aim")
		transitioned.emit(self,"Fire")
