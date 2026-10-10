extends CanvasLayer

signal closed

@onready var credits_label: RichTextLabel = %CreditsLabel
@onready var exit_credits_button: Button = %ExitCreditsButton


func _ready() -> void:
	credits_label.text = credits_label.text % ProjectSettings.get_setting("application/config/name")

	exit_credits_button.grab_focus()

func _on_exit_credits_button_pressed() -> void:
	closed.emit()
	queue_free()
