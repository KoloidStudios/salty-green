extends CharacterBody2D
class_name Base_ship

# let's use International standards
# This is not based on real life examples.
@export var ENGINE_POWER         : float = 50#kW
@export var MAX_SPEED			 : float = 100#m/s
@export var MAX_ANGULAR_SPEED    : float = 0.5#m/s
@export var ANGULAR_ACCELERATION : float = 0.01#m/s^2
@export var MASS                 : float = 1000#kg
var ACCELERATION: float = ENGINE_POWER * 1000 / (MASS * MAX_SPEED)

var RESISTANCE_K : float = 40

var _fish_count 	 : int   = 0
var _is_accelerating : bool  = false
var _is_rotating	 : bool = false

# Speed is scalar, does not have any direction.
var speed		     : float = 0.0
# Ship only move forward and backward
var direction	     : int   = 0
# Rotational speed
var angular_speed    : float = 0.0
var angular_direction: int   = 0

func fish_count() -> int:
	return _fish_count

func is_moving() -> bool:
	return _is_accelerating or _is_rotating

func _physics_process(delta: float):
	if _is_accelerating:
		# Let's just assume the volume occupied in water.
		# Just use simple resistance force
		speed = move_toward(speed, direction * MAX_SPEED, ACCELERATION - RESISTANCE_K * abs(speed) / MASS)
	else:
		speed = move_toward(speed, 0, RESISTANCE_K * abs(speed) / MASS)

	if _is_rotating:
		angular_speed = move_toward(angular_speed, angular_direction * MAX_ANGULAR_SPEED, ANGULAR_ACCELERATION - RESISTANCE_K * abs(angular_speed) / MASS)
	else:
		angular_speed = move_toward(angular_speed, 0, RESISTANCE_K * abs(angular_speed) / MASS)

	velocity = Config.meter_to_pixel_multiplier * transform.y * speed
	rotation += Config.meter_to_pixel_multiplier * angular_speed * delta

	move_and_slide()
