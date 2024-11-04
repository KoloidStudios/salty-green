@tool
extends Object
class_name WorldGenerator

# If gdscript feels too slow, i'll turn this to c++
@export var noise: FastNoiseLite = FastNoiseLite.new()

func _init(seed: int) -> void:
	noise.noise_type = FastNoiseLite.TYPE_PERLIN
	noise.seed = seed

func generate_chunk(position: Vector2) -> World.Chunk:
	var chunk := World.Chunk.new();
	chunk.base_position = position
	for y: int in range(World.Chunk.SIZE):
		for x: int in range(World.Chunk.SIZE):
			var land = noise.get_noise_2d(chunk.base_position.x + x, chunk.base_position.y + y) * 10
			chunk.set_value(Vector2(x, y), int(land > 1))
	return chunk
