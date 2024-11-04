@tool
extends World
class_name DynamicWorlds

@export var seed := randi()
var generator := WorldGenerator.new(seed)

func _ready() -> void:
	super._ready()
	for i in range(8):
		for j in range(8):
			var vec := Vector2(i * World.Chunk.SIZE, j * World.Chunk.SIZE)
			tiles.set_tiles(generator.generate_chunk(vec))
	print("generated")
