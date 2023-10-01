extends Node

@export var defeat_screen_scene : PackedScene
@onready var player = $Entities/Player_1 as Player_1

func _ready():
	get_tree().paused = false
	(player.health_component as HealthComponent).died.connect(on_player_died)
	$%PauseGameButton.pressed.connect(on_pause_game_button_pressed)
	

func _unhandled_input(event):
	if event.is_action_pressed("pause"):
		show_pause_menu()


func on_player_died():
	var defeat_screen_instance = defeat_screen_scene.instantiate()
	add_child(defeat_screen_instance)
	MetaProgressionManager.save_meta_data_file()


func on_pause_game_button_pressed():
	show_pause_menu()
	
	
	
func show_pause_menu():
	add_child(load("res://scenes/ui/pause_menu.tscn").instantiate())
	get_tree().root.set_input_as_handled()
	
