extends Node
class_name UIAudioPlayer

func play(type: String):
	if type == "button":
		$ButtonClickAudio.play()
