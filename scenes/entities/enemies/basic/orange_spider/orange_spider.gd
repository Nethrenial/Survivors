extends BaseEnemy
class_name OrangeSpider

var prev_angle: float

func _ready():
	super._ready()
	# Setup initial values
	max_health = 2.5
	max_speed = 100
	current_health = max_health



func _process(delta):	
	# If dead or hurt, let the death or hurt animation play out
	if is_dead || is_hurt:
		return
	var direction = get_direction_to_player()
	var angle = rad_to_deg(atan2(direction.y, direction.x)) + 90

	if direction.x != 0 || direction.y != 0:
		if angle < 0:
			angle = angle + 360
		var clampedAngle = floor(angle / 45)
		_animated_sprite.play("run_" + str(clampedAngle))
		
	if (direction.x != 0 || direction.y != 0):
		prev_angle = angle
		
	velocity = direction * max_speed
	move_and_slide()


func get_direction_to_player():
	var player = get_tree().get_first_node_in_group("Player Group") as CharacterBody2D
	if(player != null):
		return (player.global_position - global_position).normalized()
	else:
		return Vector2.ZERO
