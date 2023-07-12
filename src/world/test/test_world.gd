extends Node2D

@export var test_scene: PackedScene

@onready var test_node   : Node2D      = test_scene.instantiate()
@onready var sub_viewport: SubViewport = $subviewport_container/subviewport
@onready var debug_label : Label       = $debug_ui/label

func _ready() -> void:
	assert(test_node.has_signal("debug_string"))
	test_node.connect("debug_string", _on_debug_string)
	sub_viewport.add_child(test_node)

func _on_debug_string(text: String) -> void:
	debug_label.text = text
