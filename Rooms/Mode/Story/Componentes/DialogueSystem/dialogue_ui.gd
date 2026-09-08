extends CanvasLayer

signal dialogue_finished

@onready var background = $Background
@onready var portrait = $Background/Portrait
@onready var name_label = $Background/NameLabel
@onready var text_label = $Background/TextLabel
@onready var type_timer = $TypeTimer
@onready var voice_player = $VoicePlayer

var lines: Array[DialogueLine] = []
var current_line_index: int = 0

var is_typing: bool = false
var text_to_type: String = ""
var type_index: int = 0
var blip_counter: int = 0
var current_line_data: DialogueLine

func _ready():
	background.hide()
	type_timer.timeout.connect(_on_type_timer_timeout)

func start_dialogue(dialogue_lines: Array):
	lines = dialogue_lines
	current_line_index = 0
	background.show()
	show_current_line()

func show_current_line():
	if current_line_index >= lines.size():
		end_dialogue()
		return
		
	current_line_data = lines[current_line_index]
	
	name_label.text = current_line_data.speaker_name
	text_to_type = current_line_data.text
	text_label.text = text_to_type
	text_label.visible_characters = 0 
	
	if current_line_data.portrait != null:
		portrait.texture = current_line_data.portrait
		portrait.show()
	else:
		portrait.hide()
		
	voice_player.stream = current_line_data.voice_blip
	
	type_index = 0
	blip_counter = 0
	is_typing = true
	
	if current_line_data.chars_per_second > 0:
		type_timer.wait_time = 1.0 / current_line_data.chars_per_second
		type_timer.start()
	else:
		text_label.visible_characters = -1 
		is_typing = false

func _process(_delta):
	if not background.visible:
		return
		
	if Input.is_action_just_pressed("ui_accept"): 
		if is_typing:
			is_typing = false
			type_timer.stop()
			text_label.visible_characters = -1
		else:
			current_line_index += 1
			show_current_line()

func _on_type_timer_timeout():
	if not is_typing:
		return
		
	type_index += 1
	text_label.visible_characters = type_index
	
	var current_char = text_to_type[type_index - 1]
	
	if voice_player.stream != null and current_char != " " and current_char != "\n":
		blip_counter += 1
		if blip_counter >= current_line_data.blip_frequency:
			blip_counter = 0
			voice_player.pitch_scale = current_line_data.pitch_base + randf_range(-current_line_data.pitch_variation, current_line_data.pitch_variation)
			voice_player.play()
			
	if type_index >= text_to_type.length():
		is_typing = false
		type_timer.stop()
		return
		
	if current_char in [".", "!", "?", ",", ":"]:
		type_timer.start(current_line_data.punctuation_pause)
	else:
		type_timer.start(1.0 / current_line_data.chars_per_second)

func end_dialogue():
	background.hide()
	emit_signal("dialogue_finished")
