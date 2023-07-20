extends Vessel
class_name Player

func axis_to_gear(axis: float) -> Vessel_engine.Gear:
	if axis > 0:
		return Vessel_engine.Gear.Forward
	else:
		return Vessel_engine.Gear.Reverse

func _physics_process(_delta):
	var vert_axis: float = Input.get_axis("down", "up")
	var horz_axis: float = Input.get_axis("left", "right")
	# Input Up and Down for velocity
	if (vert_axis):
		var gear := axis_to_gear(vert_axis)
		if get_gear() != gear:
			set_gear(gear)

	_is_accelerating = bool(vert_axis)

	if (horz_axis):
		angular_direction = int(horz_axis)

	_is_rotating = bool(horz_axis)

	# No need to put move_and_slide as it's already called in base function
	super._physics_process(_delta)
