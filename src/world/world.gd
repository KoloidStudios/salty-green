@tool
extends Node
class_name World

class Chunk:
	const SIZE: int = 32 #32x32 tiles per chunk
	var data: PackedByteArray
	var base_position: Vector2
	# Make the position chunked
	static func chunk_position(position: Vector2) -> Vector2:
		return Vector2( \
			SIZE * ((int(position.x) / SIZE) + int(position.x < 0.0)), \
			SIZE * ((int(position.y) / SIZE) + int(position.y < 0.0)) \
		)
	func set_value(pos: Vector2, value: int) -> void:
		data[pos.y * SIZE + pos.x] = value
	func get_value(pos: Vector2) -> int:
		return data[pos.y * SIZE + pos.x]
	func _init() -> void:
		data.resize(SIZE * SIZE)

const RENDER_DISTANCE := 16 #chunks

var tiles: WorldTiles = preload("res://src/world/world_tiles.tscn").instantiate()

func _ready() -> void:
	add_child(tiles)
