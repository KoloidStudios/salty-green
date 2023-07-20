extends RigidBody2D
class_name Vessel

# let's use International standards
# This is not based on real life examples.
@export var ENGINE_POWER		 : float = 50#KW
@export var LENGTH				 : float = 2#m
@export var WIDTH				 : float = 0.5
@export var PROPELLER_DIAMETER	 : float = 0.4#m
@export var ANGULAR_ACCELERATION : float = 0.1#m/s^2
@export var BASE_MASS            : float = 400#kg

# Movement specifics.
var _is_accelerating : bool  = false
var _is_rotating	 : bool  = false

# TODO: implement rotate gear.
var angular_speed    : float   = 0.0
var angular_direction: int     = 0

# Physics helper
var _speed		      : float = 0.0
var _inverse_mass     : float = 0.0

# Engine implementation
@onready var _engine: Vessel_engine      = Vessel_engine.new(PROPELLER_DIAMETER, ENGINE_POWER, 0.4)
@onready var _gear  : Vessel_engine.Gear = Vessel_engine.Gear.Forward


func _update_mass(m: float) -> void:
	mass = m
	_inverse_mass = 1/m
	# i don't care, use solid cylinder inertia.
	inertia = (0.25 * pow(WIDTH, 2) + 0.08334 * pow(LENGTH, 2)) * mass * pow(Config.meter_to_pixel_multiplier, 2)

func is_moving() -> bool:
	return _is_accelerating or _is_rotating

func get_gear() -> Vessel_engine.Gear:
	return _gear

func set_gear(gear: Vessel_engine.Gear) -> void:
	_gear = gear

func get_engine() -> Vessel_engine:
	return _engine

func set_engine(engine: Vessel_engine) -> void:
	_engine = engine

func get_speed() -> float:
	return _speed

func get_drag_force() -> float:
	# drag force (fake)
	return 0.5 * 1000 * pow(_speed, 2) * 0.7 * WIDTH * LENGTH

func get_terminal_velocity() -> float:
	return sqrt(2 * _engine.get_thrust(_gear) / (1000 * 0.7 * WIDTH * LENGTH))

func get_damp() -> float:
	# dragforce / (mass * velocity)
	return 0.5 * 1000 * _speed * 0.7 * WIDTH * LENGTH * _inverse_mass

func _ready() -> void:
	_update_mass(BASE_MASS)

	print("Initial values")
	print("I: ", inertia)
	print("m: ", mass)
	print("T: ", _engine.get_thrust(_gear))
	print("a: ", _engine.get_thrust(_gear) * _inverse_mass)

func _physics_process(_delta) -> void:
	var app_force := Vector2.ZERO
	_speed = linear_velocity.length() * Config.pixel_to_meter_multiplier

	if _is_accelerating:
		app_force = transform.y * _engine.get_thrust(_gear)

	linear_damp = max(get_damp(), 1)

	if _is_rotating:
		apply_torque(Config.meter_to_pixel_multiplier * angular_direction * inertia * ANGULAR_ACCELERATION)

	apply_force(Config.meter_to_pixel_multiplier * app_force)
