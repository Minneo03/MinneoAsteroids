extends Node2D

var asteroid_scene: PackedScene = load("res://scenes/asteroids.tscn")
var laser_scene: PackedScene = load("res://scenes/laser.tscn")

var health: int = 3

func _ready():
	var size := get_viewport().get_visible_rect().size
	$Player.position = size / 2 #Centers the Player position based on window size
	$Player.position +=  Vector2(0, 200)
	
	get_tree().call_group('ui', 'set_health', health)

func _on_asteroid_timer_timeout() -> void:
	var asteroid = asteroid_scene.instantiate()
	asteroid.scale.x = 3
	$Asteroids.add_child(asteroid)
	#asteroid.connect('collision', _on_asteroid_collision)
	asteroid.connect('collision', Callable(self, "_on_asteroid_collision"))

func _on_asteroid_collision():
	health -= 1
	get_tree().call_group('ui', 'set_health', health)
	if health <= 0:
		get_tree().change_scene_to_file("res://scenes/gameOverScreen.tscn")

func _on_player_laser(pos, rot) -> void:
	var laser = laser_scene.instantiate()
	$Lasers.add_child(laser)
	laser.position = pos
	laser.rotation_degrees = rot - 90
