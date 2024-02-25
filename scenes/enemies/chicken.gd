extends CharacterBody2D

@onready var animator = $AnimatedSprite2D

const speed = 75.0

enum state {IDLE, RUN, HIT}
var anim_state = state.IDLE

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	var direction: int = -1
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	handle_movement(direction)
	update_chicken_state()
	update_chicken_animation(direction)
	move_and_slide()


func handle_movement(direction):
	velocity.x = direction * speed


func update_chicken_state():
	anim_state = state.IDLE
	
	if velocity.x > 0 || velocity.x < 0:
		anim_state = state.RUN


func update_chicken_animation(direction):
	if direction < 0:
		animator.flip_h = false
	elif direction > 0:
		animator.flip_h = true
	match anim_state:
		state.IDLE:
			animator.play("idle")
		state.RUN:
			animator.play("run")
