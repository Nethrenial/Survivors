extends Node

@export var basic_enemy_skeleton: PackedScene

const SPAWN_RADIUS = 600

func _ready():
	$Timer.timeout.connect(on_timer_timeout)
	


func on_timer_timeout():
	var player = get_tree().get_first_node_in_group("Player Group") as CharacterBody2D
	if player == null:
		return
	
	var random_direction = Vector2.RIGHT.rotated(randf_range(0, TAU))
	var spawn_position = player.global_position + (random_direction * SPAWN_RADIUS)
#	var random_angle = deg_to_rad(randi_range(0, 7) * 45)
#	var random_direction = Vector2(cos(random_angle), sin(random_angle))
#	var spawn_position = player.global_position + (random_direction * SPAWN_RADIUS)
	
	var basic_enemy_skeleton_instance = basic_enemy_skeleton.instantiate() as CharacterBody2D
	var entities_layer = get_tree().get_first_node_in_group("entities_layer") as Node2D
	if entities_layer == null:
		return
	entities_layer.add_child(basic_enemy_skeleton_instance)
	basic_enemy_skeleton_instance.global_position = spawn_position
	


