extends RigidBody2D
class_name Base_ship

# let's use International standards
# This is not based on real life examples.
@export var ENGINE_POWER         : float = 50#kW
@export var LENGTH				 : float = 2#m
@export var WIDTH				 : float = 0.5
@export var PROPELLER_DIAMETER	 : float = 0.4#m
@export var ANGULAR_ACCELERATION : float = 0.1#m/s^2
@export var BASE_MASS            : float = 1000#kg

@export var ENGINE_FORWARD_MULTIPLIER   : float = 1.0
@export var ENGINE_BACKWARD_MULTIPLIER  : float = 0.4
@export var PHYSICAL_FORWARD_MULTIPLIER : float = 0.3
@export var PHYSICAL_BACKWARD_MULTIPLIER: float = 0.3

var THRUST: float = pow(PI * 0.5 * pow(PROPELLER_DIAMETER, 2) * 1000 * pow(ENGINE_POWER * 1000, 2), 0.3333334)

class Gear:
	var forward_multiplier : float
	var backward_multiplier: float
	func _init(fm: float, bm: float):
		forward_multiplier  = fm
		backward_multiplier = bm
var ENGINE_GEAR   := Gear.new(ENGINE_FORWARD_MULTIPLIER, ENGINE_BACKWARD_MULTIPLIER)
var PHSYICAL_GEAR := Gear.new(PHYSICAL_FORWARD_MULTIPLIER, PHYSICAL_BACKWARD_MULTIPLIER)

enum GT {
	ENGINE,
	PHYSICAL
}

var _fish_count 	 : int   = 0
var _is_accelerating : bool  = false
var _is_rotating	 : bool = false

# Speed is scalar, does not have any direction.
var speed		     : float = 0.0
# Ship only move forward and backward
var direction	     : int   = 0
# Rotational speed
var angular_speed    : float   = 0.0
var angular_direction: int     = 0
var normalized_vector: Vector2 = transform.y
var current_gear_type: GT      = GT.ENGINE

func fish_count() -> int:
	return _fish_count

func is_moving() -> bool:
	return _is_accelerating or _is_rotating

func current_gear() -> Gear:
	match current_gear_type:
		GT.ENGINE:
			return ENGINE_GEAR
		GT.PHYSICAL:
			return PHSYICAL_GEAR
		_:
			assert(false, "Impossible")
			return Gear.new(0.0, 0.0) # Silent error

func gear_multiplier(gear: Gear) -> float:
	match direction:
		1:
			return gear.forward_multiplier
		-1:
			return gear.backward_multiplier
		_:
			return 0.0

func eval_resistance() -> float:
	# drag force
	return 0.5 * 1000 * pow(abs(speed), 2) * 0.45 * 0.023 * LENGTH / mass

func _ready() -> void:
	mass = BASE_MASS
	# i don't care, use solid cylinder inertia.
	inertia = 0.25 * mass * pow(WIDTH, 2) + 0.08334 * mass * pow(LENGTH, 2)
	print("I: ", inertia)
	print("m: ", mass)
	print("T: ", THRUST)

func _physics_process(_delta) -> void:
	if _is_accelerating:
		apply_force(Config.meter_to_pixel_multiplier * direction * transform.y * THRUST * gear_multiplier(current_gear()))

	apply_force(Config.meter_to_pixel_multiplier * -transform.y * eval_resistance())

	if _is_rotating:
		apply_torque(Config.meter_to_pixel_multiplier * angular_direction * LENGTH * ANGULAR_ACCELERATION * mass)
