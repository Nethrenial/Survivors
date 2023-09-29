extends Button
class_name UISoundButton

func _ready():
	pressed.connect(on_pressed)


func on_pressed():
	($UIAudioPlayer as UIAudioPlayer).play("button-click")
