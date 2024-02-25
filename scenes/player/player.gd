extends CharacterBody2D

@onready var animator = $AnimatedSprite2D

@export var speed : float = 150.0
@export var jump_velocity : float = -300.0
@export var acceleration : float = 15.0
@export var friction : float = 1.25

enum state {IDLE, RUN, JUMP, FALL, HIT}
var anim_state = state.IDLE

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	pass

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	# Get the input direction and handle the movement/deceleration.
	var direction: float = Input.get_axis("moveLeft", "moveRight")

	handle_jump()
	handle_movement(direction)
	update_player_state()
	update_player_animation(direction)
	move_and_slide()


func handle_jump():
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity

func handle_movement(direction):
	if direction:
		#velocity.x = direction * speed
		velocity.x = move_toward(velocity.x, direction * speed, acceleration)
	else:
		velocity.x = move_toward(velocity.x, 0, acceleration / friction)

func player_is_hit():
	print('ouch')
	
func update_player_state():
	anim_state = state.IDLE
	
	if velocity.x > 0 || velocity.x < 0:
		anim_state = state.RUN
		
	if velocity.y > 0:
		anim_state = state.FALL
		
	if velocity.y < 0:
		anim_state = state.JUMP


func update_player_animation(direction):
	if direction > 0:
		animator.flip_h = false
	elif direction < 0:
		animator.flip_h = true
	match anim_state:
		state.IDLE:
			animator.play("idle")
		state.RUN:
			animator.play("run")
		state.FALL:
			animator.play("fall")
		state.JUMP:
			animator.play("jump")
  
