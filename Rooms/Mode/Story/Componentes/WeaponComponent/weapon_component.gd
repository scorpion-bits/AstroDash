extends Node2D
class_name WeaponComponent

signal energy_changed(current_energy, max_energy)
signal out_of_energy

@onready var shoot_point: Marker2D = $ShootPoint

@export var projectile_scene: PackedScene

@export var max_energy: float = 100.0
@export var energy_cost_per_shot: float = 20.0
@export var energy_recovery_rate: float = 20.0 
@export var cooldown_time: float = 0.2 

var current_energy: float
var can_shoot: bool = true
var time_since_last_shot: float = 0.0
var is_recovering: bool = false

func _ready() -> void:
	current_energy = max_energy

func _process(delta: float) -> void:
	time_since_last_shot += delta
	
	if time_since_last_shot > 2.0 and current_energy < max_energy:
		current_energy += energy_recovery_rate * delta
		current_energy = min(current_energy, max_energy)
		energy_changed.emit(current_energy, max_energy)

func shoot(direction: Vector2 = Vector2.UP) -> void:
	if time_since_last_shot < cooldown_time:
		return
		
	if current_energy < energy_cost_per_shot:
		out_of_energy.emit()
		return
		
	time_since_last_shot = 0.0
	current_energy -= energy_cost_per_shot
	energy_changed.emit(current_energy, max_energy)
	
	if projectile_scene:
		var projectile = projectile_scene.instantiate()
		get_tree().current_scene.add_child(projectile)
		projectile.global_position = shoot_point.global_position
		projectile.rotation = direction.angle()
