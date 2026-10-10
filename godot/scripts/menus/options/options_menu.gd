extends Node

signal closed

const InputMapperScene := preload("res://input_mapper.tscn")

@export var resolutions: Array[Vector2i]

@onready var tab_panels := [%VideoSettings, %AudioSettings, %GameSettings, %InputSettings]
@onready var audio_settings: GridContainer = %AudioSettings
@onready var input_settings: GridContainer = %InputSettings

@onready var full_screen_button: CheckButton = %FullScreenButton
@onready var resolutions_button: OptionButton = %ResolutionsButton

@onready var mute_button: CheckButton = %MuteButton

@onready var tab_bar: TabBar = %TabBar


func _ready() -> void:
	full_screen_button.button_pressed = Settings.fullscreen
	mute_button.button_pressed = Settings.mute_enabled

	for resolution in resolutions:
		resolutions_button.add_item("%sx%s" % [resolution.x, resolution.y])
	resolutions_button.select(resolutions.find(Settings.resolution))

	_populate_input_map()

	tab_bar.grab_focus()


func _on_tab_bar_tab_changed(tab: int) -> void:
	for tab_index in tab_panels.size():
		var tab_panel: Control = tab_panels[tab_index]
		tab_panel.visible = tab_index == tab


func _on_accept_options_button_pressed() -> void:
	closed.emit()
	queue_free()


func _on_full_screen_button_toggled(toggled_on: bool) -> void:
	Settings.fullscreen = toggled_on


func _on_mute_button_toggled(toggled_on: bool) -> void:
	Settings.mute_enabled = toggled_on


func _on_resolutions_button_item_selected(index: int) -> void:
	Settings.resolution = resolutions[index]


func _populate_input_map() -> void:
	for action in InputMap.get_actions():
		# ui_ corresponds to built in actions which by design are not used for remapping
		if action.begins_with("ui_"):
			continue

		for event: InputEvent in InputMap.action_get_events(action):
			var label := Label.new()
			label.text = ("%s:" % action).capitalize()
			var button := Button.new()
			button.text = InputMap.get_action_description(action)
			button.pressed.connect(_on_input_map_button_pressed.bind(action, button))
			button.custom_minimum_size = Vector2(128, 0)
			input_settings.add_child(label)
			input_settings.add_child(button)


func _on_input_map_button_pressed(action: StringName, button: Button) -> void:
	var input_map_listener: InputMapper = InputMapperScene.instantiate()
	input_map_listener.key_selected.connect(
		_on_input_map_listener_key_selected.bind(action, button)
	)
	add_child(input_map_listener)


func _on_input_map_listener_key_selected(
	event: InputEventKey,
	action: StringName,
	button: Button,
) -> void:
	Settings.remap_action_key(action, event)
	button.text = InputMap.get_action_description(action)
