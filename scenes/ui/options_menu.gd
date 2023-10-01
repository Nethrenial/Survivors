extends CanvasLayer
class_name OptionsMenu

signal  back_button_pressed

@onready var sfx_slider : HSlider = $%SFXSlider
@onready var music_slider : HSlider = $%MusicSlider
@onready var back_button: UISoundButton = $%BackButton
@onready var reset_options_button: UISoundButton = $%ResetOptionsButton
@onready var display_option_button: OptionButton = $%DisplayOptionButton



func _ready():
	back_button.pressed.connect(on_back_btn_pressed)
	reset_options_button.pressed.connect(on_reset_options_button_pressed)
	
	sfx_slider.value_changed.connect(on_sfx_value_changed)
	music_slider.value_changed.connect(on_music_value_changed)
	
	sfx_slider.value = 0.5
#	music_slider.value = 0.5
	
	display_option_button.item_selected.connect(on_display_option_selected)
	update_display()
	


func on_back_btn_pressed():
	back_button_pressed.emit()
#	get_tree().change_scene_to_file("res://scenes/ui/main_menu.tscn")


func on_sfx_value_changed(value: float):
	set_bus_volume("SFX", value)
	pass

func on_music_value_changed(value: float):
	set_bus_volume("Music", value)
	pass

func on_display_option_selected(value: int):
	if value == 0:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	elif value == 1:
		DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)		

	
func update_display():
	if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
		display_option_button.select(0)
	else:
		display_option_button.select(1)
	var sfx_value = get_bus_volume_percent("SFX")
	var music_value = get_bus_volume_percent("Music")
	print("SFX value: ", sfx_value, " Music Value: ", music_value)
	sfx_slider.value = sfx_value
	music_slider.value = music_value

func get_bus_volume_percent(bus_name: String):
	var bus_index = AudioServer.get_bus_index(bus_name)
	var volume_db = AudioServer.get_bus_volume_db(bus_index)
	return db_to_linear(volume_db)
	

func set_bus_volume(bus_name: String, value: float):
	var bus_index = AudioServer.get_bus_index(bus_name)
	var volume_db = linear_to_db(value)
	AudioServer.set_bus_volume_db(bus_index, volume_db)
	update_display()
	
	
func on_reset_options_button_pressed():
	set_bus_volume("SFX", 0.5)
	set_bus_volume("Music", 0.5)
	display_option_button.select(0)
	on_display_option_selected(0)
