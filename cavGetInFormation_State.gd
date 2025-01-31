extends State
class_name CavGetInFormation

var spacing:= 3.0
var riders
var horse_line: StaticBody3D

func Enter():
	horse_line = get_parent().get_horse_line()
	riders = horse_line.get_riders()
	
	for rider in riders:
		rider.idle_animation()
	
	arrange_formation()

func arrange_formation():
	for i in range(riders.size()):
		var rider = riders[i]
		#instead set as desire position and have them walk to it
		rider.target_position = Vector3(horse_line.position.x,0,(i * spacing) + horse_line.position.z)
		print(rider.target_position)


func Update(_delta: float):
	# Check if all riders have reached their positions
	var all_in_position = true
	for rider in riders:
		print(rider.global_position.distance_to(rider.target_position))
		if rider.global_position.distance_to(rider.target_position) > 1:
			all_in_position = false
			break
	
	if all_in_position:
		transitioned.emit(self, "CavIdle")

func Physics_Update(_delta: float):
	# Move riders towards their target positions
	for rider in riders:
		if rider.target_position:
			if rider.global_position.distance_to(rider.target_position) > 0.1:
				var direction = (rider.target_position - rider.global_position).normalized()
				rider.velocity = direction * rider.move_speed
