extends Node2D

@export var bgm: AudioStream

var astar := AStarGrid2D.new()

@onready var player: CharacterBody2D = %Player
@onready var floor_layer: TileMapLayer = %FloorLayer
@onready var obstacle_layer: TileMapLayer = %ObstacleLayer
@onready var pathing_layer: TileMapLayer = %PathingLayer

@onready var player_position: Label = %PlayerPosition
@onready var mouse_position: Label = %MousePosition
@onready var mouse_tile: Label = %MouseTile
@onready var player_tile: Label = %PlayerTile


func _ready() -> void:
	MusicController.play(bgm)

	_setup_astar()

	#player.grid = floor_layer


func _process(_delta: float) -> void:
	player_position.text = "%s" % player.position
	mouse_position.text = "%s" % get_global_mouse_position()
	mouse_tile.text = "%s" % pathing_layer.local_to_map(get_local_mouse_position())
	player_tile.text = "%s" % pathing_layer.local_to_map(player.target_position)


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			var target_cell := pathing_layer.local_to_map(pathing_layer.get_local_mouse_position()) - Vector2i.ONE
			var player_cell := pathing_layer.local_to_map(player.target_position)
			print("--")
			print(player_cell)
			print(target_cell)
			var path := astar.get_point_path(player_cell, target_cell)
			if not path:
				return
			path.remove_at(0) # the first one is where player already is
			player.path = path
			get_viewport().set_input_as_handled()


func _setup_astar() -> void:
	var used_rect := pathing_layer.get_used_rect()
	print(used_rect)
	#used_rect.position += Vector2i.ONE
	
	astar.region = used_rect
	astar.cell_size = pathing_layer.tile_set.tile_size
	#astar.offset = -floor_layer.tile_set.tile_size
	astar.default_compute_heuristic = AStarGrid2D.HEURISTIC_OCTILE
	astar.default_estimate_heuristic = AStarGrid2D.HEURISTIC_OCTILE
	astar.cell_shape = AStarGrid2D.CELL_SHAPE_ISOMETRIC_DOWN
	astar.update()

	for cell in pathing_layer.get_used_cells():
		if used_rect.has_point(cell - Vector2i.ONE):
			astar.set_point_solid(cell - Vector2i.ONE)
