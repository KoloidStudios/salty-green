extends Node2D
class_name Sub_viewport

@onready var sv_container := get_node("sv_container") as SubViewportContainer
@onready var sub_viewport := get_node("sv_container/sub_viewport") as SubViewport
@onready var viewport_cam := sub_viewport.get_camera_2d()

@onready var camera := get_node("camera") as Camera2D

func _set_viewport_size() -> void:
	sv_container.size = get_viewport_rect().size

func _ready() -> void:
	get_tree().root.connect("size_changed", _set_viewport_size)

func set_world(world: Node2D) -> void:
	if sub_viewport.get_child_count() != 0:
		for child in sub_viewport.get_children():
			sub_viewport.remove_child(child)
	sub_viewport.add_child(world)
	viewport_cam = sub_viewport.get_camera_2d()
