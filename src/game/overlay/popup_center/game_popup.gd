class_name GamePopup extends Control

@warning_ignore("unused_signal")
signal closing(popup: GamePopup)

@export var pause_game: bool = false

var first_start: bool = true

# Called when the node enters the scene tree for the first time.
func _ready():
	process_mode = PROCESS_MODE_ALWAYS

func should_pause_game() -> bool:
	return pause_game

func initial_show():
	pass

func unstore_popup():
	if first_start:
		first_start = false
		initial_show()
	pass

func store_popup():
	pass

func destroy():
	pass