extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	var marker: Marker2D = $Enemies/Saw.get_child(3)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var marker: Marker2D = $Enemies/Saw.get_child(3)
	var pos = marker.global_position
	print(pos)
