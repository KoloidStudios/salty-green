@tool
extends World
class_name DynamicWorlds

@export var seed := randi()
var generator := WorldGenerator.new(seed)
var _last_chunk_position := Vector2i.ZERO
const RENDER_DISTANCE = 4#chunks

func _ready() -> void:
	super._ready()
	_render_chunks(_last_chunk_position)

func _render_chunks(chunk_pos: Vector2i) -> void:
	await _tiles.clear()
	for i in range(-RENDER_DISTANCE/2, RENDER_DISTANCE/2 + 1):
		for j in range(-RENDER_DISTANCE/2, RENDER_DISTANCE/2 + 1):
			var pos := chunk_pos + Vector2i(i * Chunk.SIZE, j * Chunk.SIZE)
			if !_tiles.has_chunk(pos):
				_tiles.set_tiles(generator.generate_chunk(pos))

func _process(_delta: float) -> void:
	var _current_chunk_position := Chunk.chunk_position(player.position / WorldTiles.TILE_SIZE)
	if _last_chunk_position != _current_chunk_position:
		_render_chunks(_current_chunk_position)
	_last_chunk_position = _current_chunk_position
