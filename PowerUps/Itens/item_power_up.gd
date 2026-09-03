extends Area2D

@export var data: PowerUpData

func _ready() -> void:
	if data:
		$Sprite2D.texture = data.texture
		


func _on_area_entered(area: Area2D) -> void:
	print("kkkkkkk")
	if area.is_in_group("Players") and not area.is_dead:
		if area.has_method("receber_powerup"):
			area.receber_powerup(data)
			queue_free()
