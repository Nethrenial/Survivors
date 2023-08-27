extends Node

# Defining signals
signal experience_orb_collected(number: float)


func emit_experience_orb_collected(number: float):
	experience_orb_collected.emit(number)
	
	
