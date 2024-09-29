extends Node2D
class_name Weapon

@export var rotatable_node: Node2D
@export var projectile: PackedScene
@export var fire_point: Vector2
@export var icon: Texture2D

func rotate_to(target: Vector2) -> void:
	if rotatable_node != null:
		rotatable_node.look_at(target)
	
func fire(target: Vector2) -> void:
	if (global_position - target).length() < fire_point.length():
		return
	var object: Weapon_projectile = projectile.instantiate()
	object.target = target
	object.position = global_position + fire_point.rotated(global_rotation + get_angle_to(target)) 
	object.add_to_group(get_groups()[0])
	get_viewport().add_child(object)
	
