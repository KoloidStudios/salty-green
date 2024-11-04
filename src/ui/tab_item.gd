extends Control
class_name TabItem

var icon: Texture2D
var label: String
var data: Variant

func _ready() -> void:
	$vertical/icon.texture = icon
	$vertical/label.text = label

func _get_drag_data(at_position: Vector2) -> Variant:
	set_drag_preview($vertical/icon)
	return true
