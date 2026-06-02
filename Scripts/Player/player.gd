extends CharacterBody2D

signal health_changed(new_health: int)

const SPEED = 200.0
const JUMP_VELOCITY = -350.0
const MAX_HEALTH = 100
const INVINCIBILITY_DURATION = 1.5
const BULLET = preload("res://Scenes/Projectiles/bullet.tscn")
const CLIMB_SPEED = 100

var health: int = MAX_HEALTH
var is_invincible: bool = false
var spawn_position: Vector2
var facing_direction: int = 1
var can_climb: bool = false
var is_climbing: bool = false
var nearby_interactables: Array[Interactable] = []

@onready var sprite: Sprite2D = $Sprite2D
@onready var hurtbox: Area2D = $Hurtbox
@onready var shoot_point: Marker2D = $Shootpoint
@onready var interact_detector: Area2D = $InteractDetector

func _ready() -> void:
	spawn_position = global_position
	hurtbox.area_entered.connect(_on_hurtbox_area_entered)
	interact_detector.area_entered.connect(_on_interact_area_entered)
	interact_detector.area_exited.connect(_on_interact_area_exited)

func _physics_process(delta: float) -> void:
	if can_climb and not is_climbing:
		if Input.is_action_just_pressed("climb_up") or Input.is_action_just_pressed("climb_down"):
			is_climbing = true
			print("started climbing")
	if is_climbing:
		_do_climbing(delta)
	else:
		_do_walking(delta)
	
	if Input.is_action_just_pressed("shoot"):
		_shoot()
		
	if Input.is_action_just_pressed("interact"):
		_try_interact()

	move_and_slide()
	
func _do_walking(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

# Get the input direction and handle the movement/deceleration.
# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * SPEED
		facing_direction = int(direction)
		sprite.flip_h = facing_direction == -1
		shoot_point.position.x = abs(shoot_point.position.x) * facing_direction
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

func _do_climbing(_delta: float) -> void:
	var climb_dir := Input.get_axis("climb_up", "climb_down")
	velocity.y = climb_dir * CLIMB_SPEED
	velocity.x = 0
	
	if Input.is_action_just_pressed("jump"):
		is_climbing = false
		velocity.y = JUMP_VELOCITY

func _shoot() -> void:
	var bullet = BULLET.instantiate()
	get_parent().add_child(bullet)
	bullet.global_position = shoot_point.global_position
	bullet.direction = facing_direction

func take_damage(amount: int) -> void:
	if is_invincible:
		return
		
	health -= amount
	health_changed.emit(health)
		
	if health <= 0:
		_die()
		return
		
	_start_invicibility()
		
func _start_invicibility() -> void:
	is_invincible = true
	sprite.modulate = Color(1, 0.5, 0.5)
		
	await get_tree().create_timer(INVINCIBILITY_DURATION).timeout
		
	sprite.modulate = Color.WHITE
	is_invincible = false
		
func _die() -> void:
	GameState.lose_life()
	if GameState.lives > 0:
		_respawn()
	
func  _respawn() -> void:
	health = MAX_HEALTH
	health_changed.emit(health)
	global_position = spawn_position
	_start_invicibility()

func enter_ladder() -> void:
	can_climb = true
	print("entered ladder, can climb=", can_climb)

func exit_ladder() -> void:
	can_climb = false
	is_climbing = false
func _on_hurtbox_area_entered(area: Area2D) -> void:
	if area is Hitbox:
		take_damage(area.damage)
	
func _try_interact() -> void:
	if nearby_interactables.is_empty():
		return
	nearby_interactables[-1].interact(self)

func _on_interact_area_entered(area: Area2D) -> void:
	if area is Interactable:
		nearby_interactables.append(area)
		
func _on_interact_area_exited(area: Area2D) -> void:
	if area is Interactable:
		nearby_interactables.erase(area)
