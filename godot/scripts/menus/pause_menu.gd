extends CanvasLayer

const ConfirmationPanelScene := preload("res://scenes/ui_components/confirmation_panel.tscn")

@export var options_menu_scene: PackedScene

@onready var options_button: Button = %OptionsButton


func _ready() -> void:
	if visible:
		toggle_pause()


func _input(event: InputEvent) -> void:
	if (event.is_action("ui_cancel") or event.is_action("pause")) and event.is_pressed():
		get_viewport().set_input_as_handled()
		toggle_pause()


func toggle_pause() -> void:
	visible = not visible
	get_tree().paused = visible
	
	if visible:
		options_button.grab_focus()


func _on_options_button_pressed() -> void:
	var options_menu := options_menu_scene.instantiate()
	add_child(options_menu)


func _on_resume_button_pressed() -> void:
	toggle_pause()


func _on_main_menu_button_pressed() -> void:
	var confirmation_panel: ConfirmationPanel = ConfirmationPanelScene.instantiate()
	confirmation_panel.setup("Exit to Main Menu?", "No", "Yes")
	confirmation_panel.responded.connect(_on_main_menu_confirmed)
	add_child(confirmation_panel)


func _on_main_menu_confirmed(accepted: bool) -> void:
	if accepted:
		toggle_pause()
		SceneLoader.load_main_menu()


func _on_exit_button_pressed() -> void:
	var confirmation_panel: ConfirmationPanel = ConfirmationPanelScene.instantiate()
	confirmation_panel.setup("Exit Game?", "No", "Yes")
	confirmation_panel.responded.connect(_on_exit_confirmed)
	add_child(confirmation_panel)


func _on_exit_confirmed(accepted: bool) -> void:
	if accepted:
		get_tree().quit()


func _on_restart_button_pressed() -> void:
	SceneLoader.restart()
