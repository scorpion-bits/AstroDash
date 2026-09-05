extends Node

const SAVE_FILE_PATH = "user://astrodash_story_save.save"

var current_phase: int = 1

func _ready() -> void:
	if not DirAccess.dir_exists_absolute("user://saves"):
		DirAccess.make_dir_absolute("user://saves")
		
	load_game()

func save_game() -> void:
	var file = FileAccess.open(SAVE_FILE_PATH, FileAccess.WRITE)
	if file:
		var data = { "phase": current_phase }
		file.store_line(JSON.stringify(data))
		print("Jogo salvo na fase ", current_phase)

func load_game() -> void:
	if not FileAccess.file_exists(SAVE_FILE_PATH):
		print("Nenhum save encontrado. Iniciando nova jornada.")
		return
		
	var file = FileAccess.open(SAVE_FILE_PATH, FileAccess.READ)
	if file:
		var json_string = file.get_line()
		var json = JSON.new()
		var error = json.parse(json_string)
		
		if error == OK:
			var data = json.get_data()
			if data.has("phase"):
				current_phase = data["phase"]
				print("Save carregado! Fase atual: ", current_phase)

func advance_to_next_phase() -> void:
	current_phase += 1
	save_game()
	load_current_phase_scene()

func restart_current_phase() -> void:
	load_current_phase_scene()

func load_current_phase_scene() -> void:
	var scene_path = "res://Rooms/Mode/Story/fase_" + str(current_phase) + ".tscn"
	
	if ResourceLoader.exists(scene_path):
		get_tree().change_scene_to_file(scene_path)
	else:
		print("Fase não encontrada ou jogo zerado! Caminho: ", scene_path)
