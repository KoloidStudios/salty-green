extends Area2D
class_name Weapon_projectile

@export var _lifetime_seconds: float = 0.0
@export var _speed           : float = 100.0

var _timer : Timer
var _is_activated := false

func _ready() -> void:
	_timer = Timer.new()
	_timer.wait_time = _lifetime_seconds
	_timer.one_shot = true
	assert(_lifetime_seconds > 0.0)
	_timer.connect("timeout", _dead)
	add_child(_timer)

func activate(target: Vector2) -> void:
	look_at(target)
	_is_activated = true
	_timer.start()

func _dead() -> void:
	queue_free()
	
func _physics_process(delta: float) -> void:
	if _is_activated:
		position += transform.x * _speed * delta
