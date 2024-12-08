extends InteractableObject

@onready var lightBulb = $LightBulb

func _interact():
	if lightBulb.visible == false:
		interactPrompt = "Turn off"
		lightBulb.visible = true
	elif lightBulb.visible == true:
		interactPrompt = "Turn on"
		lightBulb.visible = false
