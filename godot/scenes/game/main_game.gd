extends Node2D

var astar := AStarGrid2D.new()

@onready var player: CharacterBody2D = %Player
@onready var floor_layer: TileMapLayer = %FloorLayer
@onready var player_position: Label = %PlayerPosition
@onready var mouse_position: Label = %MousePosition


func _ready() -> void:
	astar.region = floor_layer.get_used_rect()
	astar.cell_size = floor_layer.tile_set.tile_size
	#astar.offset = floor_layer.tile_set.tile_size * 0.5
	astar.default_compute_heuristic = AStarGrid2D.HEURISTIC_OCTILE
	astar.default_estimate_heuristic = AStarGrid2D.HEURISTIC_OCTILE
	astar.cell_shape = AStarGrid2D.CELL_SHAPE_ISOMETRIC_DOWN
	astar.update()


func _process(_delta: float) -> void:
	player_position.text = "%s" % player.position
	mouse_position.text = "%s" % get_global_mouse_position()


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			var cell := floor_layer.local_to_map(get_local_mouse_position())
			var path := astar.get_point_path(player.cell, cell)
			path.remove_at(0) # the first one is where player already is
			player.move(path, floor_layer)
			get_viewport().set_input_as_handled()
