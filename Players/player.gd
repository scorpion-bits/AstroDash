extends Area2D

signal hit
@export var player_id: int = 1

@export var speed: float = 350.0
@export var rotation_speed: float = 15.0 
var screen_size: Vector2

#teste multiplayer
var is_dead: bool = false
var is_invencible: bool = false
var original_color: Color

func _ready() -> void:
	original_color = modulate
	screen_size = get_viewport_rect().size

func _process(delta: float) -> void:
	if is_dead:
		return
	
	var esquerda = "left_" + str(player_id)
	var direita = "right_" + str(player_id)
	var cima = "up_" + str(player_id)
	var baixo = "down_" + str(player_id)
	
	var direction = Input.get_vector(esquerda, direita, cima, baixo)
	
	if direction != Vector2.ZERO:
		position += direction * speed * delta
		
		var target_angle = direction.angle() + (PI / 2)
		rotation = lerp_angle(rotation, target_angle, rotation_speed * delta)

	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)

func _on_body_entered(_body: Node2D) -> void:
	die()
	hit.emit()

func revive():
	is_dead = false
	is_invencible = true
	modulate.a = 1.0
	modulate = Color(1,1,0)
	$InvencibilityTimer.start()
	
func _on_invencibility_timer_timeout() -> void:
	is_invencible = false
	modulate = original_color
	set_collision_layer_value(1, true)
	set_collision_mask_value(2, true)
	




func die():
	is_dead = true
	modulate.a = 0.5
	set_collision_layer_value(1,false)
	set_collision_mask_value(2,false)



func _on_revive_area_area_entered(area: Area2D) -> void:
	print("entroua")
	if is_dead and area.is_in_group("Players"):
		revive() 
