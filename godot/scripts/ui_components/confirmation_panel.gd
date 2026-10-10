class_name ConfirmationPanel
extends PanelContainer

signal responded(accepted: bool)

@onready var _prompt_label: Label = %PromptLabel
@onready var _cancel_button: Button = %CancelButton
@onready var _accept_button: Button = %AcceptButton


func setup(prompt_text: String, cancel_text: String, accept_text: String) -> void:
	if not is_node_ready():
		await ready

	_prompt_label.text = prompt_text
	_cancel_button.text = cancel_text
	_accept_button.text = accept_text
	
	_accept_button.grab_focus()


func _on_cancel_button_pressed() -> void:
	responded.emit(false)
	queue_free()


func _on_accept_button_pressed() -> void:
	responded.emit(true)
	queue_free()
