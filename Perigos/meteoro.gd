extends RigidBody2D

func _ready() -> void:
	$VisibleOnScreenNotifier2D.screen_exited.connect(queue_free)
