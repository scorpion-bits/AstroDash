extends Control

func update_score(score: int) -> void:
	$ScoreLabel.text = "Tempo: " + str(score)

func show_game_over(score: int) -> void:
	$ScoreLabel.hide()
	$FinalScoreLabel.text = "Você sobreviveu por " + str(score) + " segundos!"
	$FinalScoreLabel.show()
	$RestartButton.show()

func _on_restart_button_pressed() -> void:
	get_tree().reload_current_scene()
