extends Node2D
class_name WorldManager

# Private members
@export var _debug_world_scene: PackedScene
@export var _viewport: Viewport
@export var _player: Player

var _is_debug := OS.is_debug_build() :
	set(value):
		_is_debug = value
		$debug_interface.visible = value

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

	# TODO: Move this to debug_interface.gd
	# Instantiate debug items
	var tab_item_scene := preload("res://src/ui/tab_item.tscn")
	for vessel: Vessel in Modules.vessels:
		var tab_item: TabItem = tab_item_scene.instantiate()
		tab_item.icon = vessel.icon
		tab_item.label = vessel.name
		$debug_interface/modules_list/vessels.add_child(tab_item)
	for weapon: Weapon in Modules.weapons:
		var tab_item: TabItem = tab_item_scene.instantiate()
		tab_item.icon = weapon.icon
		tab_item.label = weapon.name
		$debug_interface/modules_list/weapons.add_child(tab_item)

func _input(event: InputEvent) -> void:
	if event is InputEventAction:
		if event.is_action("toggle_debug"):
			_is_debug = !_is_debug

func _process(_delta: float) -> void:
	if _is_debug:
		$debug_interface/label.text = "Debug Information:\n"
		if _player.vessel != null:
			var vessel: Vessel = _player.vessel
			$debug_interface/label.text += \
				"Vessel.position: ({0}, {1})\n".format([vessel.position.x, vessel.position.y]) + \
				"Vessel.speed: {0} px\\s".format([vessel.get_speed()])
