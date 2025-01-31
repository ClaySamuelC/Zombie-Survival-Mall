extends CharacterBody3D

var enemy_team = "Blue"
signal died
var is_alive = true 
var is_selected = false
@onready var horse = $Horse
@onready var lance_tip = $Lance/Lance_Tip
@onready var animation_player = $AnimationPlayer
var uninteruptable_animations = ["idle","walk"]

var horse_animation_player

var is_left_side: bool

var initial_move_speed = 10
var move_speed = 10

var target_position

func _ready():
	add_to_group("rider")
	horse_animation_player = horse.get_node("AnimationPlayer")

func _physics_process(delta: float) -> void:
	move_and_slide()
	if lance_tip.is_colliding():
		var collider = lance_tip.get_collider()
		if collider and collider.is_in_group(enemy_team):
			collider.die()
	pass

func set_enemy_team(team:String):
	enemy_team = team

func die():
	if is_alive:
		is_alive = false
		emit_signal("died")
		queue_free()  # Remove the soldier visually or disable it

func get_animation_player():
	return animation_player
	
func idle_animation():
	if uninteruptable_animations.find(animation_player.current_animation) == -1:
		animation_player.play("Idle")
		horse_animation_player.play("Armature|Idle")

func walk_animation():
	if uninteruptable_animations.find(animation_player.current_animation) == -1:
		animation_player.play("walk")
		horse_animation_player.play("Armature|Walk")

func run_animation():
	if uninteruptable_animations.find(animation_player.current_animation) == -1:
		animation_player.play("run")
		horse_animation_player.play("Armature|Run")

func walkSlow_animation():
	if uninteruptable_animations.find(animation_player.current_animation) == -1:
		animation_player.play("walk")
		horse_animation_player.play("Armature|WalkSlow")
