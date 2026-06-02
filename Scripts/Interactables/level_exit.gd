extends Interactable

@export var require_all_enemies_dead: bool = true

func interact (_by: Node) -> void:
	if not _requirements_met():
		print("cannot exit yet.")
		return
	GameState.complete_level()

func _requirements_met() -> bool:
	if require_all_enemies_dead:
		if not get_tree().get_nodes_in_group("enemies").is_empty():
			return false
	return true
