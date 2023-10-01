extends PanelContainer
class_name MetaUpgradeCard


@export var meta_upgrade: MetaUpgrade
@export var meta_upgrade_cell: PackedScene

@onready var upgrade_name_label: Label = $%UpgradeNameLabel
@onready var upgrade_description_label: Label = $%UpgradeDescriptionLabel

@onready var buy_upgrade_button: UISoundButton = $%BuyUpgradeButton
@onready var reset_upgrade_button: UISoundButton = $%ResetUpgradeButton
@onready var upgrade_cells_container: HBoxContainer = $%UpgradeCellsContainer

var upgrade_id: String
var disabled = false
var current_upgrade_count: int = 0
var remaining_currency: int = 0

func _ready():
	update_buy_upgrade_button_text()
	$%UpgradeNameLabel.text = meta_upgrade.title
	$%UpgradeDescriptionLabel.text = meta_upgrade.description
	$%TextureRect.texture = load(meta_upgrade.texture)
	buy_upgrade_button.pressed.connect(on_buy_upgrade_button_pressed)
	reset_upgrade_button.pressed.connect(on_reset_upgrade_btn_pressed)
	MetaProgressionManager.meta_currency_amount_changed.connect(on_currency_amount_changed)


func on_currency_amount_changed():
#	print("Currency amount changed from ", meta_upgrade.id)
	update_buy_upgrade_button_text()

func set_meta_upgrade(upgrade: Upgrade):
	upgrade_name_label.text = upgrade.name
	upgrade_description_label.text = upgrade.description	
	upgrade_id = upgrade.id
	$%TextureRect.texture = load(upgrade.texture)
	
	
func on_reset_upgrade_btn_pressed():
		MetaProgressionManager.reset_upgrade(meta_upgrade)
		update_buy_upgrade_button_text()


func on_buy_upgrade_button_pressed():
	MetaProgressionManager.add_upgrade(meta_upgrade)
	update_buy_upgrade_button_text()


func update_buy_upgrade_button_text():
	var next_upgrade_cost = MetaProgressionManager.get_next_upgrade_cost(meta_upgrade.id)
	current_upgrade_count = MetaProgressionManager.get_current_upgrade_count(meta_upgrade.id)
	remaining_currency= MetaProgressionManager.get_remaining_currency()

	
	if current_upgrade_count == meta_upgrade.max_quantity:
		buy_upgrade_button.text = "Limit Reached"	
		buy_upgrade_button.disabled = true
	else:
		if (remaining_currency < next_upgrade_cost):
			buy_upgrade_button.text = "%d Exp needed"%next_upgrade_cost									
			buy_upgrade_button.disabled = true
		else:
			buy_upgrade_button.text = "Spend %d Exp"%next_upgrade_cost			
			buy_upgrade_button.add_theme_color_override("font_color", Color.WHITE)
			buy_upgrade_button.disabled = false
	update_upgrade_indicators()
	

func update_upgrade_indicators():
	remove_upgrade_indicators()
	for i in meta_upgrade.max_quantity:
		var meta_upgrade_cell_instance = meta_upgrade_cell.instantiate() as MetaUpgradeCell			
		upgrade_cells_container.add_child(meta_upgrade_cell_instance)
		if i <= current_upgrade_count - 1:
			meta_upgrade_cell_instance.set_as_filled()
		

	
func remove_upgrade_indicators():
	for child in upgrade_cells_container.get_children():
		upgrade_cells_container.remove_child(child)
		child.queue_free()
