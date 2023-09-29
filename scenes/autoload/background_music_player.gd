extends Node

@onready var current_bg_music: AudioStreamPlayer = $ActionBackgroundMusic

func _ready():
	set_track("action")
	
func set_track(name: String):
	if name == "action":
		current_bg_music = $ActionBackgroundMusic
		current_bg_music.play()

