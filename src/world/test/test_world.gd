extends Node2D

@export var test_scene: PackedScene

@onready var test_node   : Node2D       = test_scene.instantiate()
@onready var sub_viewport: Sub_viewport = $sub_viewport
@onready var debug_label : Label        = $ui/debug_ui/label

func _ready() -> void:
	# Debug purposes
	assert(test_node.has_signal("debug_string"))
	test_node.connect("debug_string", _on_debug_string)

	sub_viewport.set_world(test_node)

func _on_debug_string(text: String) -> void:
	debug_label.text = text
