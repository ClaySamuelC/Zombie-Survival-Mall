extends HBoxContainer

var selected_unit: Node3D = null

# Called when the node enters the scene tree for the first time.
func _ready():
	GameState.on_unit_selected.connect(on_new_unit_selected)
	$Stats/Toughness.on_upgrade.connect(on_upgrade_clicked)
	$Stats/Damage.on_upgrade.connect(on_upgrade_clicked)
	$Stats/Speed.on_upgrade.connect(on_upgrade_clicked)
	$Stats/Scrounge.on_upgrade.connect(on_upgrade_clicked)
	
	$Stats/Toughness.on_upgrade.connect(show_toughness_upgrade)
	$Stats/Damage.on_upgrade.connect(show_damage_upgrade)
	$Stats/Speed.on_upgrade.connect(show_speed_upgrade)
	$Stats/Scrounge.on_upgrade.connect(show_scrounge_upgrade)
	
	$Stats/Toughness/Upgrade.mouse_entered.connect(show_toughness_upgrade)
	$Stats/Damage/Upgrade.mouse_entered.connect(show_damage_upgrade)
	$Stats/Speed/Upgrade.mouse_entered.connect(show_speed_upgrade)
	$Stats/Scrounge/Upgrade.mouse_entered.connect(show_scrounge_upgrade)
	
	$Stats/Toughness/Upgrade.mouse_exited.connect($UpgradeCostInfo.hide_all)
	$Stats/Damage/Upgrade.mouse_exited.connect($UpgradeCostInfo.hide_all)
	$Stats/Speed/Upgrade.mouse_exited.connect($UpgradeCostInfo.hide_all)
	$Stats/Scrounge/Upgrade.mouse_exited.connect($UpgradeCostInfo.hide_all)

func on_upgrade_clicked():
	on_new_unit_selected(selected_unit)

func on_new_unit_selected(unit: Node3D):
	selected_unit = unit
	
	if selected_unit == null:
		return
	
	$Stats/Health.text = "Health: " + str(selected_unit.health) + "/" + str(unit.MAX_HEALTH)
	$Stats/Damage/Value.text = str(selected_unit.damage_level)
	$Stats/Toughness/Value.text = str(selected_unit.toughness_level)
	$Stats/Speed/Value.text = str(selected_unit.speed_level)
	$Stats/Scrounge/Value.text = str(selected_unit.scrounge_level)

func show_damage_upgrade():
	if selected_unit == null:
		return
	
	var bullet_cost = $Stats/Damage/UpgradeHandler.get_bullet_cost(selected_unit.damage_level)
	$UpgradeCostInfo.show_cost(bullet_cost, 0, 0)

func show_toughness_upgrade():
	if selected_unit == null:
		return
	
	var hk_cost = $Stats/Toughness/UpgradeHandler.get_hk_cost(selected_unit.toughness_level)
	$UpgradeCostInfo.show_cost(0, hk_cost, 0)

func show_speed_upgrade():
	if selected_unit == null:
		return
	
	var bullet_cost = $Stats/Speed/UpgradeHandler.get_bullet_cost(selected_unit.speed_level)
	var hk_cost = $Stats/Speed/UpgradeHandler.get_hk_cost(selected_unit.speed_level)
	$UpgradeCostInfo.show_cost(bullet_cost, hk_cost, 0)

func show_scrounge_upgrade():
	if selected_unit == null:
		return
	
	var bullet_cost = $Stats/Scrounge/UpgradeHandler.get_bullet_cost(selected_unit.scrounge_level)
	var hk_cost = $Stats/Scrounge/UpgradeHandler.get_hk_cost(selected_unit.scrounge_level)
	var debris_cost = $Stats/Scrounge/UpgradeHandler.get_debris_cost(selected_unit.scrounge_level)
	$UpgradeCostInfo.show_cost(bullet_cost, hk_cost, debris_cost)
