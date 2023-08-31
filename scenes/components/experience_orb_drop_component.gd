extends Node
class_name ExperienceOrbDropComponent


@export_range(0, 1) var drop_percent: float = 0.9
@export var health_component: Node
@export var experience_orb_scene: PackedScene

func _ready():
	(health_component as HealthComponent).died.connect(on_died)



func on_died():
	
	if randf() > drop_percent:
		owner.queue_free()
		return
		
	
	if experience_orb_scene == null:
		return
	if not owner is CharacterBody2D:
		return
	
	var spawn_position = (owner as BaseEnemy).global_position
	var new_experience_orb = experience_orb_scene.instantiate() as ExperienceOrb
	var entities_layer = get_tree().get_first_node_in_group("entities_layer") as Node2D
	if entities_layer == null:
		return
	entities_layer.add_child(new_experience_orb)
	# Only killing the enemy after dropping the experience orb
	owner.queue_free()
	new_experience_orb.global_position = spawn_position

	
	
