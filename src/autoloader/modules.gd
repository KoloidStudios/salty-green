extends Node

var vessels: Dictionary[String, Vessel]
var weapons: Dictionary[String, Weapon]

func load_module(path: String, type: String, dict: Dictionary) -> void:
	assert(path.ends_with("/"), "Path must ends with ")
	var dir := DirAccess.open(path)
	if DirAccess.get_open_error() != OK:
		push_error("Module path not found")
	for filename: String in dir.get_files():
		print("Opening: ", path + filename)
		var object: Object = load(path + filename).instantiate()
		if object.get_script().get_global_name() == type:
			print("Opening Success")
			dict[filename.split(".")[0]] = object
		else:
			print("Can't open as ", type, " for type: ", object.get_script().get_global_name())
func _ready() -> void:
	print("Loading modules")
	load_module("res://src/objects/vessel/models/", "Vessel", vessels)
	load_module("res://src/objects/weapon/models/", "Weapon", weapons)
