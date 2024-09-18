extends Node2D

@export var world_scene: PackedScene

# Private members
@onready var _is_debug := OS.is_debug_build()

# Public members
@onready var world: World = null

# Godot Functions
func _ready() -> void:
	$ui/debug_ui.visible = _is_debug
	
	world = world_scene.instantiate()
	$world_viewport.set_world(world)
	
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("toggle_debug"):
		_is_debug = !_is_debug
		$ui/debug_ui.visible = _is_debug

	if _is_debug:
		$ui/debug_ui/label.text = "Debug Information:\n"
		if world.focus_node and world.focus_node is Player:
			var player: Player = world.focus_node
			$ui/debug_ui/label.text += \
				"Player.position: ({0}, {1})\n".format([player.position.x, player.position.y]) + \
				"Player.speed: {0} px\\s".format([player.get_speed()])
