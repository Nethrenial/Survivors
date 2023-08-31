extends Node

@export var basic_krampus: PackedScene

const SPAWN_RADIUS = 600

func _ready():
	$Timer.timeout.connect(on_timer_timeout)
	


func on_timer_timeout():
	var player = get_tree().get_first_node_in_group("Player Group") as CharacterBody2D
	if player == null:
		return
	
	var random_direction = Vector2.RIGHT.rotated(randf_range(0, TAU))
	var spawn_position = player.global_position + (random_direction * SPAWN_RADIUS)
	var basic_krampus_instance = basic_krampus.instantiate() as CharacterBody2D
	var entities_layer = get_tree().get_first_node_in_group("entities_layer") as Node2D
	if entities_layer == null:
		return
	entities_layer.add_child(basic_krampus_instance)
	basic_krampus_instance.global_position = spawn_position
	


