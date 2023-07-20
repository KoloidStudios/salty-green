extends Node2D

@onready var boat : Vessel = get_node("boat")
signal debug_string(text: String)

func _process(_delta) -> void:
	#TODO: Get Net Force of boat.
	debug_string.emit(str("
		V: ", boat.get_speed(),"m/s,
		V: ", boat.linear_velocity.length(), "px/s
		Linear damp: ", boat.get_linear_damp(), "
		Drag Force: ", boat.get_drag_force(), "N,
		Thrust Force: ", boat.get_engine().get_thrust(boat.get_gear())))
