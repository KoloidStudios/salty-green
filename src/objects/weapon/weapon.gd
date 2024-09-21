extends Node2D
class_name Weapon

@export var _rotatable_node: Node2D
@export var _projectile: PackedScene

func rotate_to(target: Vector2) -> void:
	_rotatable_node.look_at(target)
	
func fire(target: Vector2) -> void:
	var object: Weapon_projectile = _projectile.instantiate()
	object.position = global_position
	get_viewport().add_child(object)
	object.activate(target)
	
