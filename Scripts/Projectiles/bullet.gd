extends Hitbox

const SPEED = 500

var direction: int = 1



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	area_entered.connect(_on_area_entered)
	await get_tree().create_timer(2.0).timeout
	queue_free()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position.x += SPEED * direction * delta

func _on_area_entered(_area: Area2D) -> void:
	queue_free()
