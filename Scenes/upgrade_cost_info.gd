extends MarginContainer

func update_costs(bullet_cost, hk_cost, debris_cost):
	$GridContainer/BulletCost.text = "-" + str(bullet_cost)
	$GridContainer/HKCost.text = "-" + str(hk_cost)
	$GridContainer/DebrisCost.text = "-" + str(debris_cost)

func show_cost(bullet_cost, hk_cost, debris_cost):
	update_costs(bullet_cost, hk_cost, debris_cost)
	
	if bullet_cost > 0:
		$GridContainer/BulletThumb.show()
		$GridContainer/BulletCost.show()
	
	if hk_cost > 0:
		$GridContainer/HKThumb.show()
		$GridContainer/HKCost.show()
	
	if debris_cost > 0:
		$GridContainer/DebrisThumb.show()
		$GridContainer/DebrisCost.show()

func hide_all():
	$GridContainer/BulletThumb.hide()
	$GridContainer/BulletCost.hide()
	$GridContainer/HKThumb.hide()
	$GridContainer/HKCost.hide()
	$GridContainer/DebrisThumb.hide()
	$GridContainer/DebrisCost.hide()
