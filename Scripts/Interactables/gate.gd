extends StaticBody2D

@onready var collision: CollisionShape2D = $CollisionShape2D
@onready var sprite: Sprite2D = $Sprite2D

func activate() -> void:
	print("gate opening!")
	collision.set_deferred("disabled", true)
	sprite.modulate.a = 0.3
