extends Node

@export var orc: PackedScene
@export var orange_spider: PackedScene
@export var blue_spider: PackedScene
@export var reptile_warrior: PackedScene
@export var killer_butterfly: PackedScene

@export var level_time_mananer: LevelTimeManager
@onready var timer = $Timer as Timer

const SPAWN_RADIUS = 640


var enemy_table = WeightedTable.new()

func _ready():
	enemy_table.add_item(orange_spider, 20)
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
		var addition_check_offset = random_direction * 50
		var query_parameters = PhysicsRayQueryParameters2D.create(player.global_position, spawn_position + addition_check_offset, 1)
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
	
	var enemy_scene = enemy_table.pick_item()
	var enemy_instance = enemy_scene.instantiate() as BaseEnemy
	var entities_layer = get_tree().get_first_node_in_group("entities_layer") as Node2D
	if entities_layer == null:
		return
	entities_layer.add_child(enemy_instance)
	enemy_instance.global_position = get_spawn_position()
	

func on_level_difficulty_increased(difficulty: int):
#	print("Difficulty is ", difficulty)
	var time_off = (0.1/12) * difficulty
	timer.wait_time = max(0.5, timer.wait_time - time_off)
#	print("New wait time: ", timer.wait_time)

	if difficulty == 3:
		enemy_table.add_item(blue_spider, 20)

	if difficulty == 6:
		enemy_table.add_item(orc, 20)
	
	if difficulty == 9:
		enemy_table.add_item(reptile_warrior, 20)
	
	if difficulty == 12:
		enemy_table.add_item(killer_butterfly, 20)

