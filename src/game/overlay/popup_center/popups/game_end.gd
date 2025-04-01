class_name GameEnd extends GamePopup

@export var reached_wave_translation: String = "REACHED_WAVE"
	 

@onready var reached_wave_label: Label = %ReachedWave

var wave_reached: int

func _ready():
	super()
	reached_wave_label.text = tr(reached_wave_translation) % wave_reached

func set_current_wave(wave: int):
	wave_reached = wave

func restart_game():
	destroy()
	get_tree().reload_current_scene()
