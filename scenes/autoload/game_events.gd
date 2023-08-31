extends Node

# Defining signals
signal experience_orb_collected(number: float)
signal ability_upgrades_added(upgrade: AbilityUpgrade, current_upgrades: Dictionary)


func emit_experience_orb_collected(number: float):
	experience_orb_collected.emit(number)
	
	
func emit_ability_upgrade_added(upgrade: AbilityUpgrade, current_upgrades: Dictionary):
	ability_upgrades_added.emit(upgrade, current_upgrades)
