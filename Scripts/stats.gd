extends VBoxContainer

var selected_unit: Node3D = null

# Called when the node enters the scene tree for the first time.
func _ready():
	GameManager.on_unit_selected.connect(on_new_unit_selected)
	$Toughness.on_upgrade.connect(on_upgrade_clicked)
	$Damage.on_upgrade.connect(on_upgrade_clicked)
	$Speed.on_upgrade.connect(on_upgrade_clicked)
	$Scrounge.on_upgrade.connect(on_upgrade_clicked)

func on_upgrade_clicked():
	on_new_unit_selected(selected_unit)

func on_new_unit_selected(unit: Node3D):
	selected_unit = unit
	
	if selected_unit == null:
		return
	
	$Health.text = "Health: " + str(selected_unit.health) + "/" + str(unit.MAX_HEALTH)
	$Toughness/Value.text = str(selected_unit.toughness_level)
	$Damage/Value.text = str(selected_unit.damage_level)
	$Speed/Value.text = str(selected_unit.speed_level)
	$Scrounge/Value.text = str(selected_unit.scrounge_level)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
