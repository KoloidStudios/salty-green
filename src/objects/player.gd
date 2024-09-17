extends Vessel
class_name Player

func _physics_process(_delta):
	# Get input
	var vert_axis: float = Input.get_axis("down", "up")
	var horz_axis: float = Input.get_axis("left", "right")

	#Vessel::_linear_direction
	_linear_direction = int(vert_axis)
	#Vessel::_angular_direction
	_angular_direction = int(horz_axis)

	# No need to put move_and_slide as it's already called in base function
	super._physics_process(_delta)
