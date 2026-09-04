extends Node2D
@export var cena_buraco_negro: PackedScene = preload("res://Perigos/BuracoNegro/buraco_negro.tscn")

func _on_buraco_negro_timer_timeout() -> void:
	if $BuracoNegroTimer.wait_time > 1.0:
		$BuracoNegroTimer.wait_time -= 1
		
	var buraco = cena_buraco_negro.instantiate()
	
	var tamanho_tela = get_viewport_rect().size
	var margem = 100
	var posicao_segura = false
	var posicao_final = Vector2.ZERO
	var tentativas = 0 
	
	while not posicao_segura and tentativas < 50:
		var x_aleatorio = randf_range(margem, tamanho_tela.x - margem)
		var y_aleatorio = randf_range(margem, tamanho_tela.y - margem)
		posicao_final = Vector2(x_aleatorio, y_aleatorio)
		
		var esta_muito_perto = false
		var distancia_seguranca = 350.0 # Pode aumentar se quiser que nasça mais longe ainda
		
		if has_node("Player1") and not $Player1.is_dead:
			if posicao_final.distance_to($Player1.global_position) < distancia_seguranca:
				esta_muito_perto = true
				
		if has_node("Player2") and not $Player2.is_dead:
			if posicao_final.distance_to($Player2.global_position) < distancia_seguranca:
				esta_muito_perto = true
				
		if not esta_muito_perto:
			posicao_segura = true
			
		tentativas += 1
	
	buraco.position = posicao_final
	add_child(buraco)
