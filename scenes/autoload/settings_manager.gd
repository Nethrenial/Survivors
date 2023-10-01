extends Node

const SETTINGS_DATA_FILE_PATH = "user://settings-data.save"

var settings_data: Dictionary = {
	"sfx_volume": 0.5,
	"music_volume": 0.5,
	"window_mode": 0
}

func _ready():
	load_settings_data_file()


func set_audio_setting(key: String, value: float):
	settings_data[key] = value
	save_settings_data_file()

func set_window_setting(value: int):
	settings_data["window_mode"] = value
	save_settings_data_file()

	
func load_settings_data_file():
	if not FileAccess.file_exists(SETTINGS_DATA_FILE_PATH):
		var file = FileAccess.open(SETTINGS_DATA_FILE_PATH, FileAccess.WRITE)
		file.store_var(settings_data)
		return
	var file = FileAccess.open(SETTINGS_DATA_FILE_PATH, FileAccess.READ)
	settings_data = file.get_var()	
	
func save_settings_data_file():
	var file =FileAccess.open(SETTINGS_DATA_FILE_PATH, FileAccess.WRITE)
	file.store_var(settings_data)	

