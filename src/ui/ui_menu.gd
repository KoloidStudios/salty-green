extends Control

func _ready():
	$main.visible = true
	$profile.visible = false
	$options.visible = false
	$achievements.visible = false
	$quit.visible = false

func _on_play_pressed():
	$anim.play("play_pressed")
