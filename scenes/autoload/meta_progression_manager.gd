extends Node

signal meta_currency_amount_changed

var meta_upgrades_pool: Array[Resource] = [
	load("res://resources/meta-upgrades/increase_luck.tres"),
	load("res://resources/meta-upgrades/increase_movement_speed.tres"),	
	load("res://resources/meta-upgrades/increase_health.tres")		
]

const META_DATE_FILE_PATH = "user://meta-data.save"


var current_level_currency : int = 0

var meta_data: Dictionary = {
	"meta_currency": 0,
	"meta_upgrades": {
		"increase_luck": {
			"quantity": 0,
			"initial_upgrade_cost": get_initial_upgrade_cost("increase_luck"),
			"upgrade_cost_increment": get_upgrade_cost_increment("increase_luck")
		},
		"increase_movement_speed": {
			"quantity": 0,
			"initial_upgrade_cost": get_initial_upgrade_cost("increase_movement_speed"),
			"upgrade_cost_increment": get_upgrade_cost_increment("increase_movement_speed")
		},
		"increase_health": {
			"quantity": 0,
			"initial_upgrade_cost": get_initial_upgrade_cost("increase_health"),
			"upgrade_cost_increment": get_upgrade_cost_increment("increase_health")
		}
	}
}

func _ready():
	load_meta_data_file()
	GameEvents.exp_vial_collected.connect(on_exp_vial_collected)


func add_upgrade(upgrade: MetaUpgrade):
	var upgrade_cost = get_next_upgrade_cost(upgrade.id)
	if meta_data["meta_currency"] < upgrade_cost:
		return
	if not meta_data["meta_upgrades"].has(upgrade.id):
		meta_data["meta_upgrades"][upgrade.id] = {
			"quantity": 0,
			"initial_upgrade_cost": get_initial_upgrade_cost(upgrade.id),
			"upgrade_cost_increment": get_upgrade_cost_increment(upgrade.id)
		}
	if meta_data["meta_upgrades"][upgrade.id]["quantity"] < upgrade.max_quantity: 
		meta_data["meta_upgrades"][upgrade.id]["quantity"] += 1
		meta_data["meta_currency"] -= upgrade_cost
		meta_currency_amount_changed.emit()
		save_meta_data_file()
	
func reset_upgrade(upgrade: MetaUpgrade):
	var quantity = get_current_upgrade_count(upgrade.id)
	var initial_cost = get_initial_upgrade_cost(upgrade.id)
	var full_cost = 0
	for i in quantity:
		full_cost = full_cost + (initial_cost + (i * initial_cost))
	meta_data["meta_upgrades"][upgrade.id]["quantity"] = 0
	meta_data["meta_currency"] += full_cost 
	meta_currency_amount_changed.emit()
	save_meta_data_file()
	
func on_exp_vial_collected(number: float):
	current_level_currency += 1 
	meta_data["meta_currency"] += 0.5
	meta_currency_amount_changed.emit()
	save_meta_data_file()
	


func load_meta_data_file():
	if not FileAccess.file_exists(META_DATE_FILE_PATH):
		var file = FileAccess.open(META_DATE_FILE_PATH, FileAccess.WRITE)
		file.store_var(meta_data)
		return
	var file = FileAccess.open(META_DATE_FILE_PATH, FileAccess.READ)
	meta_data = file.get_var()	
	
func save_meta_data_file():
	var file =FileAccess.open(META_DATE_FILE_PATH, FileAccess.WRITE)
	file.store_var(meta_data)	


func save_currency_after_player_win():
	meta_data["meta_currency"] += current_level_currency
	current_level_currency = 0
	meta_currency_amount_changed.emit()
	save_meta_data_file()


func get_initial_upgrade_cost(id: String):
	var upgrade : MetaUpgrade = get_upgrade_by_id(id)
	if upgrade == null:
		return 0;
	return upgrade.initial_upgrade_cost
	
func get_upgrade_cost_increment(id: String):
	var upgrade : MetaUpgrade = get_upgrade_by_id(id)
	if upgrade == null:
		return 0;
	return upgrade.upgrade_cost_increment
	
	
	
func get_upgrade_by_id(id: String):
#	print(meta_upgrades_pool)
	for upgrade in meta_upgrades_pool:
		if (upgrade as MetaUpgrade).id == id:
			return upgrade
	return null



func get_next_upgrade_cost(id: String):
	var upgrade = meta_data["meta_upgrades"][id]
	if upgrade == null:
		return 0;
	print(upgrade)
	return upgrade["initial_upgrade_cost"] + (upgrade["upgrade_cost_increment"] * upgrade["quantity"])

func get_current_upgrade_count(id: String):
	var upgrade = meta_data["meta_upgrades"][id]
	if upgrade == null:
		return 0;
	return upgrade["quantity"]
	
func get_remaining_currency():
	return meta_data["meta_currency"]
	

func get_upgrade_pecentage(id: String):
	var upgrade = meta_data["meta_upgrades"][id]
	if upgrade == null:
		return 0;
	return upgrade["quantity"] * 0.1
	

