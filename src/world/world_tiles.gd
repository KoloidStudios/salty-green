@tool
extends Node2D
class_name WorldTiles

const TILE_SIZE: int = 16#px
var layers: Array[TileMapLayer]

func _ready() -> void:
	layers.append($layer0)

func clear() -> void:
	for layer: TileMapLayer in layers:
		layer.clear()

func has_chunk(chunk_base_position: Vector2i) -> bool:
	for layer: TileMapLayer in layers:
		return layer.get_used_cells().has(chunk_base_position)
	return false

func set_tiles(chunk: World.Chunk) -> void:
	for y: int in range(World.Chunk.SIZE):
		for x: int in range(World.Chunk.SIZE):
			var data_pos := Vector2i(x, y)
			var cell_pos := data_pos + chunk.position
			layers[0].set_cell(cell_pos, 1, Vector2(chunk.get_value(data_pos), 0))
