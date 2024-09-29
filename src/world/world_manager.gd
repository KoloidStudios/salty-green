extends Node2D
class_name World_manager

# Private members
@export var _debug_world_scene: PackedScene
var _is_debug := OS.is_debug_build() :
	set(value):
		_is_debug = value
		$debug_interface.visible = value

# Public members
var world: World = null :
	set(value):
		var viewport := $viewport_container/world_viewport
		if viewport.get_child_count() != 0:
			for child in viewport.get_children():
				viewport.remove_child(child)
		viewport.add_child(value)
		$player.world = value
		world = value

func _update_viewport_size() -> void:
	$viewport_container.size = get_viewport_rect().size

# Godot Functions
func _ready() -> void:
	_update_viewport_size()
	get_tree().root.connect("size_changed", _update_viewport_size)
	
	if OS.is_debug_build():
		world = _debug_world_scene.instantiate()

	# Instantiate debug items
	var scene := preload("res://src/ui/tab_item.tscn")
	for vessel: Vessel in Modules.vessels:
		var tab_item: Tab_item = scene.instantiate()
		tab_item.icon = vessel.icon
		tab_item.label = vessel.name
		$debug_interface/modules_list/vessels.add_child(tab_item)
	for weapon: Weapon in Modules.weapons:
		var tab_item: Tab_item = scene.instantiate()
		tab_item.icon = weapon.icon
		tab_item.label = weapon.name
		$debug_interface/modules_list/weapons.add_child(tab_item)
		

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("toggle_debug"):
		_is_debug = !_is_debug

	if _is_debug:
		$debug_interface/label.text = "Debug Information:\n"
		if $player.vessel != null:
			var vessel: Vessel = $player.vessel
			$debug_interface/label.text += \
				"Vessel.position: ({0}, {1})\n".format([vessel.position.x, vessel.position.y]) + \
				"Vessel.speed: {0} px\\s".format([vessel.get_speed()])
