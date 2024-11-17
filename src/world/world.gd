@tool
extends Node
class_name World

class Chunk:
	const SIZE: int = 32 #32x32 tiles per chunk
	var data: PackedByteArray
	var position: Vector2
	# Return base position of a chunk from relative position.
	static func chunk_position(position: Vector2) -> Vector2:
		return Vector2( \
			World.Chunk.SIZE * ((int(position.x) / World.Chunk.SIZE) + int(position.x < 0.0)), \
			World.Chunk.SIZE * ((int(position.y) / World.Chunk.SIZE) + int(position.y < 0.0)) \
		)
	func set_value(pos: Vector2, value: int) -> void:
		data[pos.y * SIZE + pos.x] = value
	func get_value(pos: Vector2) -> int:
		return data[pos.y * SIZE + pos.x]
	func _init() -> void:
		data.resize(SIZE * SIZE)

var _tiles: WorldTiles = preload("res://src/world/world_tiles.tscn").instantiate()
var player: Player

func _ready() -> void:
	add_child(_tiles)
