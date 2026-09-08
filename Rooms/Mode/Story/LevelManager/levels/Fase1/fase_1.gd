extends RoomBase

@export var intro_dialogues: Array[DialogueLine] = []

@onready var level_camera: Camera2D = $Camera2D 
@onready var spawn_timer: Timer = $SpawnTimer
@onready var player: StoryPlayer = $StoryPlayer 
@onready var mob_spawn_location: PathFollow2D = $MobPath/MobSpawnLocation

var meteor_scene: PackedScene = preload("res://Perigos/meteoro/meteoro.tscn")
var sucata_scene: PackedScene = preload("res://Rooms/Mode/Story/Itens/Sucata/sucata.tscn")

var collected_trash: int = 0
var max_trash: int = 15

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
	if player.is_in_cutscene and level_camera:
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
	print("Sucata coletada! Total: ", collected_trash)
	
	if spawn_timer.wait_time > 0.5:
		spawn_timer.wait_time -= 0.1
		
	if collected_trash >= max_trash:
		spawn_timer.stop()
		iniciar_lore()

func iniciar_lore() -> void:
	print("Alien: 'Vocês, lixeiros, não vão nos impedir!'")
	print("IA da Nave: 'Armamento improvisado concluído. Pressione ESPAÇO para atirar.'")
	
	if player and player.weapon_comp:
		player.weapon_comp.can_shoot = true
		
	finish_room()
