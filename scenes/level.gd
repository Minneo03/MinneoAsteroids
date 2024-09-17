extends Node2D

var asteroid_scene: PackedScene = load("res://scenes/asteroids.tscn")

func _on_asteroid_timer_timeout() -> void:
	var asteroid = asteroid_scene.instantiate()
	
	$Asteroids.add_child(asteroid)
