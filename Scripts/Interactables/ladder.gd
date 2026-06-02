extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	
func _on_body_entered(body: Node2D) -> void:
	if body.has_method("enter_ladder"):
		body.enter_ladder()
		print("_on_body_entered")
		
func _on_body_exited(body: Node2D) -> void:
	if body.has_method("exit_ladder"):
		body.exit_ladder()
