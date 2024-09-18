extends Node2D

var asteroid_scene: PackedScene = load("res://scenes/asteroids.tscn")
var laser_scene: PackedScene = load("res://scenes/laser.tscn")

func _ready():
	var size := get_viewport().get_visible_rect().size
	$Player.position = size / 2 #Centers the Player position based on window size

func _on_asteroid_timer_timeout() -> void:
	var asteroid = asteroid_scene.instantiate()
	
	$Asteroids.add_child(asteroid)


func _on_player_laser(pos, rot) -> void:
	var laser = laser_scene.instantiate()
	$Lasers.add_child(laser)
	laser.position = pos
	laser.rotation_degrees = rot - 90
