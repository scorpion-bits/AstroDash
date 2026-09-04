extends Control



func _on_solo_pressed() -> void:
	get_tree().change_scene_to_file("res://Rooms/Mode/Singleplayer/sigle_player.tscn")


func _on_coop_pressed() -> void:
	get_tree().change_scene_to_file("res://Rooms/Mode/multiplayer/Coop/coop.tscn")


func _on_quit_pressed() -> void:
	get_tree().change_scene_to_file("res://Huds/menuinicial/menu_inicial.tscn")


func _on_config_pressed() -> void:
	get_tree().change_scene_to_file("res://Rooms/Mode/multiplayer/Versus/versus.tscn")
