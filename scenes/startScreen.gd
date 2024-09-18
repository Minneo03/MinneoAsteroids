extends Control

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _input(event):
	if event.is_action_pressed("start"):
		get_tree().change_scene_to_file("res://scenes/level.tscn")
