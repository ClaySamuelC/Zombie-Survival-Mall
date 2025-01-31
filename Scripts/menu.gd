extends Control

@export var money = 0
@export var money_to_add = 1
@export var worker_count = 1
@export var collecting = false
@export var worker_speed_in_seconds = 3

@onready var coins = $Control/HBoxContainer/Coins

var skele_spawning = false

var skeleton_spawn_time_in_seconds = 2

func _physics_process(delta):
	#replace with worker system?
	handle_resources(delta)
	#print(Engine.get_frames_per_second())

func handle_resources(delta):
	if !collecting:
		collecting = true
		money_collected(money_to_add)
		coins.text = str(money)
		await get_tree().create_timer(worker_speed_in_seconds).timeout
		collecting = false

func _on_coin_collected(coins):
	coins.text = str(coins)

func money_collected(amount):
	var to_add = money_to_add * worker_count
	money = money + to_add

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_knight_pressed() -> void:
	if has_enough_money():
		var num = randi_range(1,20)
		
		var skeleton = load("res://scenes/knight.tscn")
		var object = skeleton.instantiate()
		self.get_parent().get_parent().add_child(object)
		object.set_global_position(Vector3(-7 + num,8,8 + num))

func _on_mage_pressed() -> void:
	if has_enough_money():
		var num = randi_range(1,20)
		
		var skeleton = load("res://scenes/healer.tscn")
		var object = skeleton.instantiate()
		self.get_parent().get_parent().add_child(object)
		object.set_global_position(Vector3(-7 + num,8,8 + num))

func _on_skeleton_pressed() -> void:
	if !skele_spawning:
		var num = randi_range(1,5)
		skele_spawning = true
		var skeleton = load("res://scenes/skeleton_minion_with_health_bar.tscn")
		var object = skeleton.instantiate()
		self.get_parent().get_parent().add_child(object)
		object.set_global_position(Vector3(-7 + num,8,8 + num))
		skele_spawning = false

func _on_close_pressed() -> void:
	get_tree().quit()
	pass # Replace with function body.

func has_enough_money():
	return true
