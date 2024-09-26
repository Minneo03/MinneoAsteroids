extends Area2D

var speed: int
var rotation_speed: int
var direction_x: float
@export var asteroidSplit:= 2
var temp = 0

var asteroid_scene: PackedScene = load("res://scenes/asteroids.tscn")

var rng := RandomNumberGenerator.new()

signal collision

#Adds the "Area2D" to the group Asteroid to later determine what area is entering what.
func _ready():
	add_to_group("Asteroid")
	if $".".scale.x == 3: #This could be changed, but I feel 3 is a good scale
		_initial_asteroid()

#This initializes a "Big" asteroid with a lot of random variables based on the given ranges
func _initial_asteroid():
	var width = get_viewport().get_visible_rect().size[0]
	var random_x = rng.randi_range(0, width)
	var random_y = rng.randi_range(-150, -50)
	position = Vector2(random_x, random_y)
	
	speed = rng.randi_range(200, 500)
	direction_x = rng.randf_range(-1, 1)
	rotation_speed = rng.randi_range(40, 100)

#Updates the position of each asteroid.
func _process(delta):
	position += Vector2(direction_x, 1.0) * speed * delta
	rotation_degrees += rotation_speed * delta

#When player enters, as that is the only Body2D
func _on_body_entered(_body: Node2D) -> void:
	collision.emit()

#When an area enters, this could be either the Laser, or the Asteroid Border
func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("Laser"):
		if scale.x > 0.75: #This value should be equal to the initial scale/4
			#Destroys both the laser and the asteroid object
			if($IFrames.time_left >= 0.0):
				Global.can_be_hit = true
			area.queue_free()
			queue_free()
			for i in 2: #This for loop will create 2 new asteroids half the size with slightly randomized values for speed, direction, and rotation.
				var asteroid = asteroid_scene.instantiate()
				asteroid.position = position
				asteroid.scale = scale/2
				asteroid.speed = speed + rng.randi_range(-150, 150)
				asteroid.direction_x = direction_x + rng.randf_range(-1, 1)
				asteroid.rotation_speed = rotation_speed + rng.randi_range(-20, 20)
				get_tree().current_scene.add_child(asteroid)
		else: #Basically this is a "ifSmallAsteroid" which will only delete objects, not create any.
			area.queue_free()
			queue_free()
		Global.score += 1000
		get_tree().call_group('ui', 'update_score', Global.score) 
	elif (area.is_in_group("rapidFire")): #If the area entering the asteroid is the asteroid border, it will flip its position by mirroring it across the two middleX, middleY values.
		print("buddy")
	else:
		if position.x > Global.middleX:
			temp = position.x - Global.middleX
			if position.y < Global.middleY*2:
				position.x -= temp*1.9
			else:
				position.x -= temp*2
		else:
			temp = Global.middleX - position.x
			if position.y < Global.middleY*2:
				position.x += temp*1.9
			else:
				position.x += temp*2
		if position.y > Global.middleY:
			temp = position.y - Global.middleY
			position.y -= temp*2
		else:
			temp = Global.middleY - position.y
			position.y += temp*2

#What happens on collision with the player.
func _on_collision() -> void:
	if Global.can_be_hit == true: #This variables helps with IFrames so the player doesn't get hit 3 times in one second due to getting hit, splitting an asteroid, and getting hit by both children immediately.
		Global.can_be_hit = false
		print("Cant be hit")
		$IFrames.start()
		Global.health -= 1
		get_tree().call_group('ui', 'set_health', Global.health)
		if Global.health <= 0:
			get_tree().change_scene_to_file("res://scenes/gameOverScreen.tscn")
	else:
		print("Invulnerable")

#Again, IFrames need to be used.
func _on_i_frames_timeout() -> void:
	Global.can_be_hit = true
	print("Can be hit")
