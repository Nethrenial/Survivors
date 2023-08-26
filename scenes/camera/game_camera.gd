extends Camera2D

var target_posititon = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
	make_current()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	acquire_target()
	global_position = global_position.lerp(target_posititon, 1.0 - exp(-delta * 10))


func acquire_target():
	var player_group = get_tree().get_nodes_in_group('Player Group')
	if (player_group.size() > 0):
		var player = player_group[0] as CharacterBody2D
		target_posititon = player.global_position
