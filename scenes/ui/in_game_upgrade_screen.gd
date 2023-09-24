extends CanvasLayer
class_name  InGameUpgradeScreen

signal upgrade_selected(upgrade: AbilityUpgrade)

@export var ability_upgrade_card_scene: PackedScene
@onready var card_container : HBoxContainer = $%CardContainer

func  _ready():
	get_tree().paused = true

func set_ability_upgrades(upgrades: Array[AbilityUpgrade]):
	for upgrade in upgrades:
		var card_instance = ability_upgrade_card_scene.instantiate()
		card_container.add_child(card_instance)
		(card_instance as AbilityUpgradeCard).set_ability_upgrade(upgrade)
		(card_instance as AbilityUpgradeCard).selected.connect(func ():
			on_upgrade_selected(upgrade, card_instance as AbilityUpgradeCard)
		)
 


func on_upgrade_selected(upgrade: AbilityUpgrade, card: AbilityUpgradeCard):
#	print("Selected upgrade", upgrade)
	upgrade_selected.emit(upgrade)
	queue_free()
	get_tree().paused = false
	
