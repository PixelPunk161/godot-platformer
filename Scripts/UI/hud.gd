extends CanvasLayer

@export var player: Node = null

@onready var score_label: Label = $ScoreLabel
@onready var lives_label: Label = $LivesLabel
@onready var health_label: Label = $HealthLabel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameState.score_changed.connect(_on_score_changed)
	GameState.lives_changed.connect(_on_lives_changed)
	
	_on_score_changed(GameState.score)
	_on_lives_changed(GameState.lives)
	
	if player:
		player.health_changed.connect(_on_health_changed)
		_on_health_changed(player.health)
	
func _on_score_changed(new_score: int) -> void:
	score_label.text = "Score: " + str(new_score)

func _on_lives_changed(new_lives: int) -> void:
	lives_label.text = "Lives: " + str(new_lives)
	
func _on_health_changed(new_health: int) -> void:
	health_label.text = "Health: " + str(new_health)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
