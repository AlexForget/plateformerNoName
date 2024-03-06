extends Node2D

var remaining_collectables: int

# Called when the node enters the scene tree for the first time.
func _ready():
	remaining_collectables = $Collectables.get_child_count()
	
	for collectable in $Collectables.get_children():
		collectable.connect("collected", _on_collected_collectable)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_collected_collectable():
	remaining_collectables -= 1
	if remaining_collectables == 0:
		$Goal.open_flag()
		print("level finish")
