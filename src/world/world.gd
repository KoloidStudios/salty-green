extends Node
class_name World

class Chunk:
	const SIZE: int = 32 #32x32 tiles per chunk
	var data: PackedByteArray
	var position: Vector2i
	func set_value(pos: Vector2i, value: int) -> void:
		data[pos.y * SIZE + pos.x] = value
	func get_value(pos: Vector2i) -> int:
		return data[pos.y * SIZE + pos.x]
	func _init() -> void:
		data.resize(SIZE * SIZE)

var _tiles: WorldTiles = preload("res://src/world/world_tiles.tscn").instantiate()
var _timer := Timer.new()
var player: Player

var peaceful_mode: bool = false

func _ready() -> void:
	add_child(_tiles)
	add_child(_timer)
	_timer.start(15.0)
	_timer.connect("timeout", _spawn_pirate)

const PIRATE_SPAWN_DISTANCE = 20 * Utility.METER_TO_PIXEL
func _spawn_pirate() -> void:
	if player.vessel != null and !peaceful_mode:
		var player_pos := player.position
		var pirate_pos := Vector2.ZERO
		var angle := randf_range(0.0, 2 * PI)
		pirate_pos = player_pos \
			+ Vector2(PIRATE_SPAWN_DISTANCE * cos(angle), PIRATE_SPAWN_DISTANCE * sin(angle))
		if _tiles.is_water(pirate_pos):
			var vessel = Modules.vessels["boat"].duplicate()
			var pirate = preload("res://src/world/pirate.tscn").instantiate()
			pirate.vessel = vessel
			spawn_vessel(pirate_pos, vessel)
			print("Pirate spawned")
	_timer.start(15.0)

func spawn_vessel(at_position: Vector2, vessel: Vessel) -> void:
	vessel.position = at_position
	add_child(vessel)
