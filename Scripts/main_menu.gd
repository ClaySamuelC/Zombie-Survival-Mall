extends Control

var game

func _on_start_game_pressed() -> void:
	game = load("res://scenes/main.tscn")
	get_tree().change_scene_to_packed(game)

func _on_close_pressed() -> void:
	get_tree().quit()

func _on_options_pressed() -> void:
	print("Option")
