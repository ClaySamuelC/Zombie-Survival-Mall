extends HBoxContainer

@export var title: String = "default"

@onready var button = $Upgrade
@onready var upgrade_handler = $UpgradeHandler

signal on_upgrade

# Called when the node enters the scene tree for the first time.
func _ready():
	$Label.text = title + ":"

func _on_upgrade_pressed():
	upgrade_handler.upgrade()
	on_upgrade.emit()
