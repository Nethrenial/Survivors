extends CharacterBody2D

const MAX_SPEED = 200

@onready var _animated_sprite = $AnimatedSprite2D
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var movement_vector = get_movement_vector()
	var direction = movement_vector.normalized()
	
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
	
	


func get_movement_vector():
	var x_movement = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	var y_movement = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	return Vector2(x_movement, y_movement)
