extends CharacterBody2D
class_name Base_ship

# let's use International standards
# This is not based on real life examples.
@export var ENGINE_POWER         : float = 50#kW
@export var LENGTH				 : float = 2#m
@export var PROPELLER_DIAMETER	 : float = 0.4#m
@export var ANGULAR_ACCELERATION : float = 0.01#m/s^2
@export var MAX_ANGULAR_SPEED    : float = 0.5#m/s
@export var BASE_MASS            : float = 1000#kg

@export var ENGINE_FORWARD_MULTIPLIER   : float = 1.0
@export var ENGINE_BACKWARD_MULTIPLIER  : float = 0.4
@export var PHYSICAL_FORWARD_MULTIPLIER : float = 0.3
@export var PHYSICAL_BACKWARD_MULTIPLIER: float = 0.3

var THRUST: float = pow(PI * 0.5 * pow(PROPELLER_DIAMETER, 2) * 1000 * pow(ENGINE_POWER * 1000, 2), 0.3333334)

var MAX_SPEED: float = ENGINE_POWER * 1000 / THRUST

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

var total_mass		 : float = BASE_MASS
# Speed is scalar, does not have any direction.
var speed		     : float = 0.0
# Ship only move forward and backward
var direction	     : int   = 0
# Rotational speed
var angular_speed    : float   = 0.0
var angular_direction: int     = 0
var acceleration     : float   = THRUST / total_mass
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
	return 0.5 * 1000 * pow(abs(speed), 2) * 0.45 * 0.023 * LENGTH / total_mass

func _ready() -> void:
	print("a: ", acceleration)
	print("vt: ", MAX_SPEED)
	print("T: ", THRUST)

func _physics_process(delta: float) -> void:
	if _is_accelerating:
		normalized_vector = transform.y
		speed = move_toward(speed, direction * gear_multiplier(current_gear()) * MAX_SPEED, max(0, acceleration - eval_resistance()))
	else:
		speed = move_toward(speed, 0, eval_resistance())

	if _is_rotating:
		angular_speed = move_toward(angular_speed, angular_direction * MAX_ANGULAR_SPEED, ANGULAR_ACCELERATION)
	else:
		angular_speed = move_toward(angular_speed, 0, ANGULAR_ACCELERATION)

	velocity = Config.meter_to_pixel_multiplier * normalized_vector * speed
	rotation += Config.meter_to_pixel_multiplier * angular_speed * delta

	move_and_slide()
