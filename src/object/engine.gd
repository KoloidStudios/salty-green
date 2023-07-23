class_name Vessel_engine

enum Gear {
	Forward,
	Reverse
}

var _engine_power: float = 0.0#KW
var _engine_thrust: float = 0.0#N

# Ratio between forward and reverse thrust
var _thrust_ratio: float = 0.0

func _init(propeller_diameter: float, engine_power: float, thrust_ratio: float):
	assert(thrust_ratio <= 1 and thrust_ratio >= 0, "Thrust ratio must between 0 and 1")
	_engine_power  = engine_power
	_engine_thrust = pow(PI * 0.5 * pow(propeller_diameter, 2) * 1000 * pow(_engine_power * 1000, 2), 0.3333334)
	_thrust_ratio  = thrust_ratio

func get_power() -> float:
	return _engine_power

func get_thrust(gear: Gear) -> float:
	match gear:
		Gear.Forward:
			return _engine_thrust
		Gear.Reverse:
			return _thrust_ratio * -_engine_thrust
		_:
			assert(false, "Impossible")
			return 0.0
