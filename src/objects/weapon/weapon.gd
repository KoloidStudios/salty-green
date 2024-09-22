extends Node2D
class_name Weapon

@export var _rotatable_node: Node2D
@export var _projectile: PackedScene
@export var _fire_point: Vector2

func rotate_to(target: Vector2) -> void:
	_rotatable_node.look_at(target)
	
func fire(target: Vector2) -> void:
	if (global_position - target).length() < _fire_point.length():
		return
	var object: Weapon_projectile = _projectile.instantiate()
	object.target = target
	object.position = global_position + _fire_point.rotated(global_rotation + get_angle_to(target)) 
	object.add_to_group(get_groups()[0])
	get_viewport().add_child(object)
	
