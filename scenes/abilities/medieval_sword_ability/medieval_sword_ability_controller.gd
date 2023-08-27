extends Node

const MAX_RANGE = 150
@export var medieval_sword_ability: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	$Timer.timeout.connect(on_timeout)


func on_timeout():
	var player = get_tree().get_first_node_in_group("Player Group") as CharacterBody2D
	if player == null:
		return
	
	var enemies : Array[Node] = get_tree().get_nodes_in_group("Enemies Group")
	enemies = enemies.filter(func(enemy: CharacterBody2D):
		return enemy.global_position.distance_squared_to(player.global_position) < pow(MAX_RANGE, 2)
	)
	
	
	if enemies.size() == 0:
		return
		
	enemies.sort_custom(func (enemy_a: CharacterBody2D, enemy_b: CharacterBody2D):
			var enemy_a_distance = enemy_a.global_position.distance_squared_to(player.global_position)
			var enemy_b_distance = enemy_b.global_position.distance_squared_to(player.global_position)
			return enemy_a_distance < enemy_b_distance			
	)

	var medieval_sword_ability_instance = medieval_sword_ability.instantiate() as Node2D
	player.get_parent().add_child(medieval_sword_ability_instance)	
	
	medieval_sword_ability_instance.global_position = (enemies[0] as CharacterBody2D).global_position	
	var random_position_vector = Vector2.RIGHT.rotated(randf_range(0, TAU)) * 8
	var new_x = medieval_sword_ability_instance.global_position.x + random_position_vector.x
	var new_y = medieval_sword_ability_instance.global_position.y + random_position_vector.y	
	var new_position_vector = Vector2(new_x, new_y)
	medieval_sword_ability_instance.global_position = new_position_vector
	var enemy_direction = (enemies[0] as CharacterBody2D).global_position - medieval_sword_ability_instance.global_position
	medieval_sword_ability_instance.rotation = enemy_direction.angle()
	
