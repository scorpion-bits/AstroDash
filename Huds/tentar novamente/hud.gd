extends Control

func _ready() -> void:
	$RestartButton.grab_focus()

func update_score(score: int) -> void:
	$ScoreLabel.text = "Score: " + str(score)

func show_game_over(score: int) -> void:
	$ScoreLabel.hide()
	$FinalScoreLabel.text = "Seu Score foi de " + str(score) + " pontos!"
	$FinalScoreLabel.show()
	$RestartButton.show()
	$retunr.show()

func _on_restart_button_pressed() -> void:
	get_tree().reload_current_scene()


func _on_retunr_pressed() -> void:
	get_tree().change_scene_to_file("res://Huds/Selectmodemenu/select_menu.tscn")
