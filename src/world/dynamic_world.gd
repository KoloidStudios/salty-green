extends World
class_name DynamicWorlds

@export var seed := randi()
var _mutex := Mutex.new()
var _thread := Thread.new()
var _semaphore := Semaphore.new()
var _generator := WorldGenerator.new(seed)
var _chunk_update := false
var _is_terminating := false
var _last_chunk_position := Vector2i.ZERO
const RENDER_DISTANCE = 3#chunks

func _ready() -> void:
	super._ready()
	_thread.start(_generate_chunks)
	_semaphore.post()

func _generate_chunks() -> void:
	while true:
		_semaphore.wait()
		if _is_terminating: break
		_mutex.lock()
		var chunks := _tiles.get_chunks()
		var current_chunk_pos := _last_chunk_position

		for chunk: Chunk in chunks:
			var difference: Vector2i = (chunk.position - _last_chunk_position) / Chunk.SIZE
			if abs(difference.x) > RENDER_DISTANCE or abs(difference.y) > RENDER_DISTANCE:
				_tiles.defer_remove(chunk)

		for i in range(-RENDER_DISTANCE, RENDER_DISTANCE):
			for j in range(-RENDER_DISTANCE, RENDER_DISTANCE):
				var pos := current_chunk_pos + Vector2i(i * Chunk.SIZE, j * Chunk.SIZE)
				if !_tiles.has_chunk(pos):
					var new_chunk := _generator.get_chunk(pos)
					_tiles.defer_add(new_chunk)
		_chunk_update = true
		_mutex.unlock()

func _get_chunk_position(player_position: Vector2) -> Vector2i:
	const CHUNK_PIXEL_SIZE: int = Chunk.SIZE * WorldTiles.TILE_SIZE
	return Vector2i( \
		Chunk.SIZE * (int(player.position.x) / (CHUNK_PIXEL_SIZE) - (1 if player.position.x < 0.0 else 0)), \
		Chunk.SIZE * (int(player.position.y) / (CHUNK_PIXEL_SIZE) - (1 if player.position.y < 0.0 else 0)) \
	)

func _process(_delta: float) -> void:
	var _current_chunk_position := _get_chunk_position(player.position)
	if _last_chunk_position != _current_chunk_position:
		_last_chunk_position = _current_chunk_position
		_semaphore.post()
	if _chunk_update:
		_mutex.lock()
		_tiles.update()
		_chunk_update = false
		_mutex.unlock()

func _exit_tree() -> void:
	_is_terminating = true
	_semaphore.post()
	_thread.wait_to_finish()
