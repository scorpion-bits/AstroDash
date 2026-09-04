extends Area2D

signal hit
@export var player_id: int = 1

@export var speed: float = 350.0
@export var rotation_speed: float = 15.0 
@export var pode_empurrar: bool = false


var forca_empurrao: Vector2 = Vector2.ZERO
var screen_size: Vector2
var speed_multiplier: float = 1
var is_dead: bool = false
var is_invencible: bool = false
var original_color: Color
var has_shield: bool = false

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
		position += direction * (speed * speed_multiplier) * delta
		
		var target_angle = direction.angle() + (PI / 2)
		rotation = lerp_angle(rotation, target_angle, rotation_speed * delta)

	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)
	
	position += forca_empurrao * delta
	forca_empurrao = forca_empurrao.lerp(Vector2.ZERO, 10.0 * delta)

func _on_body_entered(_body: Node2D) -> void:
	if is_invencible:
		return
	
	if has_shield:
		has_shield = false
		revive()
		return
	
	die()
	hit.emit()

func revive():
	is_dead = false
	is_invencible = true
	modulate.a = 1.0
	modulate = Color(1,1,0)
	$InvencibilityTimer.start()

func die():
	is_dead = true
	modulate.a = 0.5
	set_collision_layer_value(1,false)
	set_collision_mask_value(2,false)

func _on_revive_area_area_entered(area: Area2D) -> void:
	if is_dead and area.is_in_group("Players"):
		revive() 

func receber_powerup(power: PowerUpData):
	match power.type:
		0: #escudo
			print("pegou escudo")
			has_shield = true
			modulate = Color(0.268, 0.408, 0.102, 1.0)
			
		1: #nitro
			print("pegou nitro")
			speed_multiplier = 1.5
			modulate = Color(1, 0.5, 1)
			$NitroTimer.start(power.time)
			
		2: #cronometro
			print("pegou cronometro")
			$CronometroTimer.start(power.time)
			get_tree().call_group("meteoros", "desacelerar")

func _on_invencibility_timer_timeout() -> void:
	is_invencible = false
	modulate = original_color
	set_collision_layer_value(1, true)
	set_collision_mask_value(2, true)
	
	if has_shield:
		modulate = Color(0.268, 0.408, 0.102, 1.0) 
	else:
		modulate = original_color

func _on_nitro_timer_timeout() -> void:
	speed_multiplier = 1.0
	if has_shield:
		modulate = Color(0.268, 0.408, 0.102, 1.0)
	else:
		modulate = original_color

func _on_cronometro_timer_timeout() -> void:
	get_tree().call_group("meteoros", "normalizar")


func _on_area_entered(area: Area2D) -> void:
	if pode_empurrar and area.is_in_group("Players") and not is_dead and not area.is_dead:
		var direcao = (global_position - area.global_position).normalized()
		forca_empurrao = direcao * 800.0
