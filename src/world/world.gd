extends Node
class_name World

class Chunk:
	const SIZE: int = 32 #32x32 tiles per chunk
	var data: PackedByteArray
	var position: Vector2i
	func set_value(cell_pos: Vector2i, value: int) -> void:
		data[cell_pos.y * SIZE + cell_pos.x] = value
	func get_value(cell_pos: Vector2i) -> int:
		return data[cell_pos.y * SIZE + cell_pos.x]
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


static func get_chunk_position(real_position: Vector2) -> Vector2i:
	const CHUNK_PIXEL_SIZE: int = Chunk.SIZE * WorldTiles.TILE_SIZE
	return Vector2i( \
		(int(real_position.x) / (CHUNK_PIXEL_SIZE) - (1 if real_position.x < 0.0 else 0)), \
		(int(real_position.y) / (CHUNK_PIXEL_SIZE) - (1 if real_position.y < 0.0 else 0)) \
	)

static func get_cell_position(real_position: Vector2) -> Vector2i:
	const CELL_PIXEL_SIZE: int = WorldTiles.TILE_SIZE
	return Vector2i( \
		(int(real_position.x) / (CELL_PIXEL_SIZE) - (1 if real_position.x < 0.0 else 0)), \
		(int(real_position.y) / (CELL_PIXEL_SIZE) - (1 if real_position.y < 0.0 else 0)) \
	)

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
