extends Node2D

var asteroid_scene: PackedScene = load("res://scenes/asteroids.tscn")
var laser_scene: PackedScene = load("res://scenes/laser.tscn")

var levelTimer := true
var timeLeft := 0
var level := 1

#var health: int = 3 now global variable

#Whenever the game goes into the Level Scene, global health gets reset and the player can be hit. It will also find the exact middle of the screen and set those to global variables.
func _ready():
	Global.health = 3
	Global.can_be_hit = true
	var sizeX := get_viewport().get_visible_rect().size.x
	var sizeY := get_viewport().get_visible_rect().size.y
	Global.middleX = sizeX/2
	Global.middleY = sizeY/2
	$Player.position = Vector2(sizeX/2, sizeY/2)#Centers the Player position based on window size
	$Player.position +=  Vector2(0, 200)
	
	get_tree().call_group('ui', 'set_health', Global.health)
	
	$LevelTimer.start()
	levelTimer = true

#This function, along with the other 2 timer functions, work together to create a level system that spawns asteroids over a couple seconds and then has a cooldown between levels.
func _on_level_cooldown_timeout() -> void:
	$LevelCooldown.wait_time *= 1.2
	$LevelTimer.wait_time *= 1.2
	level += 1
	get_tree().call_group('ui', 'update_level', level)
	$LevelTimer.start()
	levelTimer = true

func _on_level_timer_timeout() -> void:
	levelTimer = false
	$LevelCooldown.start()

func _on_asteroid_timer_timeout() -> void:
	if (levelTimer == true):
		var asteroid = asteroid_scene.instantiate()
		asteroid.scale.x = 3
		$Asteroids.add_child(asteroid)

#This function instantiates a laser object in front of the player following player rotation.
func _on_player_laser(pos, rot) -> void:
	var laser = laser_scene.instantiate()
	$Lasers.add_child(laser)
	laser.position = pos
	laser.rotation_degrees = rot - 90

#These run constantly as it does show how long is left until the next level.
func _process(float) -> void:
	timeLeft = $LevelCooldown.time_left
	get_tree().call_group('ui', 'update_time', timeLeft)
