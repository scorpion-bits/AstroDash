extends CharacterBody2D
class_name StoryPlayer

@export var speed: float = 350.0

@onready var health_comp: HealthComponent = $HealthComponent
@onready var weapon_comp: WeaponComponent = $WeaponComponent
@onready var sprite: Sprite2D = $Sprite2D 
@onready var energy_bar: ProgressBar = $PlayerUI/EnergyBar
@onready var health_bar: ProgressBar = $PlayerUI/HealthBar

func _ready() -> void:
	if health_comp:
		health_comp.health_changed.connect(_on_health_changed)
		health_comp.died.connect(_on_died)
		
		health_bar.max_value = health_comp.max_health
		health_bar.value = health_comp.current_health
		
	if weapon_comp:
		weapon_comp.energy_changed.connect(_on_energy_changed)
		energy_bar.max_value = weapon_comp.max_energy
		energy_bar.value = weapon_comp.current_energy

func _physics_process(delta: float) -> void:
	
	var direction = Input.get_vector("left_1", "right_1", "up_1", "down_1")
	if direction != Vector2.ZERO:
		velocity = direction * speed
		var target_angle = direction.angle() + (PI / 2)
		rotation = lerp_angle(rotation, target_angle, 15.0 * delta)
	else:
		velocity = Vector2.ZERO
		
	move_and_slide()
	
	if Input.is_action_pressed("ui_accept"):
		if weapon_comp:
			weapon_comp.shoot(Vector2.UP)
			
	if health_comp and health_comp.is_invincible:
		sprite.modulate.a = 0.5 if Engine.get_frames_drawn() % 10 < 5 else 1.0
	else:
		sprite.modulate.a = 1.0

func _on_health_changed(current, max_hp) -> void:
	print("Player tomou dano! Vida atual: ", current, "/", max_hp)
	health_bar.value = current

func _on_energy_changed(current_energy, max_energy) -> void:
	energy_bar.value = current_energy

func _on_died() -> void:
	print("Player morreu!")
	set_collision_layer_value(1, false)
	set_collision_mask_value(2, false)
	hide()
	set_physics_process(false)
