extends CanvasLayer

@export var level_time_manager : Node
@onready var label = %Label


func _process(delta):
	if level_time_manager == null:
		return
	var time_elapsed: float = level_time_manager.get_time_elapsed()
	label.text = format_seconds_to_string(time_elapsed)


func format_seconds_to_string(seconds: float):
	var minutes = floor(seconds/60)
	var extra_seconds = floor(seconds - (minutes*60))
	return "%02d"%minutes + ":" + "%02d"%extra_seconds
