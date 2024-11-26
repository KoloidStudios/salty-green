extends Node2D
class_name WorldTiles

const TILE_SIZE: int = 16#px
var _layers: Array[TileMapLayer]
var _chunks: Array[World.Chunk]
var _add_pool: Array[World.Chunk]
var _remove_pool: Array[World.Chunk]

func _ready() -> void:
	_layers.append($layer0)

func has_chunk(chunk_position: Vector2i) -> bool:
	for chunk: World.Chunk in _chunks:
		if chunk.position == chunk_position:
			return true
	return false

func get_chunks() -> Array[World.Chunk]:
	return _chunks

func defer_add(chunk: World.Chunk) -> void:
	_add_pool.append(chunk)

func defer_remove(chunk: World.Chunk) -> void:
	_remove_pool.append(chunk)

func apply_chunk(chunk: World.Chunk) -> void:
	for y: int in range(World.Chunk.SIZE):
		for x: int in range(World.Chunk.SIZE):
			var data_pos := Vector2i(x, y)
			var cell_pos := data_pos + chunk.position
			_layers[0].set_cell(cell_pos, 1, Vector2(chunk.get_value(data_pos), 0))

func erase_chunk(chunk: World.Chunk) -> void:
	for y: int in range(World.Chunk.SIZE):
		for x: int in range(World.Chunk.SIZE):
			var data_pos := Vector2i(x, y)
			var cell_pos := data_pos + chunk.position
			_layers[0].erase_cell(cell_pos)

func update() -> void:
	print(_remove_pool.size(), " ", _add_pool.size(), " ", _chunks.size())
	# Cache invalidation is a hard thing in programming.
	# So i separate this loop
	for chunk: World.Chunk in _remove_pool:
		erase_chunk(chunk)
		_chunks.erase(chunk)
	_remove_pool.clear()
	for chunk: World.Chunk in _add_pool:
		_chunks.append(chunk)
		apply_chunk(chunk)
	_add_pool.clear()
