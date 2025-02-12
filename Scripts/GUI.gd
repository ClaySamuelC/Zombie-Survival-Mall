extends CanvasLayer

# Author: ClaySamuelC

@onready var bullets_label: RichTextLabel = $GUI_Control/ResourceGUI/PanelContainer/VBoxContainer/HBoxContainer/Bullets/MarginContainer/Text
@onready var debris_label: RichTextLabel = $GUI_Control/ResourceGUI/PanelContainer/VBoxContainer/HBoxContainer/Debris/MarginContainer/Text
@onready var healing_kits_label: RichTextLabel = $GUI_Control/ResourceGUI/PanelContainer/VBoxContainer/HBoxContainer/HealingKits/MarginContainer/Text
@onready var zombie_kills_label: RichTextLabel = $GUI_Control/ResourceGUI/PanelContainer/VBoxContainer/HBoxContainer/ZombieKills/MarginContainer/Text
@onready var molotovs_label: RichTextLabel = $GUI_Control/ResourceGUI/PanelContainer/VBoxContainer/HBoxContainer/Molotovs/MarginContainer/Text

@onready var bullet_minus: RichTextLabel = $GUI_Control/ResourceGUI/PanelContainer/VBoxContainer/HBoxContainer/Bullets/MarginContainer/BulletMinus
@onready var heal_kit_minus: RichTextLabel = $GUI_Control/ResourceGUI/PanelContainer/VBoxContainer/HBoxContainer/HealingKits/MarginContainer/HealKitMinus
@onready var debris_minus: RichTextLabel = $GUI_Control/ResourceGUI/PanelContainer/VBoxContainer/HBoxContainer/Debris/MarginContainer/DebrisMinus
@onready var molotov_minus: RichTextLabel = $GUI_Control/ResourceGUI/PanelContainer/VBoxContainer/HBoxContainer/Molotovs/MarginContainer/MolotovMinus


func _ready() -> void:
	GameState.update_ui.connect(flash_minus)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	bullets_label.text = str(GameState.bullets)
	debris_label.text = str(GameState.debris)
	healing_kits_label.text = str(GameState.healing_kits)
	zombie_kills_label.text = str(GameState.zombie_kills)
	molotovs_label.text = str(GameState.molotov)

func flash_minus(resource : String, amount : int):
	if resource == "bullet":
		bullet_minus.text = "[color=yellow]			-{a}[/color]".format({"a":amount})
		bullet_minus.visible = true
		await get_tree().create_timer(.5).timeout
		bullet_minus.visible = false
	if resource == "heal_kit":
		heal_kit_minus.text = "[color=yellow]			-{a}[/color]".format({"a":amount})
		heal_kit_minus.visible = true
		await get_tree().create_timer(.5).timeout
		heal_kit_minus.visible = false
	if resource == "debris":
		debris_minus.text = "[color=yellow]			-{a}[/color]".format({"a":amount})
		debris_minus.visible = true
		await get_tree().create_timer(.5).timeout
		debris_minus.visible = false
	if resource == "molotov":
		molotov_minus.text = "[color=yellow]			-{a}[/color]".format({"a":amount})
		molotov_minus.visible = true
		await get_tree().create_timer(.5).timeout
		molotov_minus.visible = false
