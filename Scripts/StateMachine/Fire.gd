extends State
class_name Fire

var animation_player 
var uninteruptable_animations = ["Aim","Reload","Fire"]

var rifle

func _ready():
	animation_player = self.get_parent().get_animation_player()
	rifle = self.get_parent().get_rifle()

func Enter():
	pass

func Exit():
	pass

func Update(_delta: float):
	pass

func Physics_Update(_delta: float):
	if !uninteruptable_animations.has(animation_player.get_current_animation()) and rifle:
		animation_player.play("Fire")
		rifle.get_node("MuzzleTip").get_node("MuzzleSmoke").get_node("Particles").restart()
		rifle.fire()
		transitioned.emit(self,"Reload")
