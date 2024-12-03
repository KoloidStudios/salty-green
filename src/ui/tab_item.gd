extends Control
class_name TabItem

var icon: Texture2D
var label: String
var data: Variant

func _ready() -> void:
	$vertical/icon.texture = icon
	$vertical/label.text = label

func _get_drag_data(at_position: Vector2) -> Variant:
	var texture = TextureRect.new()
	texture.expand = true
	texture.texture = icon
	texture.size = Vector2(64, 64)
	set_drag_preview(texture)
	return data
