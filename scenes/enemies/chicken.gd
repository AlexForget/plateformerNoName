extends CharacterBody2D

@onready var animator = $AnimatedSprite2D

var speed : float = 75.0

enum state {IDLE, RUN, HIT}
var anim_state = state.IDLE
var direction: int = -1
var is_death: bool = false

var _player = null

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
		
	if !is_death:
		if is_on_wall():
			change_direction()
		if !$RayCast2D.is_colliding() && is_on_floor():
			change_direction()
		handle_movement()
		update_chicken_state()
		update_chicken_animation()
		_inflict_dommage()
		move_and_slide()


func change_direction():
	direction = 1 if direction == -1 else -1
	scale.x = 1 if scale.x == -1 else -1

func handle_movement():
	velocity.x = direction * speed


func update_chicken_state():
	if anim_state != state.HIT:
		anim_state = state.IDLE
		if velocity.x > 0 || velocity.x < 0:
			anim_state = state.RUN


func update_chicken_animation():
	match anim_state:
		state.IDLE:
			animator.play("idle")
		state.RUN:
			animator.play("walk")
		state.HIT:
			animator.play("hit")


func get_hit():
	is_death = true
	animator.play("hit")
	animator.animation_finished.connect(queue_free)


func _on_hitbox_body_entered(body):
	if body.is_in_group("Player"):
		_player = body


func _on_hitbox_body_exited(body):
	if body.is_in_group("Player"):
		_player = null


func _inflict_dommage():
	if _player != null:
		_player.player_get_hit(self)
