extends Area2D
@export var forca_puxao: float = 15000.0
@export var tempo_de_vida: float = 8.0 # Quanto tempo ele fica na tela
func _ready() -> void:
	# Cria um timer invisível para o buraco negro sumir depois de um tempo
	var timer = get_tree().create_timer(tempo_de_vida)
	timer.timeout.connect(queue_free)
func _process(delta: float) -> void:
	# Pega todas as áreas que estão tocando nesse circulão
	var areas = get_overlapping_areas()
	
	for area in areas:
		# Verifica se o que entrou foi um Player e se ele está vivo
		if area.is_in_group("Players") and not area.is_dead:
			
			var distancia = global_position.distance_to(area.global_position)
			var direcao = (global_position - area.global_position).normalized()
			
			# Lógica 1: Puxar o jogador (quanto mais perto, mais forte puxa)
			# Protegemos com max(distancia, 10.0) para não dividir por zero
			var forca = forca_puxao / max(distancia, 10.0) 
			area.position += direcao * forca * delta
			
			# Lógica 2: Morte! Se o jogador for sugado até o "centro" (menos de 20 pixels)
			if distancia < 20.0:
				matar_jogador(area)
# Essa função imita exatamente o que o Meteoro faz com o Player
func matar_jogador(player: Area2D):
	if player.is_invencible:
		return
	
	if player.has_shield:
		player.has_shield = false
		player.revive() # O revive no seu código gasta o escudo e dá invencibilidade temporária
		return
		
	player.die()
	player.hit.emit()
