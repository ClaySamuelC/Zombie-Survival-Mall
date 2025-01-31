extends Node3D

var enemy_team

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func fire():
	
	handle_fog()
	handle_fog()
	
	var ball = load("res://Scenes/musket_ball.tscn")
	var musket_ball = ball.instantiate()
	musket_ball.set_enemy_team(enemy_team)
	self.get_parent().add_child(musket_ball)

	# Get the initial position and rotation
	musket_ball.global_position = $MuzzleTip.global_position

	# Calculate the spread based on MOA
	var moa = 2.5  # Minute of Angle (adjust for more or less spread)
	var distance = 100.0  # Target distance in meters
	var moa_deviation = (moa / 60.0) * distance / 100.0  # Convert MOA to radians and scale

	# Generate random offset within the spread cone
	var random_x = randf_range(-moa_deviation, moa_deviation)
	var random_y = randf_range(-moa_deviation, moa_deviation)

	# Apply the random deviation to the ball's direction
	var direction = $MuzzleTip.transform.basis.x.normalized()
	direction += Vector3(random_x, random_y, 0).normalized() * moa_deviation
	musket_ball.set("direction", direction)
	Audio.play_sound(load("res://faster-musket-bang.ogg"), self.global_position,-randi_range(-10,-15),150) # Play sound

func set_enemy_team(team:String):
	enemy_team = team

func handle_fog():
	var loader = load("res://Scenes/musket_fog.tscn")
	var fog = loader.instantiate()
	self.get_parent().add_child(fog)
	fog.global_position = $MuzzleTip.global_position
