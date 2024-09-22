extends Node2D
class_name Weapon

@export var _rotatable_node: Node2D
@export var _projectile: PackedScene
@export var _fire_point: Vector2

func rotate_to(target: Vector2) -> void:
	_rotatable_node.look_at(target)
	
func fire(target: Vector2) -> void:
	var object: Weapon_projectile = _projectile.instantiate()
	object.target = target
	object.position = global_position + _fire_point.rotated(global_rotation + get_angle_to(target)) 
	get_viewport().add_child(object)
	
