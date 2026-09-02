extends Area2D

signal hit

@export var speed: float = 350.0
@export var rotation_speed: float = 15.0 
var screen_size: Vector2

func _ready() -> void:
	screen_size = get_viewport_rect().size

func _process(delta: float) -> void:
	var direction = Input.get_vector("A", "D", "W", "S") 
	
	if direction != Vector2.ZERO:
		position += direction * speed * delta
		
		var target_angle = direction.angle() + (PI / 2)
		rotation = lerp_angle(rotation, target_angle, rotation_speed * delta)

	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)

func _on_body_entered(_body: Node2D) -> void:
	hit.emit()
