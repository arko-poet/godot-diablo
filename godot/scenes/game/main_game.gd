extends Node2D

@export var bgm: AudioStream

var astar := AStarGrid2D.new()
var monster_tiles: Array[Vector2i]
var hovered_target: Node2D

@onready var player: CharacterBody2D = %Player
@onready var floor_layer: TileMapLayer = %FloorLayer
@onready var obstacle_layer: TileMapLayer = %ObstacleLayer
@onready var pathing_layer: TileMapLayer = %PathingLayer

@onready var player_position: Label = %PlayerPosition
@onready var mouse_position: Label = %MousePosition
@onready var mouse_tile: Label = %MouseTile
@onready var player_tile: Label = %PlayerTile

@onready var canvas_modulate: CanvasModulate = %CanvasModulate

@onready var monsters: Node = %Monsters


func _ready() -> void:
	MusicController.play(bgm)

	_setup_astar()
	_initialise_monster_tiles()

	canvas_modulate.show()


func _process(_delta: float) -> void:
	player_position.text = "%s" % player.position
	mouse_position.text = "%s" % get_global_mouse_position()
	mouse_tile.text = "%s" % pathing_layer.local_to_map(get_local_mouse_position())
	player_tile.text = "%s" % pathing_layer.local_to_map(player.target_position)


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			if hovered_target:
				var monster_cell := pathing_layer.local_to_map(hovered_target.position) - Vector2i(0, 1)
				var player_cell := pathing_layer.local_to_map(player.target_position)
				var path := astar.get_point_path(player_cell, monster_cell, true)
				print(path)
				if path.size() == 0:
					return
				elif path.size() == 2 or path.size() == 1:
					player.attack(hovered_target)
				else:
					path.remove_at(0)
					path.remove_at(path.size() - 1)
					player.path = path
			else:
				var target_cell := pathing_layer.local_to_map(pathing_layer.get_local_mouse_position()) - Vector2i.ONE
				var player_cell := pathing_layer.local_to_map(player.target_position)
				var path := astar.get_point_path(player_cell, target_cell)
				print("move path = %s" % path)
				if not path:
					return
				path.remove_at(0) # the first one is where player already is
				player.path = path
			get_viewport().set_input_as_handled()


func _setup_astar() -> void:
	var used_rect := pathing_layer.get_used_rect()

	astar.region = used_rect
	astar.cell_size = pathing_layer.tile_set.tile_size
	astar.default_compute_heuristic = AStarGrid2D.HEURISTIC_OCTILE
	astar.default_estimate_heuristic = AStarGrid2D.HEURISTIC_OCTILE
	astar.cell_shape = AStarGrid2D.CELL_SHAPE_ISOMETRIC_DOWN
	astar.update()

	for cell in pathing_layer.get_used_cells():
		if used_rect.has_point(cell - Vector2i.ONE):
			astar.set_point_solid(cell - Vector2i.ONE)


func _initialise_monster_tiles() -> void:
	for monster: Node2D in monsters.get_children():
		var monster_tile := pathing_layer.local_to_map(monster.position) - Vector2i(0, 1)
		monster_tiles.append(monster_tile)
		astar.set_point_solid(monster_tile)


func _on_monster_hovered(monster_reference: Node2D) -> void:
	hovered_target = monster_reference


func _on_monster_died(monster_position: Vector2) -> void:
	var monster_tile := pathing_layer.local_to_map(monster_position) - Vector2i(0, 1)
	astar.set_point_solid(monster_tile, false)
	monster_tiles.erase(monster_tile)
