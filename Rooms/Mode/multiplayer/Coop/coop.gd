extends Node2D

@export var enemy_scene: PackedScene = preload("res://Perigos/meteoro.tscn")
@export var cena_powerup: PackedScene
@export var lista_de_poderes: Array[PowerUpData]

var score: int = 0


func _ready() -> void:
	$Player1.hit.connect(check_game_over)
	$Player2.hit.connect(check_game_over)
	$SpawnTimer.timeout.connect(_on_spawn_timer_timeout)

func _on_spawn_timer_timeout() -> void:
	score += 1
	$HUD.update_score(score)
	
	if $SpawnTimer.wait_time > 0.2:
		$SpawnTimer.wait_time -= 0.02 
		
	var velocidade_extra = score * 3.0 
	var velocidade_minima = 150.0 + velocidade_extra
	var velocidade_maxima = 250.0 + velocidade_extra
	var spawn_location = $MobPath/MobSpawnLocation
	spawn_location.progress_ratio = randf()
	
	var enemy = enemy_scene.instantiate()
	add_child(enemy)
	
	
	enemy.global_position = spawn_location.global_position
	var direction = spawn_location.rotation + PI / 2
	direction += randf_range(-PI / 4, PI / 4)
	enemy.rotation = direction
	
	
	var velocity = Vector2(randf_range(velocidade_minima, velocidade_maxima), 0.0)
	enemy.linear_velocity = velocity.rotated(direction)
	

func check_game_over() -> void:
	if $Player1.is_dead and $Player2.is_dead:
		$SpawnTimer.stop()
		#$Player.queue_free()
		$HUD.show_game_over(score)


func _on_timer_timeout() -> void:
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
	
	
	
