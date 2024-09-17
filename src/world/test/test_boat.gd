extends World

@onready var player : Vessel = get_node("player")
signal debug_string(text: String)

func _ready() -> void:
	focus_node = player

func _process(_delta) -> void:
	#TODO: Get Net Force of boat.
	debug_string.emit(str("
		V: ", player.get_speed(),"m/s,
		Linear damp: ", player.linear_damp, "
		Drag Force: ", player.debug_drag_force(), "N,
		Terminal Velocity: ", player.debug_terminal_velocity(),  "m/s"))
