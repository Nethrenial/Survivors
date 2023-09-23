extends Node

@export var defeat_screen_scene : PackedScene
@onready var player = $Entities/Player_1 as Player_1

func _ready():
	(player.health_component as HealthComponent).died.connect(on_player_died)
	


func on_player_died():
	print("Player died")
	var defeat_screen_instance = defeat_screen_scene.instantiate()
	add_child(defeat_screen_instance)
