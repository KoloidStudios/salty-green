extends Node2D
class_name Player

const CAMERA_SCROLL_SPEED: float = 200.0

# Public Members
# Controlled vessel
var world: World = null :
	set(value):
		raycast = RayCast2D.new()
		raycast.target_position = Vector2(0.0, 0.0)
		raycast.hit_from_inside = true
		raycast.enabled = false
		value.add_child(raycast)
var vessel: Vessel = null
var camera: Camera2D = null
var raycast: RayCast2D = null

func update_zoom(amount: float):
	camera.zoom += Vector2(amount, amount)

func _ready() -> void:
	camera = get_viewport().get_camera_2d()
	assert(camera != null, "There's no active camera to control")

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP and event.pressed:
			if camera.zoom.x <= 4.0: update_zoom(0.1)
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN and event.pressed:
			if camera.zoom.x >= 1.0: update_zoom(-0.1)
		if event.button_index == MOUSE_BUTTON_MASK_LEFT and event.pressed:
			if event.ctrl_pressed:
				raycast.enabled = true
				raycast.global_position = get_global_mouse_position()
				raycast.force_raycast_update()
				if raycast.is_colliding():
					var clicked_object = raycast.get_collider()
					if clicked_object is Vessel:
						vessel = clicked_object
				raycast.enabled = false
			elif vessel != null:
				var mouse_position := get_viewport().get_mouse_position()
				for weapon: Weapon in vessel.get_weapons():
					weapon.fire(mouse_position)
	elif event is InputEventMouseMotion:
		if vessel != null and vessel.has_weapon():
			var mouse_position := get_viewport().get_mouse_position()
			for weapon: Weapon in vessel.get_weapons():
				weapon.rotate_to(mouse_position)
	elif event is InputEventKey:
		if event.ctrl_pressed and event.pressed and event.keycode == KEY_X:
			vessel = null
func _physics_process(_delta: float) -> void:
	# Get inputs
	# Directional inputs
	var vert_axis: float = Input.get_axis("down", "up")
	var horz_axis: float = Input.get_axis("left", "right")
	
	if vessel != null:
		camera.position = vessel.position
		vessel.linear_direction = int(vert_axis)
		vessel.angular_direction = int(horz_axis)
	else: #observer mode
		camera.position.x += horz_axis * _delta * CAMERA_SCROLL_SPEED
		camera.position.y += -vert_axis * _delta * CAMERA_SCROLL_SPEED
		
