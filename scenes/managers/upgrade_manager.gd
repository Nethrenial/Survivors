extends Node

@export var upgrade_pool: Array[AbilityUpgrade]
@export var experience_manager: ExperienceManager
@export var ingame_upgrade_screen: PackedScene

var current_upgrades = {}

func _ready():
	experience_manager.level_up.connect(on_level_up)
#	ingame_upgrade_screen.upgrade_selected.connect(apply_upgrade)
	

	
func apply_upgrade(upgrade: AbilityUpgrade):
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
			upgrade_pool = upgrade_pool.filter(func (pool_upgrade: AbilityUpgrade): return pool_upgrade.id != upgrade.id)
	
	GameEvents.emit_ability_upgrade_added(upgrade, current_upgrades)
#	print(current_upgrades)

func pick_upgrades():
	print(upgrade_pool)
	var filtered_upgrades = upgrade_pool.duplicate()
	var chosen_upgrades: Array[AbilityUpgrade] = []
	for i in 2:
		if(filtered_upgrades.is_empty()):
			break
		var chosen_upgrade = filtered_upgrades.pick_random() as AbilityUpgrade
		if chosen_upgrade == null:
			break
		chosen_upgrades.append(chosen_upgrade)
		filtered_upgrades = filtered_upgrades.filter(func (upgrade: AbilityUpgrade): return upgrade.id != chosen_upgrade.id)
	return chosen_upgrades	


func on_upgrade_selected(upgrade: AbilityUpgrade):
	apply_upgrade(upgrade)

func on_level_up(current_level: int):

	var chosen_upgrades = pick_upgrades()	
	var upgrade_scene = ingame_upgrade_screen.instantiate()
	add_child(upgrade_scene)
	(upgrade_scene as InGameUpgradeScreen).set_ability_upgrades(chosen_upgrades)
	(upgrade_scene as InGameUpgradeScreen).upgrade_selected.connect(on_upgrade_selected)
	
