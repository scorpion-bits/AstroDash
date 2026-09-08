extends CharacterBody2D
class_name StoryPlayer

@export var speed: float = 350.0
@export var is_in_cutscene: bool = false
@export var cutscene_direction: Vector2 = Vector2.UP

@onready var health_comp: HealthComponent = $HealthComponent
@onready var weapon_comp: WeaponComponent = $WeaponComponent
@onready var sprite: Sprite2D = $Sprite2D 
@onready var energy_bar: TextureProgressBar = $PlayerUI/EnergyBar
@onready var hurtbox: Area2D = $Hurtbox

func _ready() -> void:
	if health_comp:
		health_comp.health_changed.connect(_on_health_changed)
		health_comp.died.connect(_on_died)
		
	if weapon_comp:
		weapon_comp.energy_changed.connect(_on_energy_changed)
		energy_bar.max_value = weapon_comp.max_energy
		energy_bar.value = weapon_comp.current_energy

	if hurtbox:
		hurtbox.body_entered.connect(_on_hurtbox_body_entered)

func _on_hurtbox_body_entered(body: Node2D) -> void:
	if body.is_in_group("meteoros"):
		if health_comp:
			health_comp.take_damage(1)

func _physics_process(delta: float) -> void:
	
	if is_in_cutscene:
		if global_position.y <= 540:
			velocity = Vector2.ZERO
		else:
			velocity = cutscene_direction * (speed * 0.1) 
			
		if cutscene_direction != Vector2.ZERO:
			var target_angle = cutscene_direction.angle() + (PI / 2)
			rotation = lerp_angle(rotation, target_angle, 15.0 * delta)
			
		move_and_slide()
		return
		
	if DialogueManager.is_dialogue_active:
		velocity = Vector2.ZERO
		move_and_slide()
		return
		
	
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
	EventBus.player_health_changed.emit(current, max_hp)

func _on_energy_changed(current_energy, max_energy) -> void:
	energy_bar.value = current_energy

func _on_died() -> void:
	print("Player morreu!")
	set_collision_layer_value(1, false)
	if hurtbox:
		hurtbox.set_deferred("monitoring", false)
	hide()
	set_physics_process(false)
