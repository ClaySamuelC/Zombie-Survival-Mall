extends CanvasLayer

# Author: ClaySamuelC

@onready var bullets_label: RichTextLabel = $GUI_Control/MarginContainer/HBoxContainer/VBoxContainer/Bullets
@onready var debris_label: RichTextLabel = $GUI_Control/MarginContainer/HBoxContainer/VBoxContainer/Debris
@onready var healing_kits_label: RichTextLabel = $GUI_Control/MarginContainer/HBoxContainer/VBoxContainer/Healing_Kits

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	bullets_label.text = str(GameState.bullets)
	debris_label.text = str(GameState.debris)
	healing_kits_label.text = str(GameState.healing_kits)
