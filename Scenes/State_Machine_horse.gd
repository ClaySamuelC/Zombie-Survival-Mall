extends Node

class_name State_Machine_horse

@export var initial_state : State

@export var current_state : State
@export var states : Dictionary = {}
@export var script_user: StaticBody3D


func _ready():
	for child in get_children():
		if child is State:
			states[child.name] = child
			child.transitioned.connect(on_child_transition)
	if initial_state:
		current_state = initial_state
		initial_state.Enter()

func _process(delta):
	if current_state:
		current_state.Update(delta)

func _physics_process(delta):
	if current_state:
		current_state.Physics_Update(delta)

func on_child_transition(state,new_state_name):
	if state != current_state:
		return
	var new_state = states.get(new_state_name)
	
	if !new_state:
		return
	
	if current_state:
		current_state.Exit()
		
	new_state.Enter()
	
	current_state = new_state

func get_horse_line():
	return script_user
