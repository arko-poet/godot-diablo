extends HSlider

const _SLIDER_STEPS := 100

@export var bus_name: StringName


func _ready() -> void:
	max_value = Settings.MAX_BUS_VOLUME
	step = Settings.MAX_BUS_VOLUME / _SLIDER_STEPS
	value = Settings.get_bus_volume(bus_name)


func _on_value_changed(value: float) -> void:
	Settings.set_bus_volume(bus_name, value)
