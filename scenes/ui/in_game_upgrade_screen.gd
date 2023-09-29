extends CanvasLayer
class_name  InGameUpgradeScreen

signal upgrade_selected(upgrade: Upgrade)

@export var ability_upgrade_card_scene: PackedScene
@onready var card_container : HBoxContainer = $%CardContainer

func  _ready():
	get_tree().paused = true

func set_ability_upgrades(upgrades: Array[Upgrade]):
	var delay : float = 0
	for upgrade in upgrades:
		var card_instance = ability_upgrade_card_scene.instantiate()
		card_container.add_child(card_instance)
		
		(card_instance as AbilityUpgradeCard).set_ability_upgrade(upgrade)
		(card_instance as AbilityUpgradeCard).play_in(delay)
		(card_instance as AbilityUpgradeCard).selected.connect(func ():
			on_upgrade_selected(upgrade, card_instance as AbilityUpgradeCard)
		)
		delay += .4
	card_container.force_update_transform()
 


func on_upgrade_selected(upgrade: Upgrade, card: AbilityUpgradeCard):
	print("Selected upgrade", upgrade.id)
	upgrade_selected.emit(upgrade)
	$AnimationPlayer.play("out")
	await $AnimationPlayer.animation_finished
	queue_free()
	get_tree().paused = false
	
