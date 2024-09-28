extends RigidBody2D
class_name Vessel

# let's use International standards
# This is not based on real life examples.
@export var ENGINE_POWER         : float#KW
@export var LENGTH               : float#m
@export var WIDTH                : float#m
@export var PROPELLER_DIAMETER   : float#m
@export var ANGULAR_ACCELERATION : float#m/s^2
@export var BASE_MASS            : float#kg
@export var BASE_HEALTH_POINT    : float

# Private Members
var _speed             : float = 0.0
var _inverse_mass      : float = 0.0
var _health_point      : int = 0
var _has_weapon        : bool = false

@onready var _engine := Vessel_engine.new(PROPELLER_DIAMETER, ENGINE_POWER, 0.4)
@onready var _weapons: Array[Weapon] = []
@onready var _weapons_node: Node2D = find_child("weapons")

# Public Members
var linear_direction  : int = 0
var angular_direction : int = 0

# Private Methods
# Mass modifier
func _update_mass(m: float) -> void:
	#RigidBody2D::mass
	mass = m
	_inverse_mass = 1/m
	
	# Just use solid cylinder inertia.
	# 1/4 MR^2 + 1/12ML^2
	# (1/4 R^2 + 1/12L^2) * M
	#RigidBody2D::inertia
	inertia = (0.25 * pow(WIDTH, 2) + 0.08334 * pow(LENGTH, 2)) * mass * pow(Config.meter_to_pixel_multiplier, 2)


func _calc_linear_damp() -> float:
	# 1/2 * ro * v^2 * Cd * A / (m * v)
	# Use 0.7 as Cd
	# Use 1000kg/m^3 as density of water
	return 0.5 * 1000 * _speed * 0.7 * WIDTH * LENGTH * _inverse_mass

# Public Methods
func add_mass(m: float) -> void:
	var new_mass := m + mass
	_update_mass(new_mass)
func remove_mass(m: float) -> void:
	var new_mass := mass - m
	_update_mass(new_mass)

func change_weapon(weapon: Weapon, index: int) -> void:
	assert(index < _weapons_node.get_child_count())
	var weapon_slot: Node2D = _weapons_node.get_child(index)
	# Mostly this is just one weapon
	for equipped: Weapon in _weapons_node.get_child(index).get_children():
		weapon_slot.remove_child(equipped)
		_weapons.erase(equipped)
	if weapon != null:
		weapon_slot.add_child(weapon)
		_weapons.append(weapon)

func get_speed() -> float:
	return _speed

func get_weapons() -> Array[Weapon]:
	return _weapons
	
func get_weapon_at(index: int) -> Weapon:
	var weapon_slot: Node2D = _weapons_node.get_child(index)
	if weapon_slot.get_child_count() != 0:
		return weapon_slot.get_child(0)
	return null

func is_moving() -> bool:
	return bool(linear_direction) or bool(angular_direction)

func has_weapon() -> bool:
	return !_weapons.is_empty()

func has_weapon_slot() -> bool:
	return _weapons_node != null

# Godot Functions
func _ready() -> void:
	# Check for weapons
	if has_weapon_slot():
		for weapon_slot: Node2D in _weapons_node.get_children():
			if weapon_slot.get_child_count() != 0:
				_weapons.append(weapon_slot.get_child(0))
	_update_mass(BASE_MASS)
	_health_point = BASE_HEALTH_POINT

func _physics_process(_delta) -> void:
	var applied_force := Vector2.ZERO

	if linear_direction:
		applied_force = transform.y * _engine.get_thrust(linear_direction)
	if angular_direction:
		apply_torque(angular_direction * inertia * ANGULAR_ACCELERATION * Config.meter_to_pixel_multiplier)

	_speed = linear_velocity.length() * Config.pixel_to_meter_multiplier
	linear_damp = max(_calc_linear_damp(), 1)

	apply_force(Config.meter_to_pixel_multiplier * applied_force)

# Debug Functions
func debug_drag_force() -> float:
	# drag force (fake)
	return 0.5 * 1000 * pow(_speed, 2) * 0.7 * WIDTH * LENGTH

func debug_terminal_velocity() -> float:
	return sqrt(2 * abs(_engine.get_thrust(linear_direction)) / (1000 * 0.7 * WIDTH * LENGTH))
