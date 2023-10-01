extends CanvasLayer


@onready var exp_amount_label: Label = $%ExpAmountLabel
@onready var back_button: UISoundButton = $%BackButton

func _ready():
	update_exp_amount_label()
	MetaProgressionManager.meta_currency_amount_changed.connect(update_exp_amount_label)
	back_button.pressed.connect(on_back_button_pressed)





func update_exp_amount_label():
	var currency_amount = floor(MetaProgressionManager.meta_data["meta_currency"])
	exp_amount_label.text = "%d Exp"%currency_amount


func on_back_button_pressed():
	get_tree().change_scene_to_file("res://scenes/ui/main_menu.tscn")
