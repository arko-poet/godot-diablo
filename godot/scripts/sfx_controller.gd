extends Node

@export var _audio_stream_pool_size := 16

var _audio_stream_player_pool: Array[AudioStreamPlayer]


func _ready() -> void:
	for i in _audio_stream_pool_size:
		var audio_stream_player := AudioStreamPlayer.new()
		audio_stream_player.bus = "SFX"

		_audio_stream_player_pool.append(audio_stream_player)
		add_child(audio_stream_player)


func play(audio_stream: AudioStream, pitch_variation: float = 0.0) -> void:
	for player in _audio_stream_player_pool:
		if not player.playing:
			player.stream = audio_stream
			player.pitch_scale = 1.0 + randf_range(-pitch_variation, pitch_variation)
			player.play()
			break
