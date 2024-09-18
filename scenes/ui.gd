extends CanvasLayer

static var image = load("res://Spaceship-shooter#01/Spaceships/Spaceship#02(24x24).png")

func set_health(hp):
	for child in $"Lives Margin/HBoxContainer".get_children():
		child.queue_free()
		
	for i in hp:
		var text_rect = TextureRect.new()
		text_rect.texture = image
		$"Lives Margin/HBoxContainer".add_child(text_rect)
		text_rect.stretch_mode = TextureRect.STRETCH_KEEP
