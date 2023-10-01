extends Node
class_name ExpVialDropComponent


@export_range(0, 1) var base_drop_percent: float = 0.5
@export var health_component: Node
@export var exp_vial_scene: PackedScene

var drop_percent: float

func _ready():
	drop_percent = base_drop_percent + (MetaProgressionManager.get_current_upgrade_count("increase_luck") * 0.2 * base_drop_percent)
	(health_component as HealthComponent).died.connect(on_died)



func on_died():
	
	if randf() > drop_percent:
		owner.queue_free()
		return
		
	
	if exp_vial_scene == null:
		return
	if not owner is CharacterBody2D:
		return
	
	var spawn_position = (owner as BaseEnemy).global_position
	var new_exp_vial = exp_vial_scene.instantiate() as ExpVial
	var entities_layer = get_tree().get_first_node_in_group("entities_layer") as Node2D
	if entities_layer == null:
		return
	entities_layer.add_child(new_exp_vial)
	# Only killing the enemy after dropping the experience vial
	owner.queue_free()
	new_exp_vial.global_position = spawn_position

	
	
