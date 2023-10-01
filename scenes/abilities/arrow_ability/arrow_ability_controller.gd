extends Node


@export var arrow_ability_scene: PackedScene


var base_wait_time : float
var base_additional_damage_percent = 1.0
var calculated_additional_damage_percent = 1.0

var base_range: float = 50
var base_additional_range_percent = 1.0
var calculated_additional_range_percent = 1.0

var arrow_count: int = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	base_wait_time = $Timer.wait_time
	$Timer.timeout.connect(on_timer_timeout)
	GameEvents.ability_upgrades_added.connect(on_ability_upgrade_added)


func on_timer_timeout():
	var player = get_tree().get_first_node_in_group("Player Group") as Player_1
	if player == null:
		return
		
	var foreground = get_tree().get_first_node_in_group("foreground_layer") as Node2D
	if foreground == null:
		return
	
	var player_angle = 0
	
	for i in arrow_count:
		var arrow_instance = arrow_ability_scene.instantiate() as ArrowAbility
		foreground.add_child(arrow_instance)
		arrow_instance.additional_damage_percent = calculated_additional_damage_percent
		arrow_instance.max_radius = arrow_instance.max_radius * calculated_additional_range_percent
		arrow_instance.global_position = player.global_position
		var angle = 0
		if i == 0:
			angle = get_player_angle(player)
			player_angle = angle
		else:
			angle = player_angle + i * deg_to_rad(45)
		arrow_instance.rotate(angle)


func on_ability_upgrade_added(upgrade: Upgrade, current_upgrades: Dictionary): 
#	print(upgrade.id)
	if upgrade.id.begins_with("arrow_count"):
		var count = 0
		if "arrow_count_common" in current_upgrades and "quantity" in current_upgrades["arrow_count_common"]:
			count += current_upgrades["arrow_count_common"]["quantity"] * 1

		if "arrow_count_rare" in current_upgrades:
			count += current_upgrades["arrow_count_rare"]["quantity"] * 2

		if "arrow_count_epic" in current_upgrades:
			count += current_upgrades["arrow_count_epic"]["quantity"] * 4
			
		arrow_count = min(arrow_count + count, 8)

	if upgrade.id.begins_with("arrow_rate"):
		var percent_reduction = 0.0
		if "arrow_rate_common" in current_upgrades and "quantity" in current_upgrades["arrow_rate_common"]:
			percent_reduction += current_upgrades["arrow_rate_common"]["quantity"] * 0.1

		if "arrow_rate_rare" in current_upgrades:
			percent_reduction += current_upgrades["arrow_rate_rare"]["quantity"] * 0.2

		if "arrow_rate_epic" in current_upgrades:
			percent_reduction += current_upgrades["arrow_rate_epic"]["quantity"] * 0.3
			
		$Timer.wait_time = max(base_wait_time * (1 - percent_reduction), 0.2)
		$Timer.start()
		print("New arrow wait time = ", $Timer.wait_time)
	if upgrade.id.begins_with("arrow_damage"):
		var percent_increase = 0.0
		if "arrow_damage_common" in current_upgrades and "quantity" in current_upgrades["arrow_damage_common"]:
			percent_increase += current_upgrades["arrow_damage_common"]["quantity"] * 0.1

		if "arrow_damage_rare" in current_upgrades:
			percent_increase += current_upgrades["arrow_damage_rare"]["quantity"] * 0.2

		if "arrow_damage_epic" in current_upgrades:
			percent_increase += current_upgrades["arrow_damage_epic"]["quantity"] * 0.3
			
		calculated_additional_damage_percent = base_additional_damage_percent * (1 + percent_increase)
#		print("New damage percent is ", calculated_additional_damage_percent)
	if upgrade.id.begins_with("arrow_range"):
		var percent_increase = 0.0
		if "arrow_range_common" in current_upgrades and "quantity" in current_upgrades["arrow_range_common"]:
			percent_increase += current_upgrades["arrow_range_common"]["quantity"] * 0.1

		if "arrow_range_rare" in current_upgrades:
			percent_increase += current_upgrades["arrow_range_rare"]["quantity"] * 0.2

		if "arrow_range_epic" in current_upgrades:
			percent_increase += current_upgrades["arrow_range_epic"]["quantity"] * 0.3
			
		calculated_additional_range_percent = base_additional_range_percent * (1 + percent_increase)
		


func random_angle_in_radians():
	var random_int = randi() % 8  # Generate a random integer between 0 and 7
	var angles = [0, 45, 90, 135, 180, 225, 270, 315]  # List of specified angles in degrees
	var angle_in_degrees = angles[random_int]  # Get the corresponding angle in degrees
	var angle_in_radians = deg_to_rad(angle_in_degrees)  # Convert the angle to radians
	return angle_in_radians


func get_player_angle(player: Player_1):
	var velocity = player.velocity

	# Check if the player is moving (to avoid division by zero)
	if velocity.length_squared() > 0:
		# Normalize the velocity vector to get a unit vector
		var direction = velocity.normalized()

		# Calculate the angle in radians
		var angle_in_radians = atan2(direction.y, direction.x)
		return angle_in_radians

		# 'angle_in_radians' now contains the current movement direction in radians
		# You can use this angle for various purposes in your game
	else:
		return atan2(Vector2.ZERO.y, Vector2.ZERO.x)
