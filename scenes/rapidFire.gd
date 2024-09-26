extends CollisionShape2D

signal rapidFire

func _ready() -> void:
	add_to_group('rapidFire')

func _on_body_entered(_body: Node2D) -> void:
	rapidFire.emit()

func _on_rapid_fire() -> void:
	get_tree().call_group('player', '_on_rapid_fire')
