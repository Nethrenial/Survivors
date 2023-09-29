extends CanvasLayer

var options_menu_scene = preload("res://scenes/ui/options_menu.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	$%StartGameButton.pressed.connect(on_start_game_btn_pressed)
	$%QuitGameButton.pressed.connect(on_quit_game_btn_clicked)
	$%OptionsButton.pressed.connect(on_options_btn_clicked)
	



func on_start_game_btn_pressed():
	get_tree().change_scene_to_file("res://scenes/main/main.tscn")


func on_quit_game_btn_clicked():
	get_tree().quit()

func on_options_btn_clicked():
	var options_menu_instance = options_menu_scene.instantiate()
	add_child(options_menu_instance)
	(options_menu_instance as OptionsMenu).back_button_pressed.connect(on_options_back_button_pressed.bind(options_menu_instance)) 
#	get_tree().change_scene_to_file("res://scenes/ui/options_menu.tscn")

func on_options_back_button_pressed(options_menu_instance: OptionsMenu):
	options_menu_instance.queue_free()