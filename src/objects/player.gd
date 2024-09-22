extends Vessel
class_name Player

func _physics_process(_delta: float) -> void:
	# Get inputs
	# Directional inputs
	var vert_axis: float = Input.get_axis("down", "up")
	var horz_axis: float = Input.get_axis("left", "right")

	# Mouse inputs
	if has_weapon():
		var mouse_position := get_viewport().get_mouse_position()
		for weapon: Weapon in get_weapons():
			weapon.rotate_to(mouse_position)
		if Input.is_action_just_pressed("fire"):
			for weapon: Weapon in get_weapons():
				weapon.fire(mouse_position)

	#Vessel::_linear_direction
	_linear_direction = int(vert_axis)
	#Vessel::_angular_direction
	_angular_direction = int(horz_axis)

	# No need to put move_and_slide as it's already called in base function
	super._physics_process(_delta)
