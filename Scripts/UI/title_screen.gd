extends Control

const FIRST_LEVEL = "res://Scenes/side_scroller.tscn"

@onready var prompt: Label = $Prompt
@onready var blink_timer: Timer = $BlinkTimer


func _ready() -> void:
	blink_timer.timeout.connect(_on_blink_timer)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		get_tree().change_scene_to_file(FIRST_LEVEL)

func _on_blink_timer() -> void:
	prompt.visible = not prompt.visible
