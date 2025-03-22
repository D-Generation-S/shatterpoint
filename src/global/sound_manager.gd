class_name SoundManager extends Node

@export var number_of_predefined_sound_players: int = 0

func _ready():
	for i in range(number_of_predefined_sound_players):
		_create_and_add_sound_player()

func _get_sound_player() -> AudioStreamPlayer2D:
	var return_player: AudioStreamPlayer2D = null
	for player in get_children():
		if player is AudioStreamPlayer2D:
			if !player.playing:
				return_player = player
	if return_player == null:
		return_player = _create_and_add_sound_player()

	return return_player

func _create_and_add_sound_player() -> AudioStreamPlayer2D:
	var stream_player = AudioStreamPlayer2D.new()
	var count = get_child_count() + 1
	stream_player.name = "Player_" + str(count)
	stream_player.bus = "sfx"
	stream_player.autoplay = false

	add_child(stream_player)
	return stream_player

func play_sound(sound: AudioStream, volume: float = 1):
	var listener = get_tree().get_nodes_in_group("audio_listener")
	if listener.size() == 0:
		printerr("No listener in scene!")
		return

	var selected_listener: AudioListener2D = null
	for output in listener:
		if output is AudioListener2D:
			if output.is_current():
				selected_listener = output
			break

	if selected_listener == null:
		printerr("No active listener found!")
		return	

	play_sound_at_position(selected_listener.global_position, sound, 2000, 1, volume)

func play_sound_at_position(position: Vector2,
							sound: AudioStream,
							distance_in_pixel: int = 2000,
							pitch: float = 1,
							volume: float = 0
						   ):
	if sound == null:
		return
	var audio_stream = _get_sound_player()
	audio_stream.max_distance = distance_in_pixel
	audio_stream.pitch_scale = pitch
	audio_stream.volume_db = volume
	audio_stream.global_position = position

	audio_stream.stream = sound		
	audio_stream.play()
	