class_name GameEnd extends GamePopup

signal change_current_wave(text: String)
signal change_best_wave(text: String)

var wave_reached: int

func _ready():
	super()
	change_current_wave.emit(tr("REACHED_WAVE") % wave_reached)
	
	var current_profile = GlobalSaveGameManager.get_current_profile()
	if current_profile != null:
		current_profile.save_game.statistic.highest_wave = max(current_profile.save_game.statistic.highest_wave, wave_reached)
		GlobalSaveGameManager.save_profile(current_profile)
		change_best_wave.emit(tr("BEST_WAVE") % current_profile.save_game.statistic.highest_wave)

func set_current_wave(wave: int):
	wave_reached = wave

func restart_game():
	destroy()
	get_tree().reload_current_scene()
