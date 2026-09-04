extends RigidBody2D

var speed_multiplier: float = 1.0
var esta_lento: bool = false

func _ready() -> void:
	$VisibleOnScreenNotifier2D.screen_exited.connect(queue_free)

func desacelerar():
	if not esta_lento:
		esta_lento = true
		linear_velocity = linear_velocity * 0.5
		
func normalizar():
	if esta_lento:
		esta_lento = false
		linear_velocity = linear_velocity * 2.0 # Restaura a velocidade ao normal
