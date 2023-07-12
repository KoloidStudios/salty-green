extends Node2D

@onready var boat : Base_ship = get_node("boat")
signal debug_string(text: String)

func _process(delta: float) -> void:
	#TODO: Get Net Force of boat.
	debug_string.emit(str(
		"V: ", floorf(boat.speed),"m/s,
		Drag Force: ", floorf(boat.drag_force()), "N"))
