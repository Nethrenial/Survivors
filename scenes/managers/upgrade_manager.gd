extends Node

@export var upgrade_pool: Array[AbilityUpgrade]
@export var experience_manager: ExperienceManager
@export var ingame_upgrade_screen: PackedScene

var current_upgrades = {}

func _ready():
	experience_manager.level_up.connect(on_level_up)
#	ingame_upgrade_screen.upgrade_selected.connect(apply_upgrade)
	
func on_level_up(current_level: int):
	var chosen_upgrade = upgrade_pool.pick_random() as AbilityUpgrade
	if chosen_upgrade == null:
		return
	
	var upgrade_scene = ingame_upgrade_screen.instantiate()
	add_child(upgrade_scene)
	(upgrade_scene as InGameUpgradeScreen).set_ability_upgrades([chosen_upgrade])
	(upgrade_scene as InGameUpgradeScreen).upgrade_selected.connect(on_upgrade_selected)
	
	
func apply_upgrade(upgrade: AbilityUpgrade):
	var has_upgrade = current_upgrades.has(upgrade.id)	
	if !has_upgrade:
		current_upgrades[upgrade.id] = {
			"resource": upgrade,
			"quantity": 1
		}
	else:
		current_upgrades[upgrade.id]["quantity"] += 1
	
	GameEvents.emit_ability_upgrade_added(upgrade, current_upgrades)
	print(current_upgrades)

func on_upgrade_selected(upgrade: AbilityUpgrade):
	apply_upgrade(upgrade)
