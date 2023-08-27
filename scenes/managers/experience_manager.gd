extends Node

var current_experience: float = 0

func _ready():
	GameEvents.experience_orb_collected.connect(on_experience_vial_collected)

func increment_experience(by: float):
	current_experience += by
	print("Current experience is ", current_experience)


func on_experience_vial_collected(number: float):
	increment_experience(number)
