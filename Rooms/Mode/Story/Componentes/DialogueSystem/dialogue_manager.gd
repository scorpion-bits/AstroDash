extends Node

signal dialogue_started
signal dialogue_ended

const DIALOGUE_UI_SCENE = preload("res://Huds/Dialogo/dialogue_ui.tscn")
var dialogue_ui_instance: CanvasLayer

var is_dialogue_active: bool = false

func _ready():
	dialogue_ui_instance = DIALOGUE_UI_SCENE.instantiate()
	add_child(dialogue_ui_instance)
	
	dialogue_ui_instance.dialogue_finished.connect(_on_dialogue_finished)

func start_dialogue(lines: Array):
	if is_dialogue_active:
		return
		
	is_dialogue_active = true
	emit_signal("dialogue_started")
	
	dialogue_ui_instance.start_dialogue(lines)

func _on_dialogue_finished():
	is_dialogue_active = false
	emit_signal("dialogue_ended")
