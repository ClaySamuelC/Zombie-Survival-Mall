extends CollisionShape3D

var sound_list = ["res://Sounds/Rummage_Sound_5_screws_shells.ogg", "res://Sounds/Rummage_Sound_7_screws_shells.ogg", "res://Sounds/Rummage_Sound_8_screws_shells.ogg", "res://Sounds/Rummage_Sound_1_backpack.ogg", "res://Sounds/Rummage_Sound_2_purse.ogg", "res://Sounds/Rummage_Sound_3_purse.ogg"]

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("survivor"):
		body.current_zone = self
		body.in_gather_zone = true

func _on_body_exited(body: Node3D) -> void:
	if body.is_in_group("survivor"):
		body.in_gather_zone = false

func gather(rate: int):
		GameState.bullets += rate
