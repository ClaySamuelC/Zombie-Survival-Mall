extends StaticBody3D

var health = 1000

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group("debris")
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func take_damage(damage):
	health = health - damage
	if health <= 0:
		get_parent().queue_free()
