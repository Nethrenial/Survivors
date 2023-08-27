extends BaseEnemy
class_name BasicEnemySkeleton


func _ready():
	# Setup initial values
	max_health = 1.25
	max_speed = 75
	current_health = max_health


func _process(delta):	
	# If dead or hurt, let the death or hurt animation play out
	if is_dead || is_hurt:
		return
	var direction = get_direction_to_player()
	
	if(direction.x > 0):
		_animated_sprite.flip_h = false
		_animated_sprite.play("run")
	elif (direction.x < 0):
		_animated_sprite.flip_h = true
		_animated_sprite.play("run")
		
	if(direction.y > 0):
		_animated_sprite.play("run")
	elif (direction.y < 0):
		_animated_sprite.play("run")
		
	if(direction.x == 0 && direction.y == 0):
		_animated_sprite.play("idle")
	
	velocity = direction * max_speed
	move_and_slide()


func get_direction_to_player():
	var player = get_tree().get_first_node_in_group("Player Group") as CharacterBody2D
	if(player != null):
		return (player.global_position - global_position).normalized()
	else:
		return Vector2.ZERO
