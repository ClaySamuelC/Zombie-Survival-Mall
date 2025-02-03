extends HBoxContainer

@export var title: String = "default"

@onready var button = $Upgrade
@onready var upgrade_info = $Cost/Label
@onready var upgrade_handler = $UpgradeHandler

# Called when the node enters the scene tree for the first time.
func _ready():
	$Label.text = title + ":"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_upgrade_mouse_entered():
	print("Enter")
	upgrade_info.show()

func _on_upgrade_mouse_exited():
	upgrade_info.hide()

func _on_upgrade_pressed():
	upgrade_handler.upgrade()
