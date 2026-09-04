extends Node2D


@export var cena_buraco_negro: PackedScene = preload("res://Perigos/BuracoNegro/buraco_negro.tscn")
@export var cena_powerup: PackedScene
@export var lista_de_poderes: Array[PowerUpData]


var posicao_inicial_player1: Vector2
var posicao_inicial_player2: Vector2
var tempo_inicial_buraco: float

var rodada_processada: bool = false

func _ready() -> void:
	posicao_inicial_player1 = $Player1.global_position
	posicao_inicial_player2 = $Player2.global_position
	
	tempo_inicial_buraco = $BuracoNegroTimer.wait_time
	
	$Player1.hit.connect(game_check)
	$Player2.hit.connect(game_check)

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
		var distancia_seguranca = 350.0 
		
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

func reiniciar_rodada() -> void:
	$BuracoNegroTimer.stop()
	
	for buraco in get_tree().get_nodes_in_group("blackhole"):
		buraco.queue_free()
	
	$BuracoNegroTimer.wait_time = tempo_inicial_buraco
	
	$Player1.global_position = posicao_inicial_player1
	$Player2.global_position = posicao_inicial_player2
	
	$Player1.revive()
	$Player2.revive()
	
	rodada_processada = false
	
	$BuracoNegroTimer.start()

func game_check() -> void:
	if rodada_processada:
		return
	
	rodada_processada = true
	
	$BuracoNegroTimer.stop()
	
	var partida_acabou = $HudVersus.game_check()
	
	if not partida_acabou:
		reiniciar_rodada()


func _on_wait_timer_timeout() -> void:
		var itens_na_tela = get_tree().get_nodes_in_group("powerups").size()
		
		if itens_na_tela >= 3:
			return
			
		if lista_de_poderes.is_empty():
			return
			
		var novo_item = cena_powerup.instantiate()
		
		var poder_sorteado = lista_de_poderes.pick_random()
		novo_item.data = poder_sorteado
		
		var tamanho_tela = get_viewport_rect().size
		var margem = 60
		
		var x_aleatorio = randf_range(margem, tamanho_tela.x - margem)
		var y_aleatorio = randf_range(margem, tamanho_tela.y - margem)
		
		novo_item.position = Vector2(x_aleatorio, y_aleatorio)
		
		add_child(novo_item)
