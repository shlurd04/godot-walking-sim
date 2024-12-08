class_name InteractableObject
extends Node

@export var interactPrompt : String
@export var canInteract : bool = true

func _interact():
	print("Override this function")
