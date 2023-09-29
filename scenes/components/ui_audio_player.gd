extends Node
class_name UIAudioPlayer

func play(type: String, volume: float = 0):
	print("type = ", type, " volume = ", volume)
	if type == "button-click":
		$ButtonClickAudio.play()
	elif type == "upgrade-click":
		$UpgradeClickAudio.volume_db = volume
		$UpgradeClickAudio.play()
	elif type == "upgrade-hover":
		$UpgradeHoverAudio.volume_db = volume		
		$UpgradeHoverAudio.play()
