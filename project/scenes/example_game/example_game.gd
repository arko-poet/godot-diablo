extends Node

var count := 0:
	set(value):
		count = value
		counter_label.text = str(count)

@onready var counter_label: Label = %CounterLabel


func _on_counter_button_pressed() -> void:
	count += 1
