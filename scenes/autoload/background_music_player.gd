extends Node

@onready var current_bg_music: AudioStreamPlayer = $ActionBackgroundMusic

func _ready():
	set_track("action")
	var bus_index = AudioServer.get_bus_index("Music")
	var volume_db = linear_to_db(0.5)
	AudioServer.set_bus_volume_db(bus_index, volume_db)
	
func set_track(track_name: String):
	if track_name == "action":
		current_bg_music = $ActionBackgroundMusic
		current_bg_music.play()

