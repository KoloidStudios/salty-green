extends Node2D

@export var test_scene: PackedScene

@onready var test_node   : Node2D      = test_scene.instantiate()
@onready var sub_viewport: SubViewport = $subviewport_container/subviewport
@onready var sub_viewport_container: SubViewportContainer = $subviewport_container
@onready var debug_label : Label       = $debug_ui/label

func _set_svc_size() -> void:
	#sub_viewport_container.scale = get_viewport_rect().size
	pass

func _ready() -> void:
	assert(test_node.has_signal("debug_string"))
	test_node.connect("debug_string", _on_debug_string)
	sub_viewport.add_child(test_node)
	_set_svc_size()
	get_tree().root.connect("size_changed", _set_svc_size)

func _on_debug_string(text: String) -> void:
	debug_label.text = text
