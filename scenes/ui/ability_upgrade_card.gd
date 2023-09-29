extends PanelContainer
class_name AbilityUpgradeCard

signal selected()

@onready var upgrade_name_label: Label = $%UpgradeNameLabel
@onready var upgrade_description_label: Label = $%UpgradeDescriptionLabel

var upgrade_id: String
var disabled = false

func _ready():
	gui_input.connect(on_gui_input)
	mouse_entered.connect(on_mouse_entered)

func play_in(delay: float = 0):
	modulate = Color.TRANSPARENT
	await get_tree().create_timer(delay).timeout
	$AnimationPlayer.play("in")
	
func play_discard():
	$AnimationPlayer.play("discarded")

func set_ability_upgrade(upgrade: Upgrade):
	upgrade_name_label.text = upgrade.name
	upgrade_description_label.text = upgrade.description	
	upgrade_id = upgrade.id
	$%TextureRect.texture = load(upgrade.texture)
	

func select_card():
	disabled = true
	$AnimationPlayer.play("selected")
	for other_card in get_tree().get_nodes_in_group("upgrade_cards"):
		if other_card == self:
			continue
		else:
			(other_card as AbilityUpgradeCard).play_discard()
	await $AnimationPlayer.animation_finished
	selected.emit()	

 
func on_gui_input(input: InputEvent):
	if disabled:
		return
	if input.is_action_pressed("left_click"):
		select_card()

 
func on_mouse_entered():
	if disabled:
		return
	$HoverAnimationPlayer.play("hover")
