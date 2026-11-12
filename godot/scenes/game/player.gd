extends Node2D


@export var entrance_speech: AudioStream
@export var attack_swing: AudioStream

@onready var moving_character: MovingCharacter = %MovingCharacter


func _ready() -> void:
	SfxController.play(entrance_speech)
