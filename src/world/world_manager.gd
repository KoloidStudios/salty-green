extends Node2D
class_name WorldManager

# Private members
@export var _debug_world_scene: PackedScene
@export var _viewport: Viewport
@export var _player: Player

# Public members
var world: World = null :
	set(value):
		for child in _viewport.get_children():
			if child is World: _viewport.remove_child(child)
		_viewport.add_child(value)
		_player.inject_player(value)
		world = value

# Godot Functions
func _ready() -> void:
	# Update viewport size on window size changes
	var update_viewport_size := func() -> void:
		_viewport.size = get_viewport_rect().size
		_player.zoom_camera.offset = get_viewport_rect().size / 2
	update_viewport_size.call()
	get_tree().root.connect("size_changed", update_viewport_size)
	
	if OS.is_debug_build():
		world = _debug_world_scene.instantiate()

func spawn_vessel(at_position: Vector2, vessel: Vessel) -> void:
	vessel.position = at_position
	world.add_child(vessel)

func spawn_vessel_at_mouse_position(vessel: Vessel) -> void:
	spawn_vessel(_viewport.get_camera_2d().get_global_mouse_position(), vessel)
