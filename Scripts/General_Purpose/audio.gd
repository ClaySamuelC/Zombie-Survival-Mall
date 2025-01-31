extends Node

const MAX_SOUNDS = 32  # Limit on the number of concurrent sounds
var audio_pool: Array = []
var active_sounds: Array = []

@export var base_volume_db: float = 0.0  # Base volume (default: 0dB)

func _ready():
	# Prepopulate the pool with reusable AudioStreamPlayer3D nodes
	for i in range(MAX_SOUNDS):
		var player = AudioStreamPlayer3D.new()
		add_child(player)
		audio_pool.append(player)

# Play a sound at a given position
func play_sound(audio_stream: AudioStream, position: Vector3, volume_db: float = 0.0, max_distance: float = 10.0):
	if audio_pool.size() > 0:
		var player = audio_pool.pop_back()
		player.stream = audio_stream
		player.transform.origin = position
		
		# Scale volume based on the number of active sounds
		var adjusted_volume = volume_db - (active_sounds.size() * 2)  # Reduce volume as more sounds play
		player.volume_db = clamp(adjusted_volume, -60.0, base_volume_db)

		player.max_distance = max_distance
		player.attenuation_model = AudioStreamPlayer3D.ATTENUATION_INVERSE_DISTANCE
		player.play()
		active_sounds.append(player)

		player.connect("finished", Callable(self, "_on_player_finished").bind(player))

# Handle when a sound finishes
func _on_player_finished(player: AudioStreamPlayer3D):
	player.stop()
	active_sounds.erase(player)
	audio_pool.append(player)

# Stop all sounds
func stop_all_sounds():
	for player in active_sounds:
		player.stop()
	active_sounds.clear()
	audio_pool = []
