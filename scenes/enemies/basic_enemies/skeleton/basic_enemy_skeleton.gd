extends CharacterBody2D

@onready var _animated_sprite = $AnimatedSprite2D

const MAX_SPEED = 75

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
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
	
	velocity = direction * MAX_SPEED
	move_and_slide()


func get_direction_to_player():
	var player = get_tree().get_first_node_in_group("Player Group") as CharacterBody2D
	if(player != null):
		return (player.global_position - global_position).normalized()
	else:
		return Vector2.ZERO
