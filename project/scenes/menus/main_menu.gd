extends Node

@export var game_scene: PackedScene
@export var options_menu_scene: PackedScene
@export var credits_scene: PackedScene

@onready var title_label: Label = %TitleLabel
@onready var version_label: Label = %VersionLabel

@onready var start_game_button: Button = %StartGameButton
@onready var options_button: Button = %OptionsButton
@onready var credits_button: Button = %CreditsButton


func _ready() -> void:
	title_label.text = ProjectSettings.get_setting("application/config/name")
	version_label.text = ProjectSettings.get_setting("application/config/version")


func _on_options_button_pressed() -> void:
	var options_menu := options_menu_scene.instantiate()
	add_child(options_menu)


func _on_credits_button_pressed() -> void:
	var credits := credits_scene.instantiate()
	add_child(credits)


func _on_start_game_button_pressed() -> void:
	var game := game_scene.instantiate()
	get_tree().root.add_child(game)
	queue_free()
