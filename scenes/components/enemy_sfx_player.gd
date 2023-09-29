extends Node
class_name EnemySFXPlayer

func play(type: String):
	if type == "sword_hit":
		$SwordHitSFX.play()
	elif type == "axe_hit":
		$AxeHitSFX.play()
