extends Interactable

@export var target: Node = null

var is_pressed: bool = false

func interact(_by: Node) -> void:
	if is_pressed:
		return
	is_pressed = true
	print("button pressed!")
	if target and target.has_method("activate"):
		target.activate()
