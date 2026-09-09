extends RoomBase

@export var intro_dialogues: Array[DialogueLine] = []
@export var alien_dialogues: Array[DialogueLine] = []
@export var monologue_dialogues: Array[DialogueLine] = []

@onready var level_camera: Camera2D = $Camera2D 
@onready var spawn_timer: Timer = $SpawnTimer
@onready var player: StoryPlayer = $StoryPlayer 
@onready var mob_spawn_location: PathFollow2D = $MobPath/MobSpawnLocation
@onready var monitor_missao: TextureRect = $FaseUI/MonitorMissao
@onready var label_missao: Label = $FaseUI/MonitorMissao/LabelMissao
@onready var label_contador: Label = $FaseUI/MonitorMissao/LabelContador
@onready var alien_cutscene: Sprite2D = $AlienCutscene
@onready var posicao_alien: Marker2D = $PosicaoAlien


var meteor_scene: PackedScene = preload("res://Perigos/meteoro/meteoro.tscn")
var sucata_scene: PackedScene = preload("res://Rooms/Mode/Story/Itens/Sucata/sucata.tscn")

var collected_trash: int = 0
var max_trash: int = 2

var is_final_cutscene: bool = false


func _ready() -> void:
	super._ready()
	if player:
		player.position = Vector2(960, 930)
		player.is_in_cutscene = true
		player.cutscene_direction = Vector2(0, -1)
		
		if player.weapon_comp:
			player.weapon_comp.can_shoot = false
	
	if spawn_timer:
		if not spawn_timer.timeout.is_connected(_on_spawn_timer_timeout):
			spawn_timer.timeout.connect(_on_spawn_timer_timeout)
		spawn_timer.stop()
		
	start_intro_cutscene()

func _process(delta: float) -> void:
	if player.is_in_cutscene and level_camera and not is_final_cutscene:
		level_camera.global_position = player.global_position

func start_intro_cutscene() -> void:
	if intro_dialogues.size() > 0:
		DialogueManager.start_dialogue(intro_dialogues)
		await DialogueManager.dialogue_ended
		
	player.is_in_cutscene = false
	
	var tween = create_tween()
	
	tween.set_parallel(true)
	tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	
	tween.tween_property(level_camera, "global_position", Vector2(960, 540), 2.0)
	
	tween.tween_property(level_camera, "zoom", Vector2(1, 1), 2.0)
	
	await tween.finished
	
	if player and player.weapon_comp:
		player.weapon_comp.can_shoot = true
		
	if spawn_timer:
		spawn_timer.start()
		
	var ui_tween = create_tween()
	
	ui_tween.tween_property(monitor_missao, "position:x", 1470.0, 1.0).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	ui_tween.tween_interval(1.5)
	ui_tween.tween_callback(func(): 
		label_missao.hide()
		ui_tween.tween_interval(1.5)
		label_contador.show()
		label_contador.text = "Sucatas:\n0/" + str(max_trash)
	)

	ui_tween.tween_property(monitor_missao, "position:x", 1700.0, 1.0).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)

func _on_spawn_timer_timeout() -> void:
	if collected_trash >= max_trash:
		return
		
	var is_sucata = randf() > 0.7 
	
	mob_spawn_location.progress_ratio = randf()
	
	var item
	if is_sucata:
		item = sucata_scene.instantiate()
		item.collected.connect(_on_sucata_collected)
	else:
		item = meteor_scene.instantiate()
		
	add_child(item)
	item.global_position = mob_spawn_location.global_position
	
	var direction = mob_spawn_location.rotation + PI / 2
	direction += randf_range(-PI / 4, PI / 4)
	item.rotation = direction
	
	if is_sucata:
		item.direction = Vector2(1, 0).rotated(direction)
	else:
		var velocidade_extra = collected_trash * 50.0
		var velocidade_minima = 150.0 + velocidade_extra
		var velocidade_maxima = 250.0 + velocidade_extra
		var velocity = Vector2(randf_range(velocidade_minima, velocidade_maxima), 0.0)
		item.linear_velocity = velocity.rotated(direction)

func _on_sucata_collected() -> void:
	collected_trash += 1
	
	if label_contador:
		label_contador.text = "Sucatas:\n" + str(collected_trash) + "/" + str(max_trash)
	
	if spawn_timer.wait_time > 0.5:
		spawn_timer.wait_time -= 0.1
		
	if collected_trash >= max_trash:
		spawn_timer.stop()
		iniciar_lore()

func iniciar_lore() -> void:
	is_final_cutscene = true
	player.is_in_cutscene = true
	if player.weapon_comp:
		player.weapon_comp.can_shoot = false
		
	for inimigo in get_tree().get_nodes_in_group("meteoros"):
		inimigo.queue_free()
		
	var cutscene_tween = create_tween()
	cutscene_tween.tween_property(level_camera, "global_position", portal.global_position, 1.5).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	cutscene_tween.tween_property(level_camera, "zoom", Vector2(2.5, 2.5), 1.5)
	await cutscene_tween.finished
	
	portal.show()
	portal.set_deferred("monitoring", true)
	
	alien_cutscene.global_position = portal.global_position
	alien_cutscene.scale = Vector2(0.1, 0.1)
	alien_cutscene.show()
	
	var saida_tween = create_tween().set_parallel(true)
	saida_tween.tween_property(alien_cutscene, "global_position", posicao_alien.global_position, 1.0)
	saida_tween.tween_property(alien_cutscene, "scale", Vector2(1.0, 1.0), 1.0) 
	saida_tween.tween_property(level_camera, "global_position", posicao_alien.global_position, 1.0)
	await saida_tween.finished
	
	player.rotation = player.global_position.direction_to(alien_cutscene.global_position).angle() + (PI / 2)
	
	if alien_dialogues.size() > 0:
		DialogueManager.start_dialogue(alien_dialogues)
		await DialogueManager.dialogue_ended
		
	var volta_tween = create_tween().set_parallel(true)
	volta_tween.tween_property(alien_cutscene, "global_position", portal.global_position, 1.0)
	volta_tween.tween_property(alien_cutscene, "scale", Vector2(0.1, 0.1), 1.0)
	volta_tween.tween_property(level_camera, "global_position", portal.global_position, 1.0)
	await volta_tween.finished
	alien_cutscene.hide()
	
	var volta_camera_tween = create_tween().set_parallel(true)
	volta_camera_tween.tween_property(level_camera, "global_position", player.global_position, 1.5)
	volta_camera_tween.tween_property(level_camera, "zoom", Vector2(2.5, 2.5), 1.5)
	await volta_camera_tween.finished
	
	if monologue_dialogues.size() > 0:
		DialogueManager.start_dialogue(monologue_dialogues)
		await DialogueManager.dialogue_ended
		
	var fim_tween = create_tween().set_parallel(true)
	fim_tween.tween_property(level_camera, "global_position", Vector2(960, 540), 1.0)
	fim_tween.tween_property(level_camera, "zoom", Vector2(1.0, 1.0), 1.0)
	await fim_tween.finished
	
	StoryLevelManager.save_game()
	player.is_in_cutscene = false
	if player.weapon_comp:
		player.weapon_comp.can_shoot = true
