extends Node2D

var astar := AStarGrid2D.new()

@onready var player: CharacterBody2D = %Player
@onready var floor_layer: TileMapLayer = %FloorLayer


func _ready() -> void:
	astar.region = floor_layer.get_used_rect()
	astar.cell_size = floor_layer.tile_set.tile_size
	astar.offset = floor_layer.tile_set.tile_size * 0.5
	astar.default_compute_heuristic = AStarGrid2D.HEURISTIC_OCTILE
	astar.default_estimate_heuristic = AStarGrid2D.HEURISTIC_OCTILE
	astar.cell_shape = AStarGrid2D.CELL_SHAPE_ISOMETRIC_DOWN
	astar.update()


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			player.move(floor_layer.local_to_map(get_local_mouse_position()))
			get_viewport().set_input_as_handled()
