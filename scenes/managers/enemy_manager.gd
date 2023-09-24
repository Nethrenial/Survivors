extends Node

@export var basic_orc: PackedScene
@export var level_time_mananer: LevelTimeManager
@onready var timer = $Timer as Timer

const SPAWN_RADIUS = 600

func _ready():
	timer.timeout.connect(on_timer_timeout)
	level_time_mananer.level_difficulty_increased.connect(on_level_difficulty_increased)
	
	
	
func get_spawn_position():
	var player = get_tree().get_first_node_in_group("Player Group") as CharacterBody2D
	if player == null:
		return Vector2.ZERO
	
	var spawn_position = Vector2.ZERO
	var random_direction = Vector2.RIGHT.rotated(randf_range(0, TAU))	
	for i in 10:
		spawn_position = player.global_position + (random_direction * SPAWN_RADIUS)
		var query_parameters = PhysicsRayQueryParameters2D.create(player.global_position, spawn_position, 1)
		var result = get_tree().root.world_2d.direct_space_state.intersect_ray(query_parameters)
		
		if result.is_empty():
			break
		else:
			random_direction = random_direction.rotated(deg_to_rad(90))
	
	return spawn_position
	
func on_timer_timeout():
	timer.start()
	var player = get_tree().get_first_node_in_group("Player Group") as CharacterBody2D
	if player == null:
		return
	
	
	var basic_orc_instance = basic_orc.instantiate() as CharacterBody2D
	var entities_layer = get_tree().get_first_node_in_group("entities_layer") as Node2D
	if entities_layer == null:
		return
	entities_layer.add_child(basic_orc_instance)
	basic_orc_instance.global_position = get_spawn_position()
	

func on_level_difficulty_increased(difficulty: int):
	var time_off = (0.1/12) * difficulty
	timer.wait_time = max(0.1, timer.wait_time - time_off)
#	print("New wait time: ", timer.wait_time)

