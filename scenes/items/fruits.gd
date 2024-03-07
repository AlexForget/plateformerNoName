extends Node2D

@export_enum("apple", "banana", "cherry", "collected", "kiwi", "melon", "orange", "pineapple", "strawberry") var chosen_animation: String
signal collected

func _ready():
	$AnimationPlayer.play(chosen_animation)


func _on_area_2d_body_entered(_body):
	emit_signal("collected")
	$AnimationPlayer.play("collected")
	$AnimationPlayer.animation_finished.connect(queue_free)
