extends CanvasLayer


@onready var resume_game_button: UISoundButton = $%ResumeGameButton
@onready var options_button: UISoundButton = $%OptionsButton
@onready var quit_to_menu_button: UISoundButton = $%QuitToMenuButton


func _ready():
	get_tree().paused = true
	resume_game_button.pressed.connect(on_resume_game_button_pressed)
	quit_to_menu_button.pressed.connect(on_quit_to_menu_button_pressed)
	options_button.pressed.connect(on_options_button_pressed)


func _unhandled_input(event):
	if event.is_action_pressed("pause"):
		on_resume_game_button_pressed()
		get_tree().root.set_input_as_handled()

func on_resume_game_button_pressed():
	get_tree().paused = false
	queue_free()

func on_options_button_pressed():
	var options_menu_screen_instance = load("res://scenes/ui/options_menu.tscn").instantiate()
	add_child(options_menu_screen_instance)
	(options_menu_screen_instance as OptionsMenu).back_button_pressed.connect(on_options_menu_back_button_pressed.bind(options_menu_screen_instance))
	
func on_quit_to_menu_button_pressed():
#	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/ui/main_menu.tscn")
	
func on_options_menu_back_button_pressed(options_menu: OptionsMenu):
	options_menu.queue_free()
