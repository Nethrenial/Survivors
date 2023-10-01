extends Resource
class_name  MetaUpgrade

@export var id: String
@export var max_quantity: int = 1
@export var initial_upgrade_cost: int = 100
@export var upgrade_cost_increment: int = 100
@export var title: String
@export_multiline var description: String
@export_file("*.png") var texture: String
