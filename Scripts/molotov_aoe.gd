extends Area3D

var life_tick = 7

var tick = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	meeseeks()
	pass

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("zombie"):
		body.queue_free()

func meeseeks():
	tick += 1
	if tick >= life_tick:
		queue_free()
