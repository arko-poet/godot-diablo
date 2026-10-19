extends Node

const TIME_LIMIT := 10.0

@export var background_music: AudioStream
@export var score_sound: AudioStream
@export var required_count := 10

var elapsed_time := 0.0:
	set(value):
		elapsed_time = value
		elapsed_time_label.text = "%.1fs/%ss" % [elapsed_time, TIME_LIMIT]
		if elapsed_time >= TIME_LIMIT:
			set_process(false)
			GameController.lose_game()
			
var count := 0:
	set(value):
		count = value
		counter_label.text = "%s/%s" % [count, required_count]
		SfxController.play(score_sound, 0.1)
		if count >= required_count:
			GameController.next_level()

@onready var elapsed_time_label: Label = %ElapsedTimeLabel
@onready var counter_label: Label = %CounterLabel


func _ready() -> void:
	MusicController.play(background_music)


func _process(delta: float) -> void:
	elapsed_time += delta


func _on_counter_button_pressed() -> void:
	count += 1
