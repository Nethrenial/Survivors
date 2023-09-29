extends Node2D
class_name  ExpVial
@onready var collision_shape = $Area2D/CollisionShape2D
func _ready():
	$Area2D.area_entered.connect(on_area_entered)
	
	
func on_area_entered(other_area: Area2D):
	Callable(disable_collision).call_deferred()
	var player = get_tree().get_first_node_in_group("Player Group") as Player_1
	if player == null:
		return
	var tween_time = map_vector_difference(global_position, player.global_position)
	var tween = create_tween()
	tween.tween_method(tween_collect.bind(global_position, player), 0.0, 1.0, tween_time)\
	.set_ease(Tween.EASE_IN)
	tween.tween_callback(collect)
	$CollectSFX.play()
	


func tween_collect(percent: float, start_positoin: Vector2, player: Player_1):
	if player == null:
		return
	global_position = start_positoin.lerp(player.global_position, percent)
	

func collect():
	GameEvents.emit_exp_vial_collected(1)
	queue_free()
	
	
func disable_collision():
	collision_shape.disabled = true	
	
	
func map_vector_difference(vector1: Vector2, vector2: Vector2):
	var diff = vector2 - vector1
	var length = diff.length()
	return length / (length + 1)
