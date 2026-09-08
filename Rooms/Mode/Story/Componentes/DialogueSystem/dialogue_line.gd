class_name DialogueLine
extends Resource

@export_category("Informações do Diálogo")
@export var speaker_name: String = ""
@export_multiline var text: String = ""
@export var portrait: Texture2D

@export_category("Configurações de Áudio (Voz)")
@export var voice_blip: AudioStream
@export var pitch_base: float = 1.0
@export var pitch_variation: float = 0.1
@export var blip_frequency: int = 2

@export_category("Ritmo da Digitação")
@export var chars_per_second: float = 30.0
@export var punctuation_pause: float = 0.3
