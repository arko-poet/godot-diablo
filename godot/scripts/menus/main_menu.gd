extends Node

@export var options_menu_scene: PackedScene
@export var credits_scene: PackedScene

@export var background_music: AudioStream

@export_file("*.tscn") var game_scene_path: String

@onready var title_label: Label = %TitleLabel
@onready var version_label: Label = %VersionLabel

@onready var start_game_button: Button = %StartGameButton
@onready var options_button: Button = %OptionsButton
@onready var credits_button: Button = %CreditsButton


func _ready() -> void:
	title_label.text = ProjectSettings.get_setting("application/config/name")
	version_label.text = ProjectSettings.get_setting("application/config/version")

	_focus()

	MusicController.play(background_music)


func _on_options_button_pressed() -> void:
	var options_menu := options_menu_scene.instantiate()
	options_menu.closed.connect(_focus)
	add_child(options_menu)


func _on_credits_button_pressed() -> void:
	var credits := credits_scene.instantiate()
	credits.closed.connect(_focus)
	add_child(credits)


func _on_start_game_button_pressed() -> void:
	GameController.load_first_level()
	#SceneLoader.load_from_path(game_scene_path)


func _focus() -> void:
	start_game_button.grab_focus()
