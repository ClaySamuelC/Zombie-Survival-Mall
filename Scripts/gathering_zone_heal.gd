extends CollisionShape3D

var sound_list = ["res://Sounds/Rummage_Sound_1_backpack.ogg", "res://Sounds/Rummage_Sound_2_purse.ogg", "res://Sounds/Rummage_Sound_3_purse.ogg","res://Sounds/Rummage_Sound_4_paper.ogg", "res://Sounds/Rummage_Sound_5_paper.ogg"]

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("survivor"):
		body.current_zone = self
		body.in_gather_zone = true

func _on_body_exited(body: Node3D) -> void:
	if body.is_in_group("survivor"):
		body.in_gather_zone = false

func gather(rate: int):
		GameState.healing_kits += rate
