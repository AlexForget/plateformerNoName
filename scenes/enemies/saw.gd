extends CharacterBody2D

@export_enum("horizontal", "vertical", "none") var mouvement_direction: int
@export var speed: float
@export var initial_direction: bool  #to the right or bottom
@export var return_position: Vector2
@export var distance: int
var initial_position: Vector2

var current_position: int = 0
var initial_movement_direction: bool = true

func _ready():
	$AnimatedSprite2D.play("rotate")
	initial_position = position

func _physics_process(delta):
	handle_direction()
	print("position : ", abs(position.x - initial_position.x))
	print("distance : ", distance)
	if mouvement_direction == 0:
		if abs(position.x - initial_position.x) >= distance:
			# Change direction
			initial_direction = false
	elif mouvement_direction == 1:
		velocity.y = speed if initial_direction else -speed
	move_and_slide()

func handle_direction():
	if mouvement_direction == 0:
		velocity.x = speed if initial_direction else -speed
	elif mouvement_direction == 1:
		velocity.y = speed if initial_direction else -speed
	else:
		velocity = Vector2.ZERO

func change_direction():
	if initial_direction == true:
		initial_direction = false
	elif initial_direction == false:
		initial_direction = true

func change_position():
	pass
