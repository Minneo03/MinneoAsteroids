extends Control

#Displays the score on the game over screen.
func _ready():
	$gameOverUI/gameOverContainer/verticalSpacer/scoreLabel.text = $gameOverUI/gameOverContainer/verticalSpacer/scoreLabel.text + str(Global.score)
	Global.score = 0

#When there is the start input, it will start the game over again.
func _input(event):
	if event.is_action_pressed("start"):
		get_tree().change_scene_to_file("res://scenes/level.tscn")
