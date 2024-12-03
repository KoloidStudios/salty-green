extends CanvasLayer

@export var player: Player

var _is_debug := OS.is_debug_build() :
	set(value):
		_is_debug = value
		self.visible = value

func _fill_tab(tab_bar: TabBar, items: Array) -> void:
	var tab_item_scene := preload("res://src/ui/tab_item.tscn")
	for item in items:
		var tab_item: TabItem = tab_item_scene.instantiate()
		tab_item.icon = item.icon
		tab_item.label = item.name
		tab_item.data = item
		tab_bar.add_child(tab_item)

func _ready() -> void:
	# Instantiate debug items
	_fill_tab(%vessels, Modules.vessels)
	_fill_tab(%weapons, Modules.weapons)

func _input(event: InputEvent) -> void:
	if event is InputEventAction:
		if event.is_action("toggle_debug"):
			_is_debug = !_is_debug

func _process(_delta: float) -> void:
	if _is_debug:
		%label.text = "Debug Information:\n"
		if player.vessel != null:
			var vessel: Vessel = player.vessel
			%label.text += \
				"Vessel.position: ({0}, {1})\n".format([vessel.position.x / WorldTiles.TILE_SIZE, vessel.position.y / WorldTiles.TILE_SIZE]) + \
				"Vessel.speed: {0} px\\s".format([vessel.get_speed()])
		else:
			%label.text += \
				"Player.position: ({0}, {1})\n".format([floor(player.position.x / WorldTiles.TILE_SIZE), floor(player.position.y / WorldTiles.TILE_SIZE)])
