extends Node

@onready var parent = self.get_parent()
@onready var max_health: int = parent.max_health

var health: int

#Animated health_bars
var healthbar
var healthbar_Inner
var tick_timer: float = 0.02

# Tracks whether the bar animations are running
var healthbar_animation_running: bool = false
var inner_bar_animation_running: bool = false

func _ready():
	# Cache health bar references
	healthbar = parent.get_node("SubViewport/HealthBar3D")
	healthbar_Inner = parent.get_node("SubViewport/HealthBar3D/HealthBar3DInner")
	health = parent.max_health

func add_health(amount: int) -> int:
	# Update health value, clamped by max_health
	health = parent.current_health
	health += amount
	health = clamp(health, 0, max_health)
	parent.current_health = health

	# Inner bar immediately updates to the new health
	healthbar_Inner.value = health

	# Smoothly animate the outer bar
	if not healthbar_animation_running:
		animate_healthbar_to_match_inner()

	return health

func take_damage(damage: int) -> int:
	# Update health value, clamped by 0
	health = parent.current_health
	health -= damage
	health = clamp(health, 0, max_health)
	parent.current_health = health

	# Outer bar immediately updates to the new health
	healthbar.value = health

	# Smoothly animate the inner bar
	if not inner_bar_animation_running:
		animate_inner_bar_to_match_health()

	# Trigger death if health is zero
	if health <= 0:
		parent.handle_death()

	return health

func animate_inner_bar_to_match_health():
	inner_bar_animation_running = true

	# Slowly adjust the inner bar to match the current health
	while healthbar_Inner.value != health:
		if healthbar_Inner.value > health:
			healthbar_Inner.value -= 1
		elif healthbar_Inner.value < health:
			healthbar_Inner.value += 1
		
		await get_tree().create_timer(tick_timer).timeout

	inner_bar_animation_running = false

func animate_healthbar_to_match_inner():
	healthbar_animation_running = true

	# Slowly adjust the health bar to match the inner bar
	while healthbar.value != healthbar_Inner.value:
		if healthbar.value > healthbar_Inner.value:
			healthbar.value -= 1
		elif healthbar.value < healthbar_Inner.value:
			healthbar.value += 1

		await get_tree().create_timer(tick_timer).timeout

	healthbar_animation_running = false
