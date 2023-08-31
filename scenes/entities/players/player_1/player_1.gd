extends BaseEntity


const MAX_SPEED = 125
const ACCELERATION_SMOOTHING = 25

var prev_angle: float

#@onready var _animated_sprite = $AnimatedSprite2D

func _ready():
	pass


func _process(_delta):
	var movement_vector = get_movement_vector()
	var direction = movement_vector.normalized()
	var angle = rad_to_deg(atan2(direction.y, direction.x)) + 90
	
	if angle == 90 && direction.x > 0:
		prev_angle = angle
		_animated_sprite.play("run_sword_body_090")
	if angle != 0 && angle != -45:
		_animated_sprite.play("run_sword_body_" + "%03d"%angle)
	if angle == -45:
		_animated_sprite.play("run_sword_body_315")
	if angle == 0 && direction.y != 0:
		_animated_sprite.play("run_sword_body_000")
		
	if (direction.x != 0 || direction.y != 0):
		prev_angle = angle
		
	if(direction.x == 0 && direction.y == 0 && prev_angle != null):
		if prev_angle != -45:
			_animated_sprite.play("idle_body_" + "%03d"%prev_angle)
		else:
			_animated_sprite.play("idle_body_315")
	
		
	
	var target_velocity = direction * MAX_SPEED
	velocity = velocity.lerp(target_velocity, 1 - exp(-_delta * ACCELERATION_SMOOTHING))
	move_and_slide()
	
			
	
	
	


func get_movement_vector():
	var x_movement = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	var y_movement = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	return Vector2(x_movement, y_movement)
