extends RayCast3D

@onready var interactPromptLabel : Label = $Label

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var object = get_collider()
	interactPromptLabel.text = ""
	
	if object and object is InteractableObject:
		if object.canInteract == false:
			return
			
		interactPromptLabel.text = "[E]" + object.interactPrompt
		
		if Input.is_action_just_pressed("interact"):
			object._interact()
