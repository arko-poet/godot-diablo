extends Node2D

signal hovered(monster: Node2D)
signal died(position: Vector2)

@onready var moving_character: MovingCharacter = %MovingCharacter
@onready var outline_shader: ShaderMaterial = moving_character.material


func hit(damage: int) -> void:
	moving_character.hit(damage)


func _on_area_2d_mouse_entered() -> void:
	outline_shader.set_shader_parameter(&"enabled", true)
	hovered.emit(self)


func _on_area_2d_mouse_exited() -> void:
	outline_shader.set_shader_parameter(&"enabled", false)
	hovered.emit(null)


func _on_moving_character_died() -> void:
	died.emit(position)
	queue_free()
