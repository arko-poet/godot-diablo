extends Node

@export var loading_screen_scene: PackedScene
@export_file("*.tscn") var main_menu_scene_path: String

var loading_screen: LoadingScreen
var _loading_scene_path: String


func _ready() -> void:
	set_process(false)


func _process(_delta: float) -> void:
	var progress: Array
	var status = ResourceLoader.load_threaded_get_status(_loading_scene_path, progress)
	match status:
		ResourceLoader.THREAD_LOAD_IN_PROGRESS:
			loading_screen.update_progress(progress[0])
		ResourceLoader.THREAD_LOAD_FAILED:
			push_error("Scene Loading Failed")
			set_process(false)
		ResourceLoader.THREAD_LOAD_LOADED:
			load_from_packed(ResourceLoader.load_threaded_get(_loading_scene_path))
			loading_screen.queue_free()
			set_process(false)


func load_main_menu() -> void:
	load_from_path(main_menu_scene_path)


func load_from_packed(packed_scene: PackedScene) -> void:
	get_tree().change_scene_to_packed(packed_scene)


func load_from_path(scene_path: String) -> void:
	loading_screen = loading_screen_scene.instantiate()
	add_child(loading_screen)

	_loading_scene_path = scene_path
	ResourceLoader.load_threaded_request(scene_path)
	set_process(true)


func restart() -> void:
	get_tree().reload_current_scene()
