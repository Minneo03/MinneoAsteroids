extends Area2D

var speed: int
var rotation_speed: int
var direction_x: float
@export var asteroidSplit:= 2

var asteroid_scene: PackedScene = load("res://scenes/asteroids.tscn")

var rng := RandomNumberGenerator.new()

signal collision

func _ready():
	connect("body_entered", Callable(self, "_on_body_entered"))
	connect("area_entered", Callable(self, "_on_area_entered"))
	
	if $".".scale.x == 3:
		_initial_asteroid()

func _initial_asteroid():
	var width = get_viewport().get_visible_rect().size[0]
	var random_x = rng.randi_range(0, width)
	var random_y = rng.randi_range(-150, -50)
	position = Vector2(random_x, random_y)
	
	speed = rng.randi_range(200, 500)
	direction_x = rng.randf_range(-1, 1)
	rotation_speed = rng.randi_range(40, 100)

func _process(delta):
	position += Vector2(direction_x, 1.0) * speed * delta
	rotation_degrees += rotation_speed * delta

func _on_body_entered(_body: Node2D) -> void:
	collision.emit()

func _on_area_entered(area: Area2D) -> void:
	if scale.x > 0.75:
		area.queue_free()
		queue_free()
		for i in 2:
			var asteroid = asteroid_scene.instantiate()
			asteroid.position = position
			asteroid.scale = scale/2
			asteroid.speed = speed + rng.randi_range(-150, 150)
			asteroid.direction_x = direction_x + rng.randf_range(-1, 1)
			asteroid.rotation_speed = rotation_speed + rng.randi_range(-20, 20)
			get_tree().current_scene.add_child(asteroid)
			
			asteroid.connect("collision", Callable(get_parent(), "_on_asteroid_collision"))
			connect("body_entered", Callable(asteroid, "_on_body_entered"))
			connect("area_entered", Callable(asteroid, "_on_area_entered"))
	else:
		area.queue_free()
		queue_free()
	
	Global.score += 1000
	get_tree().call_group('ui', 'update_score', Global.score)
