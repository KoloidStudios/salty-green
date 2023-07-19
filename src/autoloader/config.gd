extends Node

var meter_to_pixel_multiplier = 16.0
var pixel_to_meter_multiplier = 1 / meter_to_pixel_multiplier

func _ready():
	DisplayServer.window_set_min_size(Vector2(640, 360))
	print("Loaded config")
