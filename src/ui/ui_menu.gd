extends Control

func _ready():
	$main.visible = true
	$profile.visible = false
	$options.visible = false
	$achievements.visible = false
	$quit.visible = false

#Play___________________________
func _on_play_pressed():
	$anim.play("play_pressed")
	get_tree().change_scene_to_file("res://src/world/main_world.tscn")
func _on_back_profile_pressed():
	$anim.play_backwards("play_pressed")

#Options________________________
func _on_options_pressed():
	$anim.play("options_pressed")
func _on_back_option_pressed():
	$anim.play_backwards("options_pressed")


#QUIT PANEL
func _on_quit_yes_pressed():
	get_tree().quit()
func _on_quit_no_pressed():
	pass # Replace with function body.
