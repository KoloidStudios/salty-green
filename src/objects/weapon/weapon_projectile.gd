extends Area2D
class_name Weapon_projectile

@export var _speed: float = 100.0
@export var _damage: float = 10.0
@export_range(1.0, 10.0) var _lifetime_seconds: float = 1.0

var timer := Timer.new()
var target := Vector2(0.0, 0.0)

func _ready() -> void:
	look_at(target)

	add_child(timer)
	timer.wait_time = _lifetime_seconds
	timer.one_shot = true
	timer.connect("timeout", kill)
	timer.start()

func kill() -> void:
	queue_free()
	
func _physics_process(delta: float) -> void:
	if !timer.is_stopped():
		position += transform.x * _speed * delta
