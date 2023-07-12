extends Node2D

@onready var boat 		 : Base_ship = get_node("boat")
@onready var debug_label : Label     = get_node("property_debug_label")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	debug_label.text = str("V: ", floorf(boat.speed), "m/s, Drag Force: ", floorf(boat.drag_force()), "N")
