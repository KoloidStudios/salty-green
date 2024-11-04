@tool
extends EditorScript

func execute(fn: Callable) -> void:
	print("Executing: ", fn)
	fn.call()

func test_chunk_generation() -> void:
	var generator := WorldGenerator.new(randi())
	var chunk := generator.generate_chunk(Vector2.ZERO)
	assert(chunk.data.size() == World.Chunk.SIZE * World.Chunk.SIZE)

# Called when the script is executed (using File -> Run in Script Editor).
func _run() -> void:
	execute(test_chunk_generation)
