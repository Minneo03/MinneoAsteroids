extends Area2D

@export var speed = 1000

var direction = Vector2()

func _ready():
	add_to_group("Laser")
	var tween = create_tween()
	tween.tween_property($Sprite2D, 'scale', Vector2(0.45,0.45), 0.2).from(Vector2(0.1,0.1))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	direction = Vector2(cos(rotation), sin(rotation))
	position += speed * direction * delta
