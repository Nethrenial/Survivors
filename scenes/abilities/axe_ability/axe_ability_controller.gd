extends Node

@export var axe_ability_scene: PackedScene


var base_wait_time : float
var base_additional_damage_percent = 1.0
var calculated_additional_damage_percent = 1.0

# Called when the node enters the scene tree for the first time.
func _ready():
	base_wait_time = $Timer.wait_time
	$Timer.timeout.connect(on_timer_timeout)
	GameEvents.ability_upgrades_added.connect(on_ability_upgrade_added)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func on_timer_timeout():
	var player = get_tree().get_first_node_in_group("Player Group") as Player_1
	if player == null:
		return
	var foreground = get_tree().get_first_node_in_group("foreground_layer") as Node2D
	if foreground == null:
		return
	var axe_instance = axe_ability_scene.instantiate() as Node2D
	foreground.add_child(axe_instance)
	(axe_instance as BaseAbility).additional_damage_percent = calculated_additional_damage_percent
	axe_instance.global_position = player.global_position


func on_ability_upgrade_added(upgrade: Upgrade, current_upgrades: Dictionary): 
#	print(upgrade.id)
	if upgrade.id.begins_with("axe_rate"):
		var percent_reduction = 0.0
		if "axe_rate_common" in current_upgrades and "quantity" in current_upgrades["axe_rate_common"]:
			percent_reduction += current_upgrades["axe_rate_common"]["quantity"] * 0.1

		if "axe_rate_rare" in current_upgrades:
			percent_reduction += current_upgrades["axe_rate_rare"]["quantity"] * 0.2

		if "axe_rate_epic" in current_upgrades:
			percent_reduction += current_upgrades["axe_rate_epic"]["quantity"] * 0.3
			
		$Timer.wait_time = max(base_wait_time * (1 - percent_reduction), 0.5)
		$Timer.start()
	if upgrade.id.begins_with("axe_damage"):
		var percent_increase = 0.0
		if "axe_damage_common" in current_upgrades and "quantity" in current_upgrades["axe_damage_common"]:
			percent_increase += current_upgrades["axe_damage_common"]["quantity"] * 0.1

		if "axe_damage_rare" in current_upgrades:
			percent_increase += current_upgrades["axe_damage_rare"]["quantity"] * 0.2

		if "axe_damage_epic" in current_upgrades:
			percent_increase += current_upgrades["axe_damage_epic"]["quantity"] * 0.3
			
		calculated_additional_damage_percent = base_additional_damage_percent * (1 + percent_increase)
#		print("New damage percent is ", calculated_additional_damage_percent)
		
