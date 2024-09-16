extends Node2D
class_name World_viewport

@onready var sv_container := get_node("sv_container") as SubViewportContainer
@onready var sub_viewport := get_node("sv_container/sub_viewport") as SubViewport
@onready var camera       := get_node("camera") as Camera2D
@onready var current_world: World = null

func _set_viewport_size() -> void:
	sv_container.size = get_viewport_rect().size

func set_world(world: World) -> void:
	if sub_viewport.get_child_count() != 0:
		for child in sub_viewport.get_children():
			sub_viewport.remove_child(child)
	sub_viewport.add_child(world)
	current_world = world

func update_zoom(amount: float):
	camera.zoom += Vector2(amount, amount)

func _ready() -> void:
	get_tree().root.connect("size_changed", _set_viewport_size)
	_set_viewport_size()
	
func _process(_delta: float):
	camera.offset = current_world.focus_node.position

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP and event.pressed:
			if camera.zoom.x <= 3.0: update_zoom(0.1)
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN and event.pressed:
			if camera.zoom.x >= 1.0: update_zoom(-0.1)
