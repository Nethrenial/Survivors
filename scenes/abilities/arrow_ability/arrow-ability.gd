extends BaseAbility
class_name ArrowAbility

var max_radius = 10
var current_radius = 0
var speed = 10  # Adjust this speed as needed

func _ready():
	damage = 5

func _process(delta):
	# Calculate the direction vector based on the current rotation angle
	var direction = Vector2(cos(rotation), sin(rotation))

	# Normalize the direction vector to have a length of 1
	direction = direction.normalized()

	# Increment the current_radius
	current_radius += speed * delta

	# Calculate the new position based on the current_radius and direction
	var new_position = position + direction * current_radius

	# Update the position of the node
	position = new_position

	# Check if the node has reached or exceeded the max_radius
	if current_radius >= max_radius:
		queue_free()
