extends CharacterBody3D

var enemy_team
signal died
var is_alive = true 


func _physics_process(delta: float) -> void:
	pass

func set_enemy_team(team:String):
	enemy_team = team
	$"Springfield M1903 A3".set_enemy_team(enemy_team)

func die():
	if is_alive:
		is_alive = false
		emit_signal("died")
		queue_free()  # Remove the soldier visually or disable it
