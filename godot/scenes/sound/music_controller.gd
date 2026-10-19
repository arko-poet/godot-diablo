extends Node

@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer


func play(audio_stream: AudioStream) -> void:
	audio_stream_player.stream = audio_stream
	audio_stream_player.play()


func stop() -> void:
	audio_stream_player.stop()


func pause() -> void:
	audio_stream_player.stream_paused = true


func resume() -> void:
	audio_stream_player.stream_paused = false
