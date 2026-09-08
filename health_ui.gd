extends TextureProgressBar
class_name HealthUI
@onready var astronaut_portrait: AnimatedSprite2D = $"../AstronautPortrait"
@onready var shake_component: ShakeComponent = $"../ShakeComponent"


func _ready() -> void:
	EventBus.player_health_changed.connect(_on_player_health_changed)
	
func _on_player_health_changed(current_health, max_health):
	shake_component.trigger()
	
	max_value = max_health
	value = current_health
	
	if value >= 5:
		astronaut_portrait.frame = 0
	elif value >= 3:
		astronaut_portrait.frame = 1
	elif value > 0:
		astronaut_portrait.frame = 2
	else:
		astronaut_portrait.frame = 3
