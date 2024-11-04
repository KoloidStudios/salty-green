extends Node2D
class_name Player

const CAMERA_SCROLL_SPEED: float = 200.0

# Public Members
var zoom_camera: Camera2D
var move_camera: Camera2D

var world: World = null :
	set(value):
		raycast = RayCast2D.new()
		raycast.target_position = Vector2(0.0, 0.0)
		raycast.hit_from_inside = true
		value.add_child(raycast)

# Controlled vessel
var vessel: Vessel = null
var raycast: RayCast2D = null
var hovered_object: Node2D = null

func update_zoom(amount: float):
	zoom_camera.zoom += Vector2(amount, amount)

func _init(zc: Camera2D, mc: Camera2D) -> void:
	zoom_camera = zc
	move_camera = mc

# A bit hardcoding, will fix later
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed:
			match event.button_index:
				MOUSE_BUTTON_WHEEL_UP:
					if zoom_camera.zoom.x <= 4.0: update_zoom(0.1)
				MOUSE_BUTTON_WHEEL_DOWN:
					if zoom_camera.zoom.x >= 1.0: update_zoom(-0.1)
				MOUSE_BUTTON_MASK_LEFT:
					if event.ctrl_pressed:
						if raycast.is_colliding():
							var clicked_object = raycast.get_collider()
							if clicked_object is Vessel:
								vessel = clicked_object
					elif vessel != null:
						var mouse_position := get_viewport().get_mouse_position()
						for weapon: Weapon in vessel.get_weapons():
							weapon.fire(mouse_position)
	elif event is InputEventMouseMotion:
		if vessel != null and vessel.has_weapon():
			var mouse_position := get_viewport().get_mouse_position()
			for weapon: Weapon in vessel.get_weapons():
				weapon.rotate_to(mouse_position)
		if !raycast.is_colliding():
			if hovered_object != null:
				hovered_object.get_animation().stop()
				hovered_object = null
	elif event is InputEventKey:
		match event.keycode:
			KEY_X:
				if event.ctrl_pressed and event.pressed: vessel = null
			KEY_CTRL:
				if event.pressed:
					hovered_object = raycast.get_collider()
					if hovered_object is Vessel and hovered_object != vessel:
						# TODO: Change this with shader soon
						# (using animation is somewhat an overhead, shader is more perfomance friendly)
						hovered_object.get_animation().play("blink")
				else:
					if hovered_object != null:
						hovered_object.get_animation().stop()
						hovered_object = null
func _process(_delta: float) -> void:
	raycast.global_position = get_global_mouse_position()

func _physics_process(_delta: float) -> void:
	# Get inputs
	# Directional inputs
	var vert_axis: float = Input.get_axis("down", "up")
	var horz_axis: float = Input.get_axis("left", "right")
	
	if vessel != null:
		move_camera.offset = vessel.position
		vessel.linear_direction = int(vert_axis)
		vessel.angular_direction = int(horz_axis)
	else: #observer mode
		move_camera.offset.x += horz_axis * _delta * CAMERA_SCROLL_SPEED
		move_camera.offset.y += -vert_axis * _delta * CAMERA_SCROLL_SPEED
		
