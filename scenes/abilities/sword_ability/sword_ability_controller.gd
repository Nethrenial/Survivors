extends Node

const MAX_RANGE = 150
@export var sword_ability: PackedScene

var sword_ability_instance: Node2D

var base_wait_time : float
var base_additional_damage_percent = 1.0
var calculated_additional_damage_percent = 1.0

# Called when the node enters the scene tree for the first time.
func _ready():
	base_wait_time = $Timer.wait_time
	$Timer.timeout.connect(on_timeout)
	GameEvents.ability_upgrades_added.connect(on_ability_upgrade_added)


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

	sword_ability_instance = sword_ability.instantiate() as Node2D
	var foreground_layer = get_tree().get_first_node_in_group("foreground_layer") as Node2D
	foreground_layer.add_child(sword_ability_instance)	
	(sword_ability_instance as SwordAbility).additional_damage_percent = calculated_additional_damage_percent
	
	sword_ability_instance.global_position = (enemies[0] as CharacterBody2D).global_position	
	var random_position_vector = Vector2.RIGHT.rotated(randf_range(0, TAU)) * 8
	var new_x = sword_ability_instance.global_position.x + random_position_vector.x
	var new_y = sword_ability_instance.global_position.y + random_position_vector.y	
	var new_position_vector = Vector2(new_x, new_y)
	sword_ability_instance.global_position = new_position_vector
	var enemy_direction = (enemies[0] as CharacterBody2D).global_position - sword_ability_instance.global_position
	sword_ability_instance.rotation = enemy_direction.angle()
	


func on_ability_upgrade_added(upgrade: Upgrade, current_upgrades: Dictionary): 
		
	if upgrade.id.begins_with("sword_rate"):
		var percent_reduction = 0.0
		if "sword_rate_common" in current_upgrades and "quantity" in current_upgrades["sword_rate_common"]:
			percent_reduction += current_upgrades["sword_rate_common"]["quantity"] * 0.1

		if "sword_rate_rare" in current_upgrades:
			percent_reduction += current_upgrades["sword_rate_rare"]["quantity"] * 0.2

		if "sword_rate_epic" in current_upgrades:
			percent_reduction += current_upgrades["sword_rate_epic"]["quantity"] * 0.3
			
		$Timer.wait_time = max(base_wait_time * (1 - percent_reduction), 0.5)
		$Timer.start()
	if upgrade.id.begins_with("sword_damage"):
		var percent_increase = 0.0
		if "sword_damage_common" in current_upgrades and "quantity" in current_upgrades["sword_damage_common"]:
			percent_increase += current_upgrades["sword_damage_common"]["quantity"] * 0.1

		if "sword_damage_rare" in current_upgrades:
			percent_increase += current_upgrades["sword_damage_rare"]["quantity"] * 0.2

		if "sword_damage_epic" in current_upgrades:
			percent_increase += current_upgrades["sword_damage_epic"]["quantity"] * 0.3
			
		calculated_additional_damage_percent = base_additional_damage_percent * (1 + percent_increase)
#		print("New damage percent is ", calculated_additional_damage_percent)
		
