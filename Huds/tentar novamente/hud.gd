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

func _on_restart_button_pressed() -> void:
	get_tree().reload_current_scene()
