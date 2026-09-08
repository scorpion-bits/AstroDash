extends Area2D

@export var dialogue_lines: Array[DialogueLine] = []

@export_category("Configurações do Gatilho")
@export var auto_start: bool = false
@export var interact_to_start: bool = true
@export var play_only_once: bool = true

var player_in_area: bool = false
var has_played: bool = false

func _ready():
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body):
	if body.name == "StoryPlayer":
		player_in_area = true
		if auto_start and not (play_only_once and has_played):
			start_my_dialogue()

func _on_body_exited(body):
	if body.name == "StoryPlayer":
		player_in_area = false

func _process(_delta):
	if player_in_area and interact_to_start and not (play_only_once and has_played):
		if Input.is_action_just_pressed("ui_accept"):
			start_my_dialogue()

func start_my_dialogue():
	has_played = true
	DialogueManager.start_dialogue(dialogue_lines)
