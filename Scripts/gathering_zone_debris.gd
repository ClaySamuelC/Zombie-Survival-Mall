extends CollisionShape3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("survivor"):
		body.current_zone = self
		body.in_gather_zone = true

func _on_body_exited(body: Node3D) -> void:
	if body.is_in_group("survivor"):
		body.in_gather_zone = false

func gather():
		GameState.debris += 1
