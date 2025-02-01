extends Node3D

# Constants for scene construction
const WALL_HEIGHT = 4.0
const ROOM_SIZE = Vector2(20, 20)  # Size of the central room
const WING_SIZE = Vector2(15, 20)  # Size of each wing
const WALL_THICKNESS = 0.5

func _ready():
	# Create the basic structure
	create_floors()
	create_walls()
	create_store_elements()
	
func create_floors():
	# Central floor
	var central_floor = create_floor_mesh(ROOM_SIZE)
	central_floor.position = Vector3(0, 0, 0)
	add_child(central_floor)
	
	# Wing floors
	var positions = {
		"north": Vector3(0, 0, -ROOM_SIZE.y/2 - WING_SIZE.y/2),
		"south": Vector3(0, 0, ROOM_SIZE.y/2 + WING_SIZE.y/2),
		"east": Vector3(ROOM_SIZE.x/2 + WING_SIZE.x/2, 0, 0),
		"west": Vector3(-ROOM_SIZE.x/2 - WING_SIZE.x/2, 0, 0)
	}
	
	for direction in positions:
		var wing_floor = create_floor_mesh(WING_SIZE)
		wing_floor.position = positions[direction]
		add_child(wing_floor)

func create_walls():
	# Central room walls
	#create_room_walls(Vector3.ZERO, ROOM_SIZE)
	
	# Wing walls
	var wing_positions = {
		"north": Vector3(0, 0, -ROOM_SIZE.y/2 - WING_SIZE.y/2),
		"south": Vector3(0, 0, ROOM_SIZE.y/2 + WING_SIZE.y/2),
		"east": Vector3(ROOM_SIZE.x/2 + WING_SIZE.x/2, 0, 0),
		"west": Vector3(-ROOM_SIZE.x/2 - WING_SIZE.x/2, 0, 0)
	}
	
	for direction in wing_positions:
		create_room_walls(wing_positions[direction], WING_SIZE)

func create_room_walls(position: Vector3, size: Vector2):
	# Create four walls for a room
	var wall_positions = [
		# North wall
		{"pos": Vector3(0, WALL_HEIGHT/2, -size.y/2), "size": Vector3(size.x, WALL_HEIGHT, WALL_THICKNESS)},
		# South wall
		{"pos": Vector3(0, WALL_HEIGHT/2, size.y/2), "size": Vector3(size.x, WALL_HEIGHT, WALL_THICKNESS)},
		# East wall
		{"pos": Vector3(size.x/2, WALL_HEIGHT/2, 0), "size": Vector3(WALL_THICKNESS, WALL_HEIGHT, size.y)},
		# West wall
		{"pos": Vector3(-size.x/2, WALL_HEIGHT/2, 0), "size": Vector3(WALL_THICKNESS, WALL_HEIGHT, size.y)}
	]
	
	for wall_data in wall_positions:
		var wall = create_wall_mesh(wall_data["size"])
		wall.position = position + wall_data["pos"]
		add_child(wall)

func create_store_elements():
	pass
	# Create central circle
	#var circle = create_central_circle()
	#add_child(circle)
	
	# Create store shelves and counters
	#create_sport_mart_elements()
	#create_pharmacy_elements()
	#create_dollar_store_elements()
	#create_cafe_elements()

func create_floor_mesh(size: Vector2) -> MeshInstance3D:
	var mesh_instance = MeshInstance3D.new()
	var plane_mesh = PlaneMesh.new()
	plane_mesh.size = size
	mesh_instance.mesh = plane_mesh
	
	# Add collision
	var static_body = StaticBody3D.new()
	var collision_shape = CollisionShape3D.new()
	collision_shape.shape = plane_mesh.create_trimesh_shape()
	static_body.add_child(collision_shape)
	mesh_instance.add_child(static_body)
	
	return mesh_instance

func create_wall_mesh(size: Vector3) -> MeshInstance3D:
	var mesh_instance = MeshInstance3D.new()
	var box_mesh = BoxMesh.new()
	box_mesh.size = size
	mesh_instance.mesh = box_mesh
	
	# Add collision
	var static_body = StaticBody3D.new()
	var collision_shape = CollisionShape3D.new()
	var box_shape = BoxShape3D.new()
	box_shape.size = size
	collision_shape.shape = box_shape
	static_body.add_child(collision_shape)
	mesh_instance.add_child(static_body)
	
	return mesh_instance

#func create_central_circle() -> MeshInstance3D:
	#var mesh_instance = MeshInstance3D.new()
	#var cylinder_mesh = CylinderMesh.new()
	#cylinder_mesh.height = 0.1
	#cylinder_mesh.radius_top = 5.0
	#mesh_instance.mesh = cylinder_mesh
	#mesh_instance.position = Vector3(0, 0.05, 0)  # Slightly above floor
	#
	#return mesh_instance

# Helper functions for creating store elements
#func create_shelf_unit(position: Vector3, size: Vector3) -> MeshInstance3D:
	#var shelf = create_wall_mesh(size)
	#shelf.position = position
	#return shelf

#func create_sport_mart_elements():
	#var shelves = [
		#Vector3(0, 1, -ROOM_SIZE.y - 5),
		#Vector3(0, 1, -ROOM_SIZE.y - 8),
		#Vector3(0, 1, -ROOM_SIZE.y - 11)
	#]
	#
	#for shelf_pos in shelves:
		#var shelf = create_shelf_unit(shelf_pos, Vector3(10, 2, 1))
		#add_child(shelf)
#
#func create_pharmacy_elements():
	#var shelves = [
		#Vector3(-ROOM_SIZE.x - 5, 1, 0),
		#Vector3(-ROOM_SIZE.x - 8, 1, 0),
		#Vector3(-ROOM_SIZE.x - 11, 1, 0)
	#]
	#
	#for shelf_pos in shelves:
		#var shelf = create_shelf_unit(shelf_pos, Vector3(1, 2, 10))
		#add_child(shelf)
#
#func create_dollar_store_elements():
	#var shelves = [
		#Vector3(ROOM_SIZE.x + 5, 1, 0),
		#Vector3(ROOM_SIZE.x + 8, 1, 0),
		#Vector3(ROOM_SIZE.x + 11, 1, 0)
	#]
	#
	#for shelf_pos in shelves:
		#var shelf = create_shelf_unit(shelf_pos, Vector3(1, 2, 10))
		#add_child(shelf)
#
#func create_cafe_elements():
	#var tables = [
		#Vector3(0, 1, ROOM_SIZE.y + 5),
		#Vector3(0, 1, ROOM_SIZE.y + 8),
		#Vector3(0, 1, ROOM_SIZE.y + 11)
	#]
	#
	#for table_pos in tables:
		#var table = create_shelf_unit(table_pos, Vector3(2, 1, 2))
		#add_child(table)
