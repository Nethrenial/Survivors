extends PanelContainer
class_name AbilityUpgradeCard

signal selected()

@onready var upgrade_name_label: Label = $%UpgradeNameLabel
@onready var upgrade_description_label: Label = $%UpgradeDescriptionLabel

var upgrade_id: String


func _ready():
	gui_input.connect(on_gui_input)


func set_ability_upgrade(upgrade: AbilityUpgrade):
	upgrade_name_label.text = upgrade.name
	upgrade_description_label.text = upgrade.description	
	upgrade_id = upgrade.id
	
 
func on_gui_input(input: InputEvent):
	if input.is_action_pressed("left_click"):
		selected.emit()
 
