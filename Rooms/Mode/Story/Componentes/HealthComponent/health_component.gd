extends Node
class_name HealthComponent

signal health_changed(current_health, max_health)
signal died

@onready var invincibility_timer: Timer = $InvincibilityTimer

@export var max_health: int = 3

var current_health: int
var is_invincible: bool = false

func _ready() -> void:
	current_health = max_health

func restore_health(amount: int = max_health) -> void:
	current_health = clamp(current_health + amount, 0, max_health)
	health_changed.emit(current_health, max_health)

func take_damage(amount: int, invincibility_duration: float = 1.0) -> void:
	if is_invincible or current_health <= 0:
		return
		
	current_health -= amount
	health_changed.emit(current_health, max_health)
	
	if current_health <= 0:
		died.emit()
	else:
		is_invincible = true
		if invincibility_timer:
			invincibility_timer.start(invincibility_duration)

func _on_invincibility_timer_timeout() -> void:
	is_invincible = false
