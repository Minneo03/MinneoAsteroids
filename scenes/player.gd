extends CharacterBody2D

@export var max_speed = 1000
@export var acceleration_rate = 300
@export var default_deceleration_rate = 150
@export var rotation_speed = 3

var can_shoot: bool = true

signal laser(pos, rot)

var acceleration = Vector2()
var deceleration_rate = default_deceleration_rate

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	acceleration = Vector2() #Need to reset acceleration every frame for deceleration to work properly.
	deceleration_rate = default_deceleration_rate
	
	#Rotational Movement
	if Input.is_action_pressed("rotateLeft"):
		rotation -= rotation_speed * delta
	
	if Input.is_action_pressed("rotateRight"):
		rotation += rotation_speed * delta
	
	#Forward Movement
	var direction = Vector2()
	
	if Input.is_action_pressed("boost"):
		direction = Vector2(cos(rotation - PI/2), sin(rotation - PI/2)) #This gets the direction through trigonometry. The "- PI/2" sections are only to adjust the starting direction to be up.
		acceleration += direction * acceleration_rate
		
	if Input.is_action_pressed("brake"):
		deceleration_rate *= 4
	
	if acceleration == Vector2():
		velocity = velocity.move_toward(Vector2(), deceleration_rate * delta)
	else:
		velocity += acceleration * delta
		
		if velocity.length() > max_speed:
			velocity = velocity.normalized() * max_speed
	
	move_and_slide()
	
	#Shooting
	if Input.is_action_pressed("shoot") and can_shoot:
		laser.emit($LaserStartPos.global_position, rotation_degrees)
		can_shoot = false
		$Reload.start()
	
func _on_reload_timeout() -> void:
	can_shoot = true

#if Input.is_action_pressed("ui_down"):
#	position += Vector2(1, 1) * 20 * delta
# get_node("PlayerImage").rotation += 0.1 * delta -> would target only the sprite "PlayerImage"
# $PlayerImage.rotation += 0.1 * delta -> same thhing but shorter
