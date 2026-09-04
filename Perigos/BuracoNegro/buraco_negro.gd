extends Area2D



@export var forca_puxao: float = 15000.0
@export var tempo_de_vida: float = 8.0
func _ready() -> void:
	var timer = get_tree().create_timer(tempo_de_vida)
	timer.timeout.connect(queue_free)
func _process(delta: float) -> void:
	var areas = get_overlapping_areas()
	
	for area in areas:
		if area.is_in_group("Players") and not area.is_dead:
			
			var distancia = global_position.distance_to(area.global_position)
			var direcao = (global_position - area.global_position).normalized()
			var forca = forca_puxao / max(distancia, 10.0) 
			area.position += direcao * forca * delta
			
			if distancia < 30.0:
				matar_jogador(area)

func matar_jogador(player: Area2D):
	if player.is_invencible:
		return
	
	if player.has_shield:
		player.has_shield = false
		player.revive() 
		return
		
	player.die()
	player.hit.emit()
