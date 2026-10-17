extends Node2D

@onready var player: CharacterBody2D = %Player
@onready var floor_layer: TileMapLayer = %FloorLayer


func _ready() -> void:
	pass


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			player.move(floor_layer.local_to_map(get_local_mouse_position()))
			get_viewport().set_input_as_handled()
