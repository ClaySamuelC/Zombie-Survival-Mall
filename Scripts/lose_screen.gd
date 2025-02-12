extends Control

@onready var menu = load("res://Scenes/main_menu.tscn")

@onready var score = GameState.zombie_kills

var game

func _ready():
	$VBoxContainer/Score.text = "[center]Zombies Killed: %s[/center]" % GameState.zombie_kills

func _on_menu_pressed() -> void:
	get_tree().change_scene_to_packed(menu)

func _on_close_pressed() -> void:
	get_tree().quit()

func _on_play_again_pressed():
	game = load("res://Scenes/main.tscn")
	get_tree().change_scene_to_packed(game)
