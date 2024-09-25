extends Area2D

@export var speed = 1000

var direction = Vector2()

#Initializes the Laser with a "tween" starting the laser as small and growing to size.
func _ready():
	add_to_group("Laser")
	var tween = create_tween()
	tween.tween_property($Sprite2D, 'scale', Vector2(0.45,0.45), 0.2).from(Vector2(0.1,0.1))

#Updates the position of the laser based on speed and direction.
func _process(delta: float) -> void:
	direction = Vector2(cos(rotation), sin(rotation))
	position += speed * direction * delta


func _on_area_entered(area: Area2D) -> void: #Destroys lasers when they go out of bounds Does not work yet.
	if (area.is_in_group("Asteroid")):
		pass
	else:
		queue_free() 
