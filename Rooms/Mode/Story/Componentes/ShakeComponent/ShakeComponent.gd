extends Node
class_name ShakeComponent

@export var target : Node2D
@export var amplitude : float
@export var frequency : float
@export var duration : float
@export var smoothing : Tween.TransitionType

var original_position : Vector2

var tween : Tween

func _ready() -> void:
	original_position = target.position

func trigger_x():
	reset_tween()
	tween = create_tween()
	var iteration_duration = 1.0 / frequency
	var total_iterations : int = duration / iteration_duration
	var iteration_percentage = 1.0 / total_iterations

	var i = total_iterations

	while i > 0:
		var offset : Vector2
		if i % 2 ==  0:
			offset = Vector2(original_position.x + i * iteration_percentage * amplitude, original_position.y)
		else:
			offset = Vector2(original_position.x + -i * iteration_percentage * amplitude, original_position.y)
		tween.tween_property(target, "position", offset, 1.0 / frequency)
		i -= 1

	tween.tween_property(target, "position", original_position, 0.0)

func trigger_y():
	reset_tween()
	tween = create_tween()
	var iteration_duration = 1.0 / frequency
	var total_iterations : int = duration / iteration_duration
	var iteration_percentage = 1.0 / total_iterations

	var i = total_iterations

	while i > 0:
		var offset : Vector2
		if i % 2 ==  0:
			offset = Vector2(original_position.x, original_position.y + i * iteration_percentage * amplitude)
		else:
			offset = Vector2(original_position.x, original_position.y + -i * iteration_percentage * amplitude)
		tween.tween_property(target, "position", offset, 1.0 / frequency)
		i -= 1

	tween.tween_property(target, "position", original_position, 0.0)

func trigger():
	reset_tween()
	tween = create_tween()
	var iteration_duration = 1.0 / frequency
	var total_iterations : int = duration / iteration_duration
	var iteration_percentage = 1.0 / total_iterations

	var i = total_iterations
	var round = 0

	while i > 0:
		var offset : Vector2
		if round ==  0:
			offset = Vector2(original_position.x + -i * iteration_percentage * amplitude, original_position.y + -i * iteration_percentage * amplitude)
		elif round == 1:
			offset = Vector2(original_position.x + i * iteration_percentage * amplitude, original_position.y + -i * iteration_percentage * amplitude)
		elif round == 2:
			offset = Vector2(original_position.x + -i * iteration_percentage * amplitude, original_position.y + i * iteration_percentage * amplitude)
		else:
			offset = Vector2(original_position.x + i * iteration_percentage * amplitude, original_position.y + i * iteration_percentage * amplitude)

		tween.tween_property(target, "position", offset, 1.0 / frequency).set_trans(smoothing).set_ease(Tween.EASE_IN_OUT)
		i -= 1

		if round > 3:
			round = 0
		else:
			round += 1

	tween.tween_property(target, "position", original_position, 0.0)

func reset_tween():
	if tween:
		tween.kill()
		target.position = original_position
