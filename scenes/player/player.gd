extends CharacterBody2D

@onready var animated_sprite = $AnimatedSprite2D

var health: int = 3
var speed : float = 150.0
var jump_velocity : float = -20.0
var fall_velocity : float = 5.0
var bounce_velocity : float = -200.0
var acceleration : float = 15.0
var friction : float = 1.25
var horizontal_push_back_velocity : float = 250
var push_back_velocity : Vector2 = Vector2(horizontal_push_back_velocity,-150)
var is_immune: bool = false
var can_jump: bool = true
var is_jumping: bool = false


enum state {IDLE, RUN, JUMP, FALL, HIT}
var anim_state = state.IDLE

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	pass

func _physics_process(delta):
	# Add the gravity.
	if !is_on_floor():
		velocity.y += gravity * delta
	# Get the input direction and handle the movement/deceleration.
	var direction: float = Input.get_axis("moveLeft", "moveRight")

	handle_jump(delta)
	handle_movement(direction)
	update_player_state()
	update_player_animation(direction)
	move_and_slide()


func handle_jump(delta):
	var top_velocity_jump: int = -75
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y += gravity * jump_velocity * delta
	elif Input.is_action_just_released("jump") && velocity.y <= top_velocity_jump && !is_on_floor():
		velocity.y += gravity * fall_velocity * delta


func handle_movement(direction):
	if direction:
		velocity.x = move_toward(velocity.x, direction * speed, acceleration)
	else:
		velocity.x = move_toward(velocity.x, 0, acceleration / friction)

	
func update_player_state():
	if !is_immune:
		anim_state = state.IDLE
		
		if velocity.x > 0 || velocity.x < 0:
			anim_state = state.RUN
			
		if velocity.y > 0:
			anim_state = state.FALL
			
		if velocity.y < 0:
			anim_state = state.JUMP


func update_player_animation(direction):
	if direction > 0:
			animated_sprite.flip_h = false
	elif direction < 0:
		animated_sprite.flip_h = true
	if !is_immune:
		match anim_state:
			state.IDLE:
				animated_sprite.play("idle")
			state.RUN:
				animated_sprite.play("run")
			state.FALL:
				animated_sprite.play("fall")
			state.JUMP:
				animated_sprite.play("jump")
  

func _on_hitbox_body_entered(body):
	if body.is_in_group("Enemy") && velocity.y > 0.01 && body.has_method("get_hit"):
		body.get_hit()
		velocity.y = bounce_velocity


func player_get_hit(enemy_body):
	if !is_immune:
		health -= 1
		manage_push_back(enemy_body)
		is_immune = true
		
	if health <= 0:
		animated_sprite.play("dessapear")
		await animated_sprite.animation_finished
		queue_free()
	else :
		animated_sprite.play("hit")
		await animated_sprite.animation_finished
		is_immune = false


func manage_push_back(enemy_body):
	if enemy_body.global_position.x > global_position.x:
		push_back_velocity.x = -horizontal_push_back_velocity
	elif enemy_body.global_position.x < global_position.x:
		push_back_velocity.x = horizontal_push_back_velocity
	velocity = push_back_velocity
