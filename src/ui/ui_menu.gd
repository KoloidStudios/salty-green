extends Control

func _ready():
	$main.visible = true
	$profile.visible = false
	$options.visible = false
	$achievements.visible = false
	$quit.visible = false

func _on_play_pressed():
	$anim.play("play_pressed")

#QUIT PANEL
func _on_quit_yes_pressed():
	get_tree().quit()

func _on_quit_no_pressed():
	pass # Replace with function body.

func _on_back_pressed():
	$anim.play_backwards("play_pressed")
