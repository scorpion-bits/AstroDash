extends RoomBase

@onready var survival_timer: Timer = $SurvivalTimer
@onready var player: StoryPlayer = $StoryPlayer # Ajuste o caminho se necessário

func _ready() -> void:
	# Chama o _ready do RoomBase para carregar o fundo
	super._ready()
	
	# Na Fase 1 o jogador não pode atirar (desativamos a arma)
	if player and player.weapon_comp:
		player.weapon_comp.can_shoot = false
		
	# Conecta o fim do tempo de sobrevivência
	if survival_timer:
		survival_timer.timeout.connect(_on_survival_timer_timeout)
		
	# Inicie o seu Spawner de Meteoros aqui!

func _on_survival_timer_timeout() -> void:
	print("Tempo de sobrevivência acabou!")
	
	# 1. Pare de spawnar meteoros
	# $MeteorSpawner.stop()
	
	# 2. Destrua os meteoros que sobraram na tela (opcional)
	# for meteoro in get_tree().get_nodes_in_group("meteoros"):
	#     meteoro.queue_free()
	
	# 3. Toca a Lore/Cutscene
	iniciar_lore()

func iniciar_lore() -> void:
	# Aqui você pode instanciar um painel de diálogo, mostrar um texto na tela...
	print("Alien: 'Vocês, lixeiros, não vão nos impedir!'")
	print("IA da Nave: 'Armamento improvisado concluído. Pressione ESPAÇO para atirar.'")
	
	# Reativa a arma do jogador!
	if player and player.weapon_comp:
		player.weapon_comp.can_shoot = true
		
	# Termina a sala (abre o portal usando a função do RoomBase que criamos antes)
	finish_room()
