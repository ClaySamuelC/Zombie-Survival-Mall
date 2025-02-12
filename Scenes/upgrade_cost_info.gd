extends MarginContainer

@onready var bullet_cost_obj = $GridContainer/ControlBullet/BulletCost
@onready var heal_kit_cost_obj = $GridContainer/ControlHk/HKCost
@onready var debris_cost_obj = $GridContainer/ControlDebris/DebrisCost

@onready var bullet_thumb = $GridContainer/ControlBullet/BulletThumb
@onready var heal_kit_thumb = $GridContainer/ControlHk/HKThumb
@onready var debris_thumb = $GridContainer/ControlDebris/DebrisThumb

func update_costs(bullet_cost, hk_cost, debris_cost):
	bullet_cost_obj.text = "-" + str(bullet_cost)
	heal_kit_cost_obj.text = "-" + str(hk_cost)
	debris_cost_obj.text = "-" + str(debris_cost)

func show_cost(bullet_cost, hk_cost, debris_cost):
	update_costs(bullet_cost, hk_cost, debris_cost)
	
	if bullet_cost > 0:
		bullet_thumb.show()
		bullet_cost_obj.show()
	
	if hk_cost > 0:
		heal_kit_thumb.show()
		heal_kit_cost_obj.show()
	
	if debris_cost > 0:
		debris_thumb.show()
		debris_cost_obj.show()

func hide_all():
	bullet_thumb.hide()
	bullet_cost_obj.hide()
	heal_kit_thumb.hide()
	heal_kit_cost_obj.hide()
	debris_thumb.hide()
	debris_cost_obj.hide()
