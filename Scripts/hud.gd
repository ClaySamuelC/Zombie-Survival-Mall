extends CanvasLayer

@export var money = 0
@export var money_to_add = 1
@export var worker_count = 1
@export var collecting = false
@export var worker_speed_in_seconds = 3

func _physics_process(delta):
	#replace with worker system?
	handle_resources(delta)

func handle_resources(delta):
	if !collecting:
		collecting = true
		money_collected(money_to_add)
		$Coins.text = str(money)
		await get_tree().create_timer(worker_speed_in_seconds).timeout
		collecting = false

func _on_coin_collected(coins):
	$Coins.text = str(coins)

func money_collected(amount):
	var to_add = money_to_add * worker_count
	money = money + to_add
