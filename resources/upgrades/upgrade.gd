extends Resource
class_name Upgrade

enum ABILITY_CATEGORY { COMMON, RARE, EPIC}

@export var id : String
@export var category: ABILITY_CATEGORY = ABILITY_CATEGORY.COMMON
@export var max_quantity: int
@export var name : String
@export_multiline var description: String
@export_file("*.png") var texture: String


