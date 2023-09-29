extends Node
class_name LevelTimeManager

const DIFFICULTY_INCREASE_INTERVAL = 5

@export var victory_screen_scene:  PackedScene
@onready var timer = $Timer

signal level_difficulty_increased(difficulty: int)
var level_defficulty = 0

func _ready():
	timer.timeout.connect(on_timer_timeout)

func _process(delta):
	var next_time_target = timer.wait_time - (level_defficulty + 1) * DIFFICULTY_INCREASE_INTERVAL
	if(timer.time_left <= next_time_target):
		level_defficulty += 1
		level_difficulty_increased.emit(level_defficulty)
		

func get_time_elapsed():
	return timer.wait_time - timer.time_left


func on_timer_timeout():
	var victory_screen_instance = victory_screen_scene.instantiate()
	add_child(victory_screen_instance)
