extends Node

signal lives_changed(new_lives: int)
signal score_changed(new_score: int)

const STARTING_LIVES = 3

var lives: int = STARTING_LIVES
var score: int = 0

func add_score(amount: int) -> void:
	score += amount
	score_changed.emit(score)
	
func lose_life() -> void:
	lives -= 1
	lives_changed.emit(lives)
	if lives <= 0:
		game_over()

func game_over() -> void:
	print("You Died!")
	
func reset() -> void:
	lives = STARTING_LIVES
	score = 0
	lives_changed.emit(lives)
	score_changed.emit(score)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("GameState Loaded. Lives: ", lives, ", Score: ", score)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
