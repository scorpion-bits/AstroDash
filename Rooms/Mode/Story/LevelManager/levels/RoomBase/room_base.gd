extends Node2D
class_name RoomBase

@export var room_background: Texture2D

@onready var background_sprite: TextureRect  = $Background
@onready var portal: Area2D = $Portal

func _ready() -> void:
	if room_background and background_sprite:
		background_sprite.texture = room_background
	
	if portal:
		portal.hide()
		portal.set_deferred("monitoring", false)
		portal.body_entered.connect(_on_portal_entered)

func finish_room() -> void:
	
	StoryLevelManager.save_game()
	
	if portal:
		portal.show()
		portal.set_deferred("monitoring", true)
		
func _on_portal_entered(body: Node2D) -> void:
	if body is StoryPlayer:
		StoryLevelManager.advance_to_next_phase()
