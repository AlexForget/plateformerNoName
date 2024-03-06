extends Node2D

func _ready():
	$AnimatedSprite2D.play("still")

func open_flag():
	$AnimatedSprite2D.play("opening")
	await $AnimatedSprite2D.animation_finished
	$AnimatedSprite2D.play("flag_waving")
