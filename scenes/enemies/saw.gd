extends CharacterBody2D

@export var speed: float
@export var direction: Vector2

var start_position : Vector2
var target_position : Vector2

var initial_movement_direction: bool = true

func _ready():
	$AnimatedSprite2D.play("rotate")
	start_position = global_position
	target_position = start_position + direction

func _physics_process(delta):
	global_position = global_position.move_toward(target_position, speed * delta)
	if global_position == target_position:
		if global_position == start_position:
			target_position = start_position + direction
		else: 
			target_position = start_position
	move_and_slide()



func _on_hitbox_body_entered(body):
	if body.is_in_group("Player"):
		body.player_get_hit(self)
