class_name InputMapper extends Node

signal key_selected(event: InputEventKey)

const MODIFIER_KEYCODES := [KEY_SHIFT, KEY_CTRL, KEY_ALT, KEY_META]


func _input(event):
	if not event is InputEventKey:
		return
	
	if (event.keycode in MODIFIER_KEYCODES) != event.pressed:
		key_selected.emit(event)
		queue_free()
