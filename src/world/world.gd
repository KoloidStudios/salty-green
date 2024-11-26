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
var player: Player

func _ready() -> void:
	add_child(_tiles)
