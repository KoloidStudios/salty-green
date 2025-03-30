extends Node

var vessel: Vessel = null:
	set(value):
		value.add_child(self)
		value.is_controlled = true
		value.group_id = -1
		vessel = value

var target: Vessel = null

@export var area: Area2D = null
@export var despawn_timer: Timer = null

func _ready() -> void:
	assert(area != null, "Area is null")
	var body_entered := func(body: Node2D) -> void:
		if body is Vessel: _vessel_entered(body as Vessel)
	var body_exited := func(body: Node2D) -> void:
		if body is Vessel: _vessel_exited(body as Vessel)
	var timeout := func() -> void:
		print("Pirate despawn")
		vessel.queue_free()
	area.connect("body_entered", body_entered)
	area.connect("body_exited", body_exited)
	despawn_timer.connect("timeout", timeout)
	despawn_timer.start(10)

func _process(_delta: float) -> void:
	pass

func _vessel_entered(in_vessel: Vessel) -> void:
	if target == null and in_vessel.is_hostile_to(vessel):
		target = in_vessel
		despawn_timer.stop()
	print("Vessel entered")

func _vessel_exited(out_vessel: Vessel) -> void:
	if target != null and target == out_vessel:
		target = null
		despawn_timer.start(10)
	print("Vessel exited")
