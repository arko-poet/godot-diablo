extends Node

@onready var tab_panels := [%VideoSettings, %AudioSettings, %GameSettings]


func _on_tab_bar_tab_changed(tab: int) -> void:
	for tab_index in tab_panels.size():
		var tab_panel: Control = tab_panels[tab_index]
		if tab_index == tab:
			tab_panel.show()
		else:
			tab_panel.hide()


func _on_accept_options_button_pressed() -> void:
	queue_free()
