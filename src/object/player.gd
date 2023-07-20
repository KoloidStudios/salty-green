extends Vessel
class_name Player

func _physics_process(_delta):
	var vert_axis: float = Input.get_axis("down", "up")
	var horz_axis: float = Input.get_axis("left", "right")
	# Input Up and Down for velocity
	if (vert_axis):
		if get_direction() != int(vert_axis):
			set_direction(int(vert_axis))

	_is_accelerating = bool(vert_axis)

	if (horz_axis):
		angular_direction = int(horz_axis)

	_is_rotating = bool(horz_axis)

	# No need to put move_and_slide as it's already called in base function
	super._physics_process(_delta)
