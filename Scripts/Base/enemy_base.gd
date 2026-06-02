class_name EnemyBase
extends CharacterBody2D

@export var max_health: int = 3
@export var score_value: int = 100
@export var touch_damage: int = 10

var health: int
var base_color: Color

@onready var hurtbox: Area2D = $Hurtbox
@onready var sprite: Sprite2D = $Sprite2D


func _ready() -> void:
	add_to_group("enemies")
	health = max_health
	base_color = sprite.modulate
	hurtbox.area_entered.connect(_on_hurtbox_area_entered)
	if has_node("Hitbox"):
		$Hitbox.damage = touch_damage


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	_movement(delta)
	move_and_slide()


# Override in subclasses for custom movement. Default = standing still.
func _movement(_delta: float) -> void:
	pass


func take_damage(amount: int) -> void:
	health -= amount
	if health <= 0:
		_die()
		return
	_flash()

func _flash() -> void:
	sprite.modulate = Color.WHITE_SMOKE
	await get_tree().create_timer(0.08).timeout
	if is_instance_valid(self):
		sprite.modulate = base_color
func _die() -> void:
	GameState.add_score(score_value)
	queue_free()


func _on_hurtbox_area_entered(area: Area2D) -> void:
	if area is Hitbox:
		take_damage(area.damage)
