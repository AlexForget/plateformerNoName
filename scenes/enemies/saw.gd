extends CharacterBody2D

@export_enum("horizontal", "vertical", "none") var mouvement_direction: int
@export var speed: float
@export var initial_direction: bool
@export var marker_movement_return_position: Vector2

var current_position: int = 0
var initial_movement_direction: bool = true

func _ready():
	$AnimatedSprite2D.play("rotate")
	var marker = $Marker2D
	marker.position = marker_movement_return_position
	if mouvement_direction == 0:
		velocity.x = speed if initial_direction else -speed
	elif mouvement_direction == 1:
		velocity.y = speed if initial_direction else -speed
	else:
		velocity = Vector2.ZERO

func _physics_process(delta):
	move_and_slide()
