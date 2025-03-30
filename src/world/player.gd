extends Node2D
class_name Player

const CAMERA_SCROLL_SPEED: float = 200.0

# Public Members
@export var zoom_camera: Camera2D
@export var move_camera: Camera2D
@export var cursor: TextureRect

signal vessel_entered(in_vessel: Vessel)
signal vessel_exited(out_vessel: Vessel)

# Controlled vessel
var vessel: Vessel = null :
	set(value):
		if value != null:
			emit_signal("vessel_entered", value)
		elif vessel != null: 
			emit_signal("vessel_exited", vessel)
		else: assert(false)
		vessel = value
var raycast: RayCast2D = RayCast2D.new()
var hovered_object: Node2D = null

func inject_player(world: World) -> void:
	raycast.target_position = Vector2(0.0, 0.0)
	raycast.hit_from_inside = true
	world.add_child(raycast)
	world.player = self

func update_zoom(amount: float):
	zoom_camera.zoom += Vector2(amount, amount)

# A bit hardcoding, will fix later
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed:
			match event.button_index:
				MOUSE_BUTTON_WHEEL_UP:
					if zoom_camera.zoom.x < 3.9: update_zoom(0.1)
				MOUSE_BUTTON_WHEEL_DOWN:
					if zoom_camera.zoom.x > 1.1: update_zoom(-0.1)
				MOUSE_BUTTON_MASK_LEFT:
					if event.ctrl_pressed:
						if raycast.is_colliding():
							var clicked_object = raycast.get_collider()
							if clicked_object is Vessel and !(clicked_object as Vessel).is_controlled:
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
					if hovered_object is Vessel and hovered_object != vessel and !(hovered_object as Vessel).is_controlled:
						# TODO: Change this with shader soon
						# (using animation is somewhat an overhead, shader is more perfomance friendly)
						hovered_object.get_animation().play("blink")
				else:
					if hovered_object != null:
						hovered_object.get_animation().stop()
						hovered_object = null

func _on_vessel_entered(in_vessel: Vessel) -> void:
	move_camera.position_smoothing_enabled = true
	cursor.visible = false
	in_vessel.is_controlled = true

func _on_vessel_exited(out_vessel: Vessel) -> void:
	move_camera.position_smoothing_enabled = false
	cursor.visible = true
	out_vessel.is_controlled = false

func _process(_delta: float) -> void:
	raycast.global_position = get_global_mouse_position()

func _physics_process(_delta: float) -> void:
	# Get inputs
	# Directional inputs
	var vert_axis: float = Input.get_axis("down", "up")
	var horz_axis: float = Input.get_axis("left", "right")
	
	if vessel != null:
		move_camera.position = vessel.position
		vessel.linear_direction = int(vert_axis)
		vessel.angular_direction = int(horz_axis)
	else: #observer mode
		move_camera.position.x += horz_axis * _delta * CAMERA_SCROLL_SPEED
		move_camera.position.y += -vert_axis * _delta * CAMERA_SCROLL_SPEED
		
	position = move_camera.position
