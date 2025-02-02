extends CanvasLayer

# Author: ClaySamuelC

@onready var bullets_label: RichTextLabel = $GUI_Control/MarginContainer/VBoxContainer/HBoxContainer/Bullets/Text
@onready var debris_label: RichTextLabel = $GUI_Control/MarginContainer/VBoxContainer/HBoxContainer/Debris/Text
@onready var healing_kits_label: RichTextLabel = $GUI_Control/MarginContainer/VBoxContainer/HBoxContainer/HealingKits/Text
@onready var zombie_kills_label: RichTextLabel = $GUI_Control/MarginContainer/VBoxContainer/HBoxContainer/ZombieKills/Text

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	bullets_label.text = str(GameState.bullets)
	debris_label.text = str(GameState.debris)
	healing_kits_label.text = str(GameState.healing_kits)
	zombie_kills_label.text = str(GameState.zombie_kills)
