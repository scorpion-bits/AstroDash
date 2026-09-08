extends TextureProgressBar
class_name HealthUI
@onready var astronaut_portrait: AnimatedSprite2D = $"../AstronautPortrait"
@onready var shake_component: ShakeComponent = $"../ShakeComponent"
@onready var ghost_bar: TextureProgressBar = $"../GhostHealthUI"


func _ready() -> void:
	EventBus.player_health_changed.connect(_on_player_health_changed)
	if ghost_bar:
		ghost_bar.max_value = max_value
		ghost_bar.value = value
	
func _on_player_health_changed(current_health, max_health):
	if current_health < value:
		shake_component.trigger()
		
		if ghost_bar:
			var tween = create_tween()
			tween.tween_property(ghost_bar, "value", current_health, 0.4).set_delay(0.2)
	else:
		if ghost_bar:
			ghost_bar.value = current_health
	
	max_value = max_health
	if ghost_bar:
		ghost_bar.max_value = max_health
		
	value = current_health
	
	if value >= 5:
		astronaut_portrait.frame = 0
	elif value >= 3:
		astronaut_portrait.frame = 1
	elif value > 0:
		astronaut_portrait.frame = 2
	else:
		astronaut_portrait.frame = 3
