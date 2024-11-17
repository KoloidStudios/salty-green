@tool
extends Node2D
class_name WorldTiles

var layers: Array[TileMapLayer]

func _ready() -> void:
	layers.append($layer0)

func set_tiles(chunk: World.Chunk) -> void:
	for y: int in range(World.Chunk.SIZE):
		for x: int in range(World.Chunk.SIZE):
			var data_pos := Vector2(x, y)
			var cell_pos := data_pos + chunk.position
			layers[0].set_cell(cell_pos, 1, Vector2(chunk.get_value(data_pos), 0))
