extends Node

@export_file("*.tscn") var _levels: Array[String]

var _current_level := 0


func load_first_level() -> void:
	SceneLoader.load_from_path(_levels[0])


func win_game() -> void:
	SceneLoader.load_main_menu()


func lose_game() -> void:
	SceneLoader.load_main_menu()


func next_level() -> void:
	_current_level += 1
	if _current_level < _levels.size():
		SceneLoader.load_from_path(_levels[_current_level])
	else:
		win_game()


func restart_level() -> void:
	SceneLoader.restart()


func start_level(index: int) -> void:
	_current_level = index
	SceneLoader.load_from_path(_levels[index])
