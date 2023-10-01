extends BaseAbility
class_name WarAxeAbility

var max_radius = 100
@onready var hitbox_component = $HitboxComponent as HitboxComponent

var base_rotation = Vector2.RIGHT

func _ready():
	damage = 0.25
	base_rotation = Vector2.RIGHT.rotated(randf_range(0, TAU))
	var tween = create_tween()
	tween.tween_method(tween_method,0.0, 2.0, 3)
	tween.tween_callback(queue_free)


func tween_method(rotations: float):
	var current_radius = (rotations / 2) * max_radius
	var current_direction = base_rotation.rotated(rotations * TAU)
	
	var player = get_tree().get_first_node_in_group("Player Group") as Player_1
	if player == null:
		return
	
	global_position = player.global_position + current_direction * current_radius
