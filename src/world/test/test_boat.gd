extends Node2D

@onready var boat : Base_ship = get_node("boat")
signal debug_string(text: String)

func _process(_delta) -> void:
	#TODO: Get Net Force of boat.
	debug_string.emit(str("
		V: ", boat.speed,"m/s,
		V: ", boat.linear_velocity.length(), "px/s
		a: ", (boat.thrust_force.length() - boat.get_drag_force())/boat.mass, "m/s^2
		Linear damp: ", boat.get_linear_damp(), "
		Drag Force: ", boat.get_drag_force(), "N,
		Net Force: ", boat.thrust_force))
