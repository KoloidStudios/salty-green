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
@export var refresh_timer: Timer = null

var astar_grid := AStarGrid2D.new()
var paths: Array[Vector2i]

var _last_cell_position := Vector2i.ZERO

func _ready() -> void:
	assert(area != null, "Area is null")
	var body_entered := func(body: Node2D) -> void:
		if body is Vessel: _vessel_entered(body as Vessel)
	var body_exited := func(body: Node2D) -> void:
		if body is Vessel: _vessel_exited(body as Vessel)
	var despawn_timeout := func() -> void:
		print("Pirate despawn")
		vessel.queue_free()
	var refresh_timeout := func() -> void:
		astar_grid.update()
		paths = astar_grid.get_id_path(Vector2i.ZERO, World.get_cell_position(target.global_position - vessel.global_position))
		_last_cell_position = World.get_cell_position(vessel.global_position)
		refresh_timer.start(1)
	astar_grid.region = Rect2i(-16, -16, 32, 32)
	astar_grid.cell_size = Vector2(16, 16)
	astar_grid.update()
	
	area.connect("body_entered", body_entered)
	area.connect("body_exited", body_exited)
	despawn_timer.connect("timeout", despawn_timeout)
	refresh_timer.connect("timeout", refresh_timeout)
	despawn_timer.start(10)

func _process(_delta: float) -> void:
	if paths.is_empty(): return
	var current_path: Vector2i = paths.front()
	if World.get_cell_position(vessel.global_position) - _last_cell_position == current_path:
		paths.pop_front()
		return
	var rotation = vessel.rotation - Vector2(current_path).angle() + PI / 2
	if rotation > PI: rotation -= 2*PI
	vessel.angular_direction = - rotation
	# Decide when to stop apply force.
	var x := vessel.linear_velocity.length() / vessel.linear_damp
	var path_global_position = vessel.global_position + Vector2(WorldTiles.TILE_SIZE * current_path)
	if (vessel.global_position.distance_to(WorldTiles.TILE_SIZE * current_path) > x):
		vessel.linear_direction = 1
	
func _vessel_entered(in_vessel: Vessel) -> void:
	if vessel == in_vessel: return
	if target == null and in_vessel.is_hostile_to(vessel):
		target = in_vessel
		despawn_timer.stop()
		refresh_timer.start(1)
	print("Vessel entered")

func _vessel_exited(out_vessel: Vessel) -> void:
	if vessel == out_vessel: return
	if target != null and target == out_vessel:
		target = null
		despawn_timer.start(10)
		refresh_timer.stop()
	print("Vessel exited")
