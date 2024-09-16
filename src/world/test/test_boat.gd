extends World

@onready var boat : Vessel = get_node("boat")
signal debug_string(text: String)

func _ready() -> void:
	focus_node = boat

func _process(_delta) -> void:
	#TODO: Get Net Force of boat.
	debug_string.emit(str("
		V: ", boat.get_speed(),"m/s,
		V: ", boat.linear_velocity.length(), "px/s
		Linear damp: ", boat.linear_damp, "
		Drag Force: ", boat.debug_drag_force(), "N,
		Terminal Velocity: ", boat.debug_terminal_velocity(),  "m/s"))
