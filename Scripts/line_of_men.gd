extends Node3D

@export var spacing: float = 2.0  # Spacing between soldiers

var soldiers := []  # Store soldiers in the line

func _ready() -> void:
	self.add_to_group("line")
	# Initialize soldiers list
	for child in get_children():
		if child is CharacterBody3D:
			soldiers.append(child)
			child.connect("died", Callable(self, "_on_soldier_died"))  # Corrected connect usage
	update_positions()

func update_positions():
	# Adjust positions of remaining soldiers
	for i in range(soldiers.size()):
		var soldier = soldiers[i]
		#instead set as desire position and have them walk to it
		soldier.position = Vector3(0, 0,i * spacing)

func _on_soldier_died():
	# Update the list of soldiers when one dies
	soldiers = soldiers.filter(func(soldier): return soldier.is_alive)
