extends Node

@export var experience_manager: ExperienceManager
@export var ingame_upgrade_screen: PackedScene

var current_upgrades = {}
var upgrade_pool: WeightedTable = WeightedTable.new()


var axe_activate_upgrade = preload("res://resources/upgrades/axe_activate.tres")
var axe_damage_common_upgrade = preload("res://resources/upgrades/axe_damage_common.tres")
var axe_damage_rare_upgrade = preload("res://resources/upgrades/axe_damage_rare.tres")
var axe_damage_epic_upgrade = preload("res://resources/upgrades/axe_damage_epic.tres")
var axe_rate_common_upgrade = preload("res://resources/upgrades/axe_rate_common.tres")
var axe_rate_rare_upgrade = preload("res://resources/upgrades/axe_rate_rare.tres")
var axe_rate_epic_upgrade = preload("res://resources/upgrades/axe_rate_epic.tres")

var sword_rate_common_upgrade = preload("res://resources/upgrades/sword_rate_common.tres")
var sword_rate_rare_upgrade = preload("res://resources/upgrades/sword_rate_rare.tres")
var sword_rate_epic_upgrade = preload("res://resources/upgrades/sword_rate_epic.tres")

var sword_damage_common_upgrade = preload("res://resources/upgrades/sword_damage_common.tres")
var sword_damage_rare_upgrade = preload("res://resources/upgrades/sword_damage_rare.tres")
var sword_damage_epic_upgrade = preload("res://resources/upgrades/sword_damage_epic.tres")

var player_move_speed_common_upgrade = preload("res://resources/upgrades/player_move_speed_common.tres")
var player_move_speed_rare_upgrade = preload("res://resources/upgrades/player_move_speed_rare.tres")
var player_move_speed_epic_upgrade = preload("res://resources/upgrades/player_move_speed_epic.tres")



func _ready():
	upgrade_pool.add_item(axe_activate_upgrade, 10)
##
#	upgrade_pool.add_item(sword_rate_common_upgrade, 10)
#	upgrade_pool.add_item(sword_rate_rare_upgrade, 10)
#	upgrade_pool.add_item(sword_rate_epic_upgrade, 10)	
#	upgrade_pool.add_item(sword_damage_common_upgrade, 10)
#	upgrade_pool.add_item(sword_damage_rare_upgrade, 10)
#	upgrade_pool.add_item(sword_damage_epic_upgrade, 10)
	
#	upgrade_pool.add_item(player_move_speed_common_upgrade, 10)
#	upgrade_pool.add_item(player_move_speed_rare_upgrade, 10)
#	upgrade_pool.add_item(player_move_speed_epic_upgrade, 10)
	
	print("Upgrades pool", upgrade_pool)
	
	
	experience_manager.level_up.connect(on_level_up)
#	ingame_upgrade_screen.upgrade_selected.connect(apply_upgrade)
	


func update_upgrade_pool(chosen_upgrade: Upgrade):
	if chosen_upgrade.id == axe_activate_upgrade.id:
		upgrade_pool.add_item(axe_damage_common_upgrade, 30)
		upgrade_pool.add_item(axe_damage_rare_upgrade, 20)
		upgrade_pool.add_item(axe_damage_epic_upgrade, 10)
		upgrade_pool.add_item(axe_rate_common_upgrade, 30)
		upgrade_pool.add_item(axe_rate_rare_upgrade, 20)
		upgrade_pool.add_item(axe_rate_epic_upgrade, 10)
	
	
func apply_upgrade(upgrade: Upgrade):
	var has_upgrade = current_upgrades.has(upgrade.id)	
	if !has_upgrade:
		current_upgrades[upgrade.id] = {
			"resource": upgrade,
			"quantity": 1
		}
	else:
		current_upgrades[upgrade.id]["quantity"] += 1
	
	if(upgrade.max_quantity > 0):
		var current_quantity = current_upgrades[upgrade.id]["quantity"]
		if current_quantity == upgrade.max_quantity:
			upgrade_pool.remove_item(upgrade)
	
	update_upgrade_pool(upgrade)
	GameEvents.emit_ability_upgrade_added(upgrade, current_upgrades)
#	print(current_upgrades)

func pick_upgrades():
	var chosen_upgrades: Array[Upgrade] = []
	for i in 3:
		if upgrade_pool.items.size() == chosen_upgrades.size():
			break
		var chosen_upgrade = upgrade_pool.pick_item(chosen_upgrades) as Upgrade
		chosen_upgrades.append(chosen_upgrade)
	return chosen_upgrades	


func on_upgrade_selected(upgrade: Upgrade):
	apply_upgrade(upgrade)

func on_level_up(current_level: int):

	var chosen_upgrades = pick_upgrades()
	if not chosen_upgrades.is_empty():	
		var upgrade_scene = ingame_upgrade_screen.instantiate()
		add_child(upgrade_scene)
		(upgrade_scene as InGameUpgradeScreen).set_ability_upgrades(chosen_upgrades)
		(upgrade_scene as InGameUpgradeScreen).upgrade_selected.connect(on_upgrade_selected)
	
