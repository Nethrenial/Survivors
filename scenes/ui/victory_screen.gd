extends CanvasLayer


func _ready():
	get_tree().paused = true
	$AudioStreamPlayer.play()
	$%RestartButton.pressed.connect(on_restart_button_pressed)
	$%QuitButton.pressed.connect(on_quit_button_pressed)
	


func _process(delta):
	pass
	
func on_restart_button_pressed():
#	return
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/main/main.tscn")
	
	
func on_quit_button_pressed():
#	return
	get_tree().quit()
	
