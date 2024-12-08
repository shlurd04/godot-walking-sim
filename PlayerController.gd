class_name PlayerController
extends CharacterBody3D

@export_group("Movement")
@export var maxSpeed : float = 4.0
@export var Acceleration : float = 20
@export var Breaking : float = 20
@export var airAcceleration : float = 4
@export var jumpForce : float = 5
@export var gravityModifier : float = 1.5
@export var maxRunSpeed : float = 10
var isRunning : bool = false

@export_group("Camera")
@export var lookSensitivity : float = 0.005
var cameraLookInput : Vector2

@onready var Camera : Camera3D = $Camera3D
@onready var Gravity : float = ProjectSettings.get_setting("physics/3d/default_gravity") * gravityModifier

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _physics_process(delta: float) -> void:
	#Apply Gravity
	if not is_on_floor():
		velocity.y -= Gravity * delta
	
	#Jumping
	if Input.is_action_pressed("jump") and is_on_floor():
		velocity.y = jumpForce
	
	#Movement
	var moveInput = Input.get_vector("left", "right", "fwd", "bwd")
	var moveDirection = (transform.basis * Vector3(moveInput.x, 0, moveInput.y)).normalized()
	
	isRunning = Input.is_action_pressed("sprint")
	var targetSpeed = maxSpeed
	
	if isRunning:
		targetSpeed = maxRunSpeed
		
	var currentSmoothing = Acceleration
	
	if not is_on_floor():
		currentSmoothing = airAcceleration
	elif not moveDirection:
		currentSmoothing = Breaking
		
	var targetVelocity = moveDirection * targetSpeed
	
	velocity.x = lerp(velocity.x, targetVelocity.x, currentSmoothing * delta)
	velocity.z = lerp(velocity.z, targetVelocity.z, currentSmoothing * delta)
	
	move_and_slide()
	
	#Camera Look
	rotate_y(-cameraLookInput.x * lookSensitivity)
	Camera.rotation.x = clamp(Camera.rotation.x, -1.5, 1.5)
	Camera.rotate_x(-cameraLookInput.y * lookSensitivity)
	cameraLookInput = Vector2.ZERO
	
	#Mouse
	if Input.is_action_just_pressed("ui_cancel"):
		if Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		cameraLookInput = event.relative
