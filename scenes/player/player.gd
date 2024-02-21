extends CharacterBody2D

@onready var animator = $AnimationPlayer

@export var speed : float = 150.0
@export var jump_velocity : float = -300.0
@export var acceleration : float = 15.0
@export var friction : float = 1.25
var face_right : bool = true

enum state {IDLE, RUN, JUMP, FALL, HIT}
var anim_state = state.IDLE

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("moveLeft", "moveRight")
	if direction:
		face_right = true
		#velocity.x = direction * speed
		velocity.x = move_toward(velocity.x, direction * speed, acceleration)
	else:
		face_right = false
		velocity.x = move_toward(velocity.x, 0, acceleration / friction)
		
	if face_right == false:
		print(face_right)
		$Idle.flip_h = false
	else:
		print(face_right)
		$Idle.flip_h = true
		
	

	move_and_slide()
