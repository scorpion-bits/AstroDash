extends Area2D
class_name Sucata

@export var speed: float = 150.0
var direction: Vector2 = Vector2.ZERO

signal collected

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	$VisibleOnScreenNotifier2D.screen_exited.connect(_on_screen_exited)

func _process(delta: float) -> void:
	position += direction * speed * delta
	rotation += 2.0 * delta

func _on_body_entered(body: Node2D) -> void:
	if body is StoryPlayer:
		collected.emit()
		queue_free()

func _on_screen_exited() -> void:
	queue_free()
