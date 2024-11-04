class_name VesselEngine

var _engine_power: float = 0.0#KW
var _engine_thrust: float = 0.0#N

# Ratio between forward and reverse thrust
var _forward_reverse_ratio: float = 0.0

func _init(propeller_diameter: float, engine_power: float, forward_reverse_ratio: float):
	assert(forward_reverse_ratio <= 1 and forward_reverse_ratio >= 0, "Forward-reverse ratio must between 0 and 1")
	_engine_power = engine_power
	_engine_thrust = pow(PI * 0.5 * pow(propeller_diameter, 2) * 1000 * pow(_engine_power * 1000, 2), 0.3333334)
	_forward_reverse_ratio = forward_reverse_ratio

func get_power() -> float:
	return _engine_power

func get_thrust(direction: int) -> float:
	match direction:
		1 : return _engine_thrust
		-1: return _forward_reverse_ratio * -_engine_thrust
		_ : return 0.0
