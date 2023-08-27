extends Node2D
class_name  ExperienceOrb

func _ready():
	$Area2D.area_entered.connect(on_area_entered)
	
	
func on_area_entered(other_area: Area2D):
	GameEvents.emit_experience_orb_collected(1)
	queue_free()

