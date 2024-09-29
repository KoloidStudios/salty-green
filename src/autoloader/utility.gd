extends Node

const METER_TO_PIXEL = 16.0
const PIXEL_TO_METER = 1 / METER_TO_PIXEL
const METER_TO_PIXEL_SQUARED = 256.0

func _ready():
	DisplayServer.window_set_min_size(Vector2(640, 360))
