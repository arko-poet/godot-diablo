extends CanvasLayer

@onready var credits_label: RichTextLabel = %CreditsLabel

func _ready() -> void:
	credits_label.text = credits_label.text % ProjectSettings.get_setting("application/config/name")


func _on_exit_credits_button_pressed() -> void:
	queue_free()
