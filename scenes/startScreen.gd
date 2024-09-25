extends Control

#Starts the game
func _input(event):
	if event.is_action_pressed("start"):
		get_tree().change_scene_to_file("res://scenes/level.tscn")
