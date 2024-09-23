extends Node2D

var asteroid_scene: PackedScene = load("res://scenes/asteroids.tscn")
var laser_scene: PackedScene = load("res://scenes/laser.tscn")

#var health: int = 3 now global variable

func _ready():
	Global.health = 3
	var sizeX := get_viewport().get_visible_rect().size.x
	var sizeY := get_viewport().get_visible_rect().size.y
	Global.middleX = sizeX/2
	Global.middleY = sizeY/2
	$Player.position = Vector2(sizeX/2, sizeY/2)#Centers the Player position based on window size
	$Player.position +=  Vector2(0, 200)
	
	get_tree().call_group('ui', 'set_health', Global.health)

func _on_asteroid_timer_timeout() -> void:
	var asteroid = asteroid_scene.instantiate()
	asteroid.scale.x = 3
	$Asteroids.add_child(asteroid)
	#asteroid.connect('collision', _on_asteroid_collision)

#func _on_asteroid_collision():
	#Global.health -= 1
	#get_tree().call_group('ui', 'set_health', Global.health)
	#if Global.health <= 0:
	#	get_tree().change_scene_to_file("res://scenes/gameOverScreen.tscn")

func _on_player_laser(pos, rot) -> void:
	var laser = laser_scene.instantiate()
	$Lasers.add_child(laser)
	laser.position = pos
	laser.rotation_degrees = rot - 90
