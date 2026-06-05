extends EnemyBase

@export var move_speed: float = 80.0

var direction: int = -1

func _movement(_delta: float) -> void:
	if is_on_wall():
		direction *= -1
		sprite.flip_h = direction == -1
	velocity.x = move_speed * direction
