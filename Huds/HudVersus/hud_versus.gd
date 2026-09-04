extends Control
@onready var player1: Area2D = $"../Player1"
@onready var player2: Area2D = $"../Player2"

var score1: int = 0
var score2: int = 0

func update_score(score1: int, score2: int) -> void:
	$player1score.text = "Player 1: " + str(score1)
	$player2score.text = "Player 2: " + str(score2)


func game_check() -> bool:
	if score1 == 3:
		$campeao.text = "Player 1 ganhou!"
		win_the_game()
		return true
	elif score2 == 3:
		$campeao.text = "Player 2 ganhou!"
		win_the_game()
		return true
	
	if player1.is_dead:
		score2 += 1
	else:
		score1 += 1
	update_score(score1,score2)
	
	return false



func win_the_game() -> void:
	$GridContainer/JogarDeNovo.show()



func _on_sair_pressed() -> void:
	pass # Replace with function body.


func _on_jogar_de_novo_pressed() -> void:
	get_tree().reload_current_scene()
