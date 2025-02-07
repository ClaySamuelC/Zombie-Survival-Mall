extends Control

var game

func _physics_process(delta):
	pass

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _on_start_game_pressed() -> void:
	game = load("res://scenes/main.tscn")
	get_tree().change_scene_to_packed(game)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#Open an options screen :)
	pass

func _on_close_pressed() -> void:
	get_tree().quit()
	pass # Replace with function body.

func _on_options_pressed() -> void:
	print("Option")
	pass # Replace with function body.
