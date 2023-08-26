extends Node

const MAX_RANGE = 150
@export var medieval_sword_ability: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	$Timer.timeout.connect(on_timeout)


func on_timeout():
	
	var enemies = get_tree().get_nodes_in_group("Enemies Group")
	if enemies.size() == 0:
		return

	var medieval_sword_ability_instance = medieval_sword_ability.instantiate() as Node2D
#	player.get_parent().add_child(medieval_sword_ability_instance)
#	medieval_sword_ability_instance.global_position = player.global_position
	
